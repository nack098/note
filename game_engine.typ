#import "templates/title_template.typ": title
#import "templates/chapter_template.typ": chapter, overflowing-image

#title()

#show: chapter.with(
  name: "Game System Architecture\nFrom a Game Engine Perspective",
  title: "Introduction",
  subtitle: "Chapter 1",
  author: "Nakuya (泣くや)",
  cover_image: align(center + horizon)[
    
    #box(width: 100%, height: 80%, clip: true)[
      #move(dx: 76pt)[
        #overflowing-image(image("assets/chapter1.png"))
      ]
      
    ]
  ]

)

= Introduction

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

```c
#include <stdio.h>

int main() {
    return 0;
}
```
