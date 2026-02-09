import cv2
from ultralytics import YOLO

import os
import glob
import yaml
import time
from ocr import (
    extract_text,
    error_correct_plate,
    deskew_text_validated,
    enhance_license_plate,
)

YOLO_MODEL = YOLO("./yolo_vehicle_plate.pt")
CONFIDENCE = 0.682

EVAL_DIR = "./dataset/ocr_val/"
OUTPUT_DIR = "./output/"


def predict_objects(image, model, confidence_threshold):
    results = model(image)[0]

    output = []
    for pred_object in results.boxes.data.tolist():
        x1, y1, x2, y2, score, class_id = pred_object
        if score <= confidence_threshold:
            continue
        output.append(
            {
                "box": [x1, y1, x2, y2],
                "score": score,
                "class_id": results.names[int(class_id)],
            }
        )

    return output


def draw_frame_with_label(
    image,
    xyxy,
    label="",
    color=(0, 255, 0),
    thickness=2,
    font=cv2.FONT_HERSHEY_SIMPLEX,
    font_scale=0.7,
    font_thickness=2,
    label_color=None,
):
    img_copy = image.copy()

    x1, y1, x2, y2 = map(int, xyxy)

    cv2.rectangle(img_copy, (x1, y1), (x2, y2), color, thickness)

    if label:
        text_color = label_color if label_color is not None else color

        (text_width, text_height), _ = cv2.getTextSize(
            label, font, font_scale, font_thickness
        )

        text_x = x1
        text_y = max(y1 - 10, text_height + 10)

        cv2.rectangle(
            img_copy,
            (text_x, text_y - text_height - 10),
            (text_x + text_width, text_y),
            color,
            -1,
        )

        cv2.putText(
            img_copy,
            label,
            (text_x, text_y),
            font,
            font_scale,
            (255, 255, 255),
            font_thickness,
        )

    return img_copy


def crop_image_to_box(image, box):
    x1, y1, x2, y2 = box
    cv2.imwrite("temp/cropped.png", image[int(y1) : int(y2), int(x1) : int(x2)])
    return image[int(y1) : int(y2), int(x1) : int(x2)]


def process_license_plate(image_path):
    straightened = deskew_text_validated(image_path)
    enhanced = enhance_license_plate(straightened)
    cv2.imwrite("temp/enhanced.png", enhanced)
    return enhanced


if __name__ == "__main__":
    results = {}
    speed = []

    for image_path in glob.glob(os.path.join(EVAL_DIR, "*.png")):
        start_time = time.time()
        image = cv2.imread(image_path)
        filename = os.path.splitext(os.path.basename(image_path))[0]

        predictions = predict_objects(image, YOLO_MODEL, CONFIDENCE)
        prediction_end_time = time.time()

        for ob in predictions:
            if not ob["class_id"] == "licence_plate":
                image = draw_frame_with_label(image, ob["box"], ob["class_id"])
                continue
            plate_recognition_start_time = time.time()
            box = ob["box"]
            cropped_plate = crop_image_to_box(image, box)

            processed_plate = process_license_plate("temp/cropped.png")
            preprocess_end_time = time.time()

            text = extract_text(processed_plate)
            ocr_end_time = time.time()

            content = error_correct_plate(text)
            error_correction_end_time = time.time()

            if content[0]:
                print(f"\033[92mРозпізнаний текст: {content}\033[0m")
            else:
                print(f"\033[91mРозпізнаний текст: {content}\033[0m")

            results[filename] = content
            image = draw_frame_with_label(image, ob["box"], content[1], (255, 255, 0))

        end_time = time.time()
        print(f"Ідентифікація {prediction_end_time - start_time:.4f} сек.")
        print(
            f"Попередня обробка {preprocess_end_time - plate_recognition_start_time:.4f} сек."
        )
        print(f"Розпізнавання тексту{ocr_end_time - preprocess_end_time:.4f} сек.")
        print(f"Загалом час на {image_path}: {end_time - start_time:.2f} сек.")
        speed.append(end_time - start_time)
        cv2.imwrite(OUTPUT_DIR + filename + "_labeled.png", image)

    total_time = sum(speed)
    fps = len(speed) / total_time if total_time > 0 else 0
    print(f"Оброблено {len(speed)} зображень за {total_time:.2f} сек. FPS: {fps:.2f}")
    with open("license_plate_results_with_preprocessing.yaml", "w") as yaml_file:
        yaml.dump(results, yaml_file, default_flow_style=False)
