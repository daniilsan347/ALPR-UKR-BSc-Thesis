#import "template.typ": *

#show: config.with()
#show heading.where(level: 1): set block(spacing: .65em * 3)
#show heading.where(level: 2): set block(spacing: .65em * 2)

#set math.equation(numbering: "(1)")
#show math.equation: set text(font: "STIX Two Math")

#page(footer: none, header: none)[
  #v(1fr)
  #align(right)[*#underline[ШИФР "#шифр"]*]
  #v(1fr)
  #align(center)[
    *#upper[Розпізнавання номерних знаків та ідентифікація типів транспортних засобів з використанням deep learning]*
  ]
  #v(2fr)
]

#outline()
#pagebreak()

#include "sections/abstract.typ"
#include "sections/introduction.typ"
#include "sections/overview.typ"
#include "sections/methodology.typ"
#include "sections/dataset.typ"
#include "sections/results.typ"

= Обговорення
= Висновки

#pagebreak()
#bibliography(
  "bibliography.bib",
  title: [Список використаних джерел],
)

