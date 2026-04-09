#let title(
  title: "GAME SYSTEM ARCHITECTURE",
  subtitle: "From a Game Engine Perspective",
  author: "Nakuya (泣くや)",
  role: "Software Engineer",
  cover_image: none,
  version: "1.0.0",
) = {
  let primary-blue = rgb("#1a3a5f")
  let body-gray = rgb("#2c3e50")

  set page(
    paper: "a5",
    margin: (x: 0.8in, y: 1in),
  )

  set text(font: "Inter", fill: body-gray)

  align(left)[
    #v(1cm)
    #text(size: 20pt, weight: "bold", fill: primary-blue, tracking: -0.35pt)[#title] \
    #text(size: 12pt, weight: "medium", fill: gray)[#subtitle]
    #v(0.5em)
    #line(length: 100%, stroke: 1pt + primary-blue)
  ]

  v(1fr)

  if cover_image != none {
    align(center)[
      #block(
        stroke: 0.5pt + gray.lighten(50%),
        radius: 4pt,
        clip: true,
        width: 100%,
      )[
        #if type(cover_image) == str {
          image(cover_image, width: 100%)
        } else {
          cover_image
        }
      ]
      #v(0.8em)
      #text(size: 8pt, fill: gray.darken(20%), style: "italic")[
        Fig 0.0: Architectural view of discretized system entities.
      ]
    ]
  }

  v(1fr)

  align(right)[
    #line(length: 40%, stroke: 0.5pt + gray)
    #v(-0.2em)
    #text(size: 12pt, weight: "semibold", fill: primary-blue)[#author]
    #v(-0.8em)
    #text(size: 8pt, fill: gray)[#role] \ 
    #text(size: 6pt, font: "Geist Mono", weight: "light", fill: gray.lighten(20%))[BUILD_REV: #version] ]
  pagebreak()
}
