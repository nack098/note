#import "templates/title_template.typ": title
#import "templates/chapter_template.typ": (
  block-quote, callout, chapter, concept, definition, image-fig, overflowing-image,
)

#title(
  cover_image: align(center + horizon)[
    #box(width: 100%, height: 65%, clip: true)[
      #move(dy: -25pt)[
        #image("assets/title.png", height: 100%, fit: "cover")
      ]

    ]
  ],
)

#show: chapter.with(
  name: "Game System Architecture\nFrom a Game Engine Perspective",
  title: "Introduction",
  subtitle: "Chapter 0",
  author: "Nakuya (泣くや)",
  cover_image: align(center + horizon)[

    #box(width: 100%, height: 85%, clip: true)[
      #move(dx: 76pt)[
        #overflowing-image(image("assets/chapter0.png"))
      ]

    ]
  ],
)

= Introduction

// Reference https://www.history.com/articles/history-of-video-games
// Reference https://www.bnl.gov/about/history/firstvideo.php
On the morning of October 18, 1958, inside a lab at Brookhaven National Laboratory, two people were playing what would later be called 'Tennis for Two.'
This game is marked as the first in the history of computer gaming. We began by playing on oscilloscopes; now, we play games on vending machines, refrigerators, or even pregnancy tests. (I see you all, the 'Mr. Play Doom' crowd, porting it to anything with a processor!)

// Image Reference https://www.bnl.gov/about/history/firstvideo.php
#image-fig(
  image("assets/tennis_for_two.jpg", height: 24em),
  [A recreation of the original Tennis For Two constructed for the 50th anniversary of the game's first appearance.],
)<tennis>

#pagebreak()

We started from writing game line by line in assembly to not having to write anything just having an idea to create a game.
But at the end in order to write an actual scalable, maintainable, with acceptable performance game.

We need to understand how so called _"Game Engine"_ works under the hood.

Otherwise the *_"friend"_* will become your biggest *_"enemy"_*.

#show: chapter.with(
  name: "Game System Architecture\nFrom a Game Engine Perspective",
  title: "Game Engine",
  subtitle: "Chapter 1",
  author: "Nakuya (泣くや)",
  cover_image: align(center + horizon)[

    #box(width: 100%, height: 85%, clip: true)[
      #move(dx: -52pt)[
        #overflowing-image(image("assets/chapter1.png"))
      ]

    ]
  ],
)

= Game Engine

Game engine definition is one of the most vague things in universe. There is so many interpretation of game engine.
// Reference https://www.researchgate.net/publication/259496289_History_and_comparative_study_of_modern_game_engines (2012)
One of them defined it as
#definition(
  [
    *Game Engine* is a platform that does common _"Game"_ related task such as Rendering, Physics Computation, or Input Management in order to let
    Game Designer to focus on _"Game"_ Behavior (Gameplay).
  ],
)

#image-fig(
  image("assets/game-engine.jpg", height: 14em),
  [Very confusing definition.],
)

// Reference https://www.researchgate.net/publication/283657797_Game_engines_a_survey (2015)
On Game engines: a survey by EAI Endosed Transactions gives definition as
#definition([
  *Game Engine* is a piece of software that enables the creation of video games.
])
This paper states that we do not have a proper clarification of what expected to be in game engine frameworks environment. \
\
The _expectation_ of such a framework is
to abstract common video game features allowing for code and game asset to be reuse in different games.\
#concept(
  [
    *A functionalities that are _typically_ found on game engine.*
    + A rendering engine, for either 2D or 3D graphics
    + Input handling
    + Game loop
    + A physics engine, with collision detection and response
    + A scene graph
    + Animation
    + Memory management
    + Process threading

    *Other functionalities*
    + Scripting
    + Artificial intelligence
    + Networking
    + Streaming
    + Localization support
    + Multi-platform publishing
  ],
)

#pagebreak()

This raises the question. *Does such a system really need all of that functionalities in order to create a game?*

#image-fig(
  image("assets/game-engine2.jpg", height: 24em),
  [Sudoku game],
)


Some game such as a Sudoku does not require a physics engine which mean
that in this case the physics engine should be an additional feature.\

#pagebreak()

// Reference https://dl.acm.org/doi/abs/10.1145/1496984.1497031 (2008)
From "The case for research in game engine architecture", the two of the research questions state in the paper are *the lack of a "game development" language and what is a boundary between a game and a game engine.*

#concept(
  [
    So the conclusion for this is, we have *no clear definitions* for what game engine really is. And we don't even talk about what _"game"_ actually is.
  ],
)

// Reference Game Engine Architecture Volume I Foundations and Core Engine Systems
#block-quote(
  author: "Jason Gregory",
  source: "Game Engine Architecture",
)[
  "The line between a game and it's engine is often blurry. Some engines make a reasonably clear distinction, while others make almost no attempt to separate the two.
  In one game, the rendering code might "know" specifically how to draw an orc, In another game, the rendering engine might provide general-purpose material and shading facilities and "orc-ness" might be defined entirely in data.
  No studio makes a perfectly clear separation between the game and the engine, which is understandable considering that the definitions of these two components often shift as the game's design solidifies"
]

#pagebreak()

== Game Engine Definition
