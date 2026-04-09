#import "@preview/catppuccin:1.1.0": flavors

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

#let chapter(
  name: "Untitle",
  title: "Untitled Module",
  subtitle: "Untitled",
  author: "Nakuya",
  cover_image: none,
  body,
) = {
  // Macchiato palette for code blocks
  let macchiato = flavors.macchiato.colors
  
  set raw(theme: "macchiato.tmTheme") 
  // Scaled down code font for A5
  show raw: set text(font: "Fira Code", weight: "medium", size: 8.5pt)

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
      #v(1em)
      #box(fill: macchiato.surface0.rgb, inset: (x: 3pt, y: 0pt), radius: 3pt)[
        #text(fill: macchiato.flamingo.rgb, it)
      ]
    ]
  }

  // Scaled down body text for A5
  set text(font: "Inter", size: 9.5pt, fill: rgb("#2c3e50"))

  show heading.where(level: 1): it => [
    #set text(size: 18pt, weight: "bold", fill: rgb("#1a3a5f"))
    #block(width: 100%, below: 1em)[
      #stack(
        dir: ttb,
        spacing: 12pt, 
        it,
        line(length: 100%, stroke: 1.5pt + rgb("#1a3a5f")),
      )
    ]
  ]

  show heading.where(level: 2): it => [
    #set text(size: 14pt, weight: "semibold", fill: rgb("#2980b9"))
    #block(it, above: 1.5em, below: 1em, sticky: true)
  ]

  page(paper: "a5", header: none, footer: none, margin: 0.8in)[
    #if cover_image != none [
      #align(center)[
        #cover_image
      ]
    ]
    #v(1fr)
    #align(bottom + left)[
      #text(size: 14pt, weight: "medium", fill: gray, subtitle) \
      #text(size: 24pt, weight: "bold", fill: rgb("#1a3a5f"), title)
      #line(length: 60%, stroke: 1.5pt + rgb("#1a3a5f")),
    ]
  ]

  set page(
    paper: "a5",
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
