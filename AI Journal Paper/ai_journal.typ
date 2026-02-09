#let conf(
  title: str,
  authors: (),
  affiliations: (),
  abstract: [],
  keywords: str,
  doc
) = {
  set page(
    paper: "a4",
    margin: (2cm),
    columns: 2,
    header: context {
      let page = counter(page).get().first()
      let journal_name = [*ISSN 2710-1673. Artificial Intelligence, 202X, №X*]

      if calc.odd(page) {
        align(right)[#journal_name]
      } else {
        align(left)[#journal_name]
      }
    },
    header-ascent: 1em,
    footer: context {
      let page = counter(page).get().first()

      let names = authors.map(author => author.fullname)
      let names_line = [#sym.copyright #names.join(", ")]

      if calc.odd(page) {
        [#names_line #h(1fr) #page]
      } else {
        [#page #h(1fr) #names_line]
      }
    },
    footer-descent: 1em
  )

  set columns(
    gutter: 1cm
  )

  set text(
    font: "Times New Roman",
    size: 12pt,
    top-edge: 1em,
    bottom-edge: 0em
  )
  set par(
    justify: true,
    leading: 0.15em,
    spacing: 0.15em,
    first-line-indent: (amount: 1cm, all: true),
  )


  show heading: it => {
    set text(12pt, weight: "bold")
    set block(below: 0em, above: 1em, inset: (left: 1cm))
    it
  }
  set figure(gap: 0.15em)

  show figure: fig => {
    set block(spacing: 1em)
    fig
  }

  show figure.where(
    kind: table
  ): set figure.caption(position: top)

  show figure.where(
    kind: raw
  ): fig => {
    set text(size: 12pt, )
    show raw: cd => {
      set text(font: "Cascadia Code")
      align(left)[
        #rect(width: 100%)[
          #cd
        ]
      ]
    }
    fig
  }

  set enum(
    numbering: "1.i."
  )
  

  // Text content

  let author-block(authors: (), affiliations: ()) = {
    let authors-line = authors.enumerate().map(item => [*#item.at(1).name* #super(str(item.at(0)+1))]).join(", ")
    let affiliation_line = affiliations.map(affil => [
      #set text(size: 11pt)
      #super(affil.authors)
      #box(baseline: 1em, height: 2em)[
        #affil.name\
        #text(10pt)[#affil.address]
      ]
    ]).join(linebreak())

    let contact(item) = {
      let i = item.at(0)
      let author = item.at(1)
      set text(size: 10pt)
      [#super(str(i+1)) #box(baseline: 1em, height: 2em)[
        #link("mailto:"+author.email)\ #link(author.orcid)
      ]]
    }

    let contacts_line = authors.enumerate().map(contact).join(linebreak())
    
    block()[
      #authors-line\
      #affiliation_line\
      #contacts_line
    ]
  }

  place(
    top,
    float: true,
    scope: "parent",
    clearance: 1em
  )[
    #block()[*UDC 004.932* #h(1fr) #link("https://doi.org/10.15407/jai202x.xx.xxx")]
    \
    #author-block(authors: authors, affiliations: affiliations)
    \
    #align(center)[#text(size: 14pt)[#upper[*#title*]]]
    \
    #set text(size: 10pt)
    #set par(first-line-indent: 1cm)
    *Abstract.* #abstract

    *Keywords.* #keywords
  ]

  doc
}