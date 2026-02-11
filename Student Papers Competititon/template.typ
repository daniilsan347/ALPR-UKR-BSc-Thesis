#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/numbly:0.1.0": numbly

#let culine(text, sides: 1fr, left: auto, right: auto) = {
  let (left, right) = (left, right)
  if left == auto { left = sides }
  if right == auto { right = sides }
  let spacer = underline(extent: 10000cm)[#sym.space.nobreak]
  let hack(width) = box(width: width, clip: true, outset: (y: 1em), spacer)
  hack(left)
  underline(text)
  hack(right)
}

#let config(body) = {
  // Відступ між рядками
  let line-spacing = .65em * 1.5

  // Налаштування сторінки
  set page(
    paper: "a4",
    margin: (left: 3cm, right: 1cm, y: 2cm),
    numbering: "1",
  )

  // Налаштування тексту
  set text(
    size: 14pt,
    font: "Times New Roman",
    hyphenate: false,
    lang: "uk",
  )
  set par(
    justify: true,
    leading: line-spacing,
    spacing: line-spacing,
    first-line-indent: (amount: 1cm, all: true),
  )
  set block(
    spacing: line-spacing,
  )

  // Налаштування списків
  set enum(numbering: "1.i.")
  show: el.paragraph-enum-list.with(indent: (1cm, auto))

  // Налаштування блоків з кодом
  show: codly-init.with()
  codly(languages: codly-languages)
  show raw: set text(font: "Iosevka", size: 12pt)

  // Налаштування загловків
  show heading: set text(size: 14pt)
  show heading: set align(center)
  show heading: set block(spacing: line-spacing)
  set heading(numbering: "1.")

  show heading.where(level: 1): upper
  show heading.where(level: 3): set text(weight: "regular")
  show heading.where(level: 3): underline

  set outline(indent: 1em)
  show outline: set par(justify: true)
  show outline.entry.where(level: 1): upper
  // show outline.entry.where(level: 1): set text(weight: "bold")

  // Налаштування підписів
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption.where(kind: table): it => {
    align(right, it)
  }
  set figure.caption(separator: [ --- ])

  // Особливі терміни та симовли
  show "F1": $F_1$
  show "IoU": $upright(I o U)$
  show "IoU@": $upright(I o U)@$

  show "XX": highlight([XX (Замінити!)])

  // Виноски
  show footnote.entry: set text(size: 12pt)

  body
}

#let main-body-spacing(body) = {
  // Відступ між рядками
  let line-spacing = .65em

  set par(leading: line-spacing, spacing: line-spacing, first-line-indent: 0cm)
  set block(spacing: line-spacing)
  show heading: set block(spacing: line-spacing)
  show heading.where(level: 1): set block(below: 2em)


  body
}

#let шифр = [К-2026-03]
