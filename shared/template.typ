#import "@preview/catppuccin:1.1.0": flavors

// --- Modular Utilities ---

#let block-quote(body, author: "", source: "") = {
  v(1em)
  block(
    width: 100%,
    inset: (left: 1.5em, top: 0.5em, bottom: 0.5em),
    stroke: (left: 2pt + rgb("#2c3e50").lighten(70%)),
  )[
    #set text(style: "italic", fill: rgb("#2c3e50").darken(10%))
    #body

    #if author != "" [
      #v(0.5em)
      #set text(style: "normal", weight: "bold", size: 0.9em)
      --- #author #if source != "" [, #set text(weight: "regular"); #source]
    ]
  ]
  v(1em)
}

#let overflowing-image(img) = layout(container => {
  let dim = measure(img)
  let container-ratio = container.width / container.height
  let img-ratio = dim.width / dim.height

  if img-ratio > container-ratio {
    set image(height: 100%, width: container.height * img-ratio)
    img
  } else {
    set image(width: 100%, height: container.width / img-ratio)
    img
  }
})

#let image-fig(img, cap) = {
  set text(size: 8pt, weight: "light", fill: rgb("#2c3e50").lighten(15%))
  block(width: 100%)[
    #v(1.25em)
    #figure(img, caption: cap, gap: 1.5em)
    #v(1.25em)
  ]
}

#let callout(title, color, content) = rect(
  fill: color.lighten(90%),
  stroke: (left: 4pt + color),
  inset: 12pt,
  width: 100%,
  radius: 2pt,
)[
  #set text(weight: "bold", fill: color.darken(20%))
  #title \
  #set text(weight: "light", fill: black)
  #content
]

#let goal(body) = callout("Design Goal", rgb("#2ecc71"), body)
#let pitfall(body) = callout("Performance Pitfall", rgb("#e74c3c"), body)
#let concept(body) = callout("Core Concept", rgb("#3498db"), body)
#let definition(body) = callout("Definition", rgb("#f39c12"), body)

// --- Core Tracking Document Engine ---

#let docs(
  name: "Documentation",
  author: "",
  major: 1,
  minor: 0,
  date: auto, // Fixed: defaults to auto-generation
  body,
) = {
  let primary-blue = rgb("#1a3a5f")
  let body-gray = rgb("#2c3e50")
  let macchiato = flavors.macchiato.colors

  // Automatically compute the current compilation date if set to auto
  let final-date = if date == auto {
    datetime.today().display("[year]-[month]-[day]")
  } else {
    date
  }

  // Embedded dark-mode Macchiato syntax pipeline for code blocks
  set raw(theme: "macchiato.tmTheme")
  show raw: set text(font: "Fira Code", weight: "medium", size: 9pt)
  show raw: it => {
    if it.block [
      #v(1em)
      #block(
        fill: macchiato.base.rgb,
        stroke: 1pt + macchiato.surface1.rgb,
        width: 100%,
        inset: 12pt,
        radius: 6pt,
      )[
        #set text(fill: macchiato.text.rgb)
        #if it.has("lang") {
          place(top + right, text(7pt, fill: macchiato.overlay1.rgb, weight: "bold")[#it.lang])
        }
        #it
      ]
    ] else [
      #box(
        fill: macchiato.surface0.rgb,
        inset: (x: 4pt, y: 2pt),
        outset: (y: 2pt),
        radius: 3pt,
        baseline: 2pt,
      )[
        #text(fill: macchiato.text.rgb, it)
      ]
    ]
  }

  set document(title: name, author: author)

  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm),
    header: context {
      set text(8pt, fill: gray)
      grid(
        columns: (1fr, 1fr),
        row-gutter: 6pt,
        align(left)[#name], align(right)[v#major.#minor],
        align(left)[#author],
        // Renders the automated date string
      )
    },
    footer: context {
      set text(8pt, fill: gray)
      line(length: 100%, stroke: 0.5pt + gray)
      v(2pt)

      let current-year = str(datetime.today().year())
      grid(
        columns: (1fr, 1fr),
        align(left)[© #current-year Takayama. All rights reserved.],
        align(right, counter(page).display("1/1", both: true)),
      )
    },
  )

  set text(font: "Inter", size: 10.5pt, fill: body-gray)
  set par(justify: true)

  show heading.where(level: 1): it => [
    #set text(size: 20pt, weight: "bold", fill: primary-blue)
    #block(width: 100%, below: 1em, above: 1.5em)[
      #stack(
        dir: ttb,
        spacing: 12pt,
        it.body,
        line(length: 100%, stroke: 1.5pt + primary-blue),
      )
    ]
  ]

  show heading.where(level: 2): it => [
    #set text(size: 15pt, weight: "semibold", fill: rgb("#2980b9"))
    #block(it, above: 1.5em, below: 1em, sticky: true)
  ]

  // Header Title Component
  align(center)[
    #v(0.5cm)
    #text(size: 24pt, weight: "bold", fill: primary-blue, tracking: -0.35pt)[#name] \
    #v(0.2em)
    #text(size: 10pt, fill: gray)[Version #major.#minor]
    #v(-0.5em)
    #text(size: 10pt, fill: gray)[#final-date]
    #v(0.5em)
    #line(length: 100%, stroke: 1.5pt + primary-blue)
  ]
  v(20pt)

  // Document Navigation Outline Block
  block(fill: rgb("#f8fafc"), inset: 12pt, radius: 4pt, width: 100%, stroke: 0.5pt + rgb("#ccd0da"))[
    #text(weight: "bold", fill: primary-blue)[Document Outline]
    #v(4pt)
    #outline(title: none, indent: 1.5em)
  ]
  v(10pt)

  body
}

#let revise(by: "", body) = {
  let primary-blue = rgb("#1a3a5f")
  v(30pt)
  line(length: 100%, stroke: 0.5pt + gray.lighten(50%))

  if body != [] {
    v(10pt)
    block(
      fill: rgb("#f8fafc"),
      inset: 12pt,
      radius: 4pt,
      width: 100%,
      stroke: (left: 4pt + primary-blue),
    )[
      #text(weight: "bold", size: 11pt, fill: primary-blue)[Revision]
      #h(1fr)
      #text(style: "italic", size: 9pt, fill: gray)[Reviewed/Revised by: #by]
      #v(8pt)
      #body
    ]
  }
}
