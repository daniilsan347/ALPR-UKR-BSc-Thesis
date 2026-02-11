#import "template.typ": *
#import ".personal.typ": *


#show: config.with()
#show: main-body-spacing.with()
#set text(size: 12pt)
#set page(numbering: none, margin: (x: 1.5cm, y: 2cm))
#set par(justify: false, first-line-indent: 0cm)
#show: el.paragraph-enum-list.with(indent: 0cm)

#let info(body) = {
  strong(underline(body))
}

#let signature-field(
  subscript,
  content: "",
  width: 1fr,
  bold: false,
  italic: false,
) = box(
  baseline: .8em,
  width: width,
)[
  #set par(spacing: .35em)
  #if bold and italic {
    strong(emph(culine(content)))
  } else if bold {
    strong(culine(content))
  } else if italic {
    emph(culine(content))
  } else {
    culine(content)
  }
  #align(center, text(subscript, size: .75em))
]



#h(2fr)
#box(width: 1fr)[
  Додаток 1\
  до Положення про\
  Всеукраїнський конкурс студентських наукових робіт з галузей знань і спеціальностей\
  (пункт 6 розділу IІІ)
]


#align(center)[
  *
  В І Д О М О С Т І\
  про автора (авторів) та наукового керівника наукової роботи\
  "#culine(шифр, sides: 4em)"
  *

  #text(size: .75em, baseline: -.5em)[(шифр)]
]

#columns(2, gutter: .5cm)[

  // Відомості про автора
  #align(center)[Автор]

  + Прізвище #info[Санжаров]
  + Ім'я (повністю) #info[Далііл]
  + По батькові (повністю) #info[Русланович]
  + Повне найменування та місцезнаходження вищого навчального закладу, у якому навчається автор
    #info[Державний торговельно-економічний університет, м. Київ]
  + Факультет (інститут) #info[ФІТ]
  + Курс (рік навчання) #info[1 курс (5 рік навчання)]
  + Результати роботи опубліковано\
    #[
      #set par(spacing: .35em)
      *#culine()[2025, м. Київ, "Штучний інтелект"]*\
      *#culine[ISSN 2710-1673]*\
      #align(center)[#text(
        size: .75em,
      )[(рік, місце, назва видання)]]
    ]
  + Результати роботи впроваджено\
    #[
      #set par(spacing: .35em)
      *#culine()[]*\
      #align(center)[#text(
        size: .75em,
      )[(рік, місце, форма впроавдження)]]
    ]
  + Телефон, e-mail #info[#author-phone, #author-email]
  #colbreak()

  // Відомості про керівника
  #align(center)[Науковий керівник]

  + Прізвище #info[Філімонова]
  + Ім'я (повністю) #info[Тетяна]
  + По батькові (повністю) #info[Олегівна]
  + Місце роботи, телефон, e-mail #info[Державний торговельно-економічний університет, м. Київ, #curator-phone, #curator-email]
  + Посада #info[Викладач]
  + Науковий ступінь #info[Кандидат фізико-математичних наук]
  + Вчене звання #info[Доцент]
]

#v(1em)

Науковий керівник #h(1fr) #signature-field([(підпис)], width: 5cm) #h(1cm) #signature-field([(прізвище та ініціали)], content: [Філімонова Т.О.], width: 5cm)

Автор роботи #h(1fr) #signature-field([(підпис)], width: 5cm) #h(1cm) #signature-field([(прізвище та ініціали)], content: [Санжаров Д.Р.], width: 5cm)

Рішенням конкурсної комісії #underline[Державного торгівельно-економічного університету]

Студент(ка) #underline[Санжаров Д.Р.] рекомендується для участі у #underline[ІІ турі Всеукраїнського конукурсу студентських наукових робіт галузі знань F "Інформаційні технології", спеціальності F3 "Комп'ютерні науки", спеціалізації "Комп'ютерні науки"].
#align(center)[#text(
  size: .75em,
  baseline: -.5em,
)[(назва галузі, спеціальності, спеціалізації)]]


#v(1em)

#grid(
  gutter: 0cm,
  align: bottom,
  columns: (1fr, 40%),
  text[
    Голова конкурсної комісії\
    доктор фізико-математичних наук, професор,\
    Завідувач кафедри комп’ютерних наук та інформаційних систем
    #v(1em)
  ],
  box[
    #h(1fr)
    #signature-field([(підпис)], width: 2.5cm)
    #h(.5cm)
    #signature-field(
      [(прізвище та ініціали)],
      content: [Пурський О.І.],
      width: 4cm,
    )
  ],
)

#v(1em)

#culine(sides: 3cm)[] 2026 р.
