import easyocr
import re
import subprocess
import cv2
from itertools import permutations

OCR_READER = easyocr.Reader(["en"])
DESKEW = "Deskew/Bin/deskew.exe"


def extract_text(image):
    """Проводить розпізнавання тексту"""
    result = OCR_READER.readtext(
        image, allowlist="ABCDEHIKMNOPTXYZJ0123456789|", text_threshold=0.3
    )

    # Створює всі можливі комбінації
    possible_combinations = ["".join(p) for p in permutations([r[1] for r in result])]
    return possible_combinations


def correct_chars(text):
    POSITION_RULES = {
        "initial_chars": {  # Символи 0-1 та 6-7
            "0": "O",
            "1": "I",
            "8": "B",
            "2": "Z",
            "7": "Z",
            "|": "I",
        },
        "middle_chars": {  # Символи 2-5
            "O": "0",
            "I": "1",
            "B": "8",
            "Z": "7",
            "|": "1",
        },
    }

    corrected = list(text)

    for i, char in enumerate(corrected):
        if i in [0, 1, 6, 7]:
            corrected[i] = POSITION_RULES["initial_chars"].get(char, char)
        elif i in [2, 3, 4, 5]:
            corrected[i] = POSITION_RULES["middle_chars"].get(char, char)

    return "".join(corrected)


def error_correct_plate(text):
    PATTERN = r"[A-Z01827\|]{2}[0-9OIBZ\|]{4}[A-Z01827\|]{2}"

    for p in text:
        if not (match := re.search(PATTERN, p)):
            continue
        corrected = correct_chars(match.group())

        return (True, corrected)

    if not len(text[0]) == 8:
        return (False, text[0])
    return (False, correct_chars(text[0]))


def deskew_text_validated(image_path):
    """
    Вирівнює зображення з використанням інструменту
    https://github.com/galfar/deskew
    """
    command = [DESKEW, "-o", "temp/deskewed.png", image_path]

    try:
        _ = subprocess.run(command, capture_output=True, text=True, check=True)

        deskewed = cv2.imread("temp/deskewed.png")
        return deskewed
    except subprocess.CalledProcessError as e:
        print(f"Error running deskew: {e}")
        return cv2.imread(image_path)


def enhance_license_plate(warped_plate):
    # Перетворює на чорно-біле зображення
    if len(warped_plate.shape) == 3:
        gray = cv2.cvtColor(warped_plate, cv2.COLOR_BGR2GRAY)
    else:
        gray = warped_plate

    # Застосувати адаптивне порогування
    adaptive = cv2.adaptiveThreshold(
        gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 15, 5
    )
    _, otsu_adaptive = cv2.threshold(
        adaptive, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU
    )
    return otsu_adaptive
