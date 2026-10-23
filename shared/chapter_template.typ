#import "@preview/catppuccin:1.1.0": flavors

#let block-quote(body, author: "", source: "") = {
  v(1em)
  block(
    width: 100%,
    inset: (left: 1.5em, top: 0.5em, bottom: 0.5em),
    stroke: (left: 2pt + black.lighten(70%)),
  )[
    #set text(style: "italic", fill: black.lighten(10%))
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
    // the image will have horizontal overflow; set the width according to the aspect ratio
    set image(height: 100%, width: container.height * img-ratio)
    img
  } else {
    // the image will have vertical overflow; set the height according to the aspect ratio
    set image(width: 100%, height: container.width / img-ratio)
    img
  }
})

#let image-fig(img, cap) = {
  set text(size: 8pt, weight: "light", fill: black.lighten(15%))

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
#let sidenote(body) = callout("Side Note", rgb("#e74c3c"), body)
#let warning(body) = callout("Warning", rgb("#e74c3c"), body)
#let innervoice(body) = callout("Inner Voice", rgb("#e74c3c"), body)
#let concept(body) = callout("Core Concept", rgb("#3498db"), body)
#let definition(body) = callout("Definition", rgb("#f39c12"), body)
#let technical(body) = callout("Technical Note", rgb("#f39c12"), body)

#let chapter(
  name: "Untitle",
  title: "Untitled Module",
  subtitle: "Untitled",
  author: "Nakuya",
  cover_image: none,
  paper: "a5",
  body,
) = {
  show heading.where(level: 1): it => [
    #set text(size: 18pt, weight: "bold", fill: rgb("#1a3a5f"))
    #block(width: 100%, below: 1em)[
      #stack(
        dir: ttb,
        spacing: 12pt,
        it.body,
        line(length: 100%, stroke: 1.5pt + rgb("#1a3a5f")),
      )
    ]
  ]

  show heading.where(level: 2): it => [
    #set text(size: 14pt, weight: "semibold", fill: rgb("#2980b9"))
    #block(it, above: 1.5em, below: 1em, sticky: true)
  ]

  page(paper: paper, header: none, footer: none, margin: 0.8in)[
    #if cover_image != none [
      #align(center)[
        #cover_image
      ]
    ]
    #v(1fr)
    #align(bottom + left)[
      #text(size: 14pt, weight: "medium", fill: gray, subtitle) \
      #text(size: 24pt, weight: "bold", fill: rgb("#1a3a5f"), title)
      #line(length: 60%, stroke: 1.5pt + rgb("#1a3a5f"))
    ]
  ]

  set page(
    paper: paper,
    margin: (x: 0.8in, y: 1in),
    header: context {
      set text(8pt, fill: gray)
      grid(
        columns: (1fr, 1fr),
        [#name], align(right, [#subtitle - #title]),
      )
    },
    footer: context {
      set text(8pt, fill: gray)
      line(length: 100%, stroke: 0.5pt + gray)
      grid(
        columns: (1fr, 1fr),
        [#author], align(right, counter(page).display("1/1", both: true)),
      )
    },
  )

  body
}
