#import "templates/title_template.typ": title
#import "templates/chapter_template.typ": chapter, overflowing-image, image-fig

#title(
  cover_image: align(center + horizon)[
    #box(width: 100%, height: 65%, clip: true)[
      #move(dy: -25pt)[
        #image("assets/title.png", height: 100%, fit: "cover")
      ]
      
    ]
  ]
)

#show: chapter.with(
  name: "Game System Architecture\nFrom a Game Engine Perspective",
  title: "Introduction",
  subtitle: "Chapter 1",
  author: "Nakuya (泣くや)",
  cover_image: align(center + horizon)[
    
    #box(width: 100%, height: 85%, clip: true)[
      #move(dx: 76pt)[
        #overflowing-image(image("assets/chapter1.png"))
      ]
      
    ]
  ]

)

= Introduction

// Reference https://www.history.com/articles/history-of-video-games
// Reference https://www.bnl.gov/about/history/firstvideo.php
On the morning of October 18, 1958, inside a lab at Brookhaven National Laboratory, two people were playing what would later be called 'Tennis for Two.' 
This game is marked as the first in the history of computer gaming. We began by playing on oscilloscopes; now, we play games on vending machines, refrigerators, or even pregnancy tests. (I see you all, the 'Mr. Play Doom' crowd, porting it to anything with a processor!)

// Image Reference https://www.bnl.gov/about/history/firstvideo.php
#image-fig(
  image("assets/tennis_for_two.jpg", height: 24em),
  [A recreation of the original Tennis For Two constructed for the 50th anniversary of the game's first appearance.]
)<tennis>
