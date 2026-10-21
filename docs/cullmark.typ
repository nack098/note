#import "templates/title_template.typ": report-cover
#import "templates/chapter_template.typ": block-quote, chapter, concept, definition, goal, image-fig, pitfall

// ----------------------------------------------------
// Cover Page
// ----------------------------------------------------
#report-cover(
  report-type: "Computer Graphics Assignment",
  title: "1-Iteration Catmull-Clark Subdivision",
  subtitle: "Implementation with General Polygons and Boundary Edge Handling",
  author: "Tapaneeya Odmung",
  student-id: "6530186721",
  advisor: "Assoc. Prof. Dr. Pizzanu Kanongchaiyos",
  course: "2110512.51 Computer Animation",
  term: "1/2026",
  faculty: "Faculty of Engineering",
  institution: "Chulalongkorn University",
  // Uncomment the line below to add a cover image if needed
  // cover_image: "assets/image_c2dbdd.png",
  date: "May 18, 2026",
)

// ----------------------------------------------------
// Chapter Configuration
// ----------------------------------------------------
#show: chapter.with(
  name: "Catmull-Clark",
  title: "Subdivision Surface",
  subtitle: "Computer Animation",
  author: "Tapaneeya Odmung",
)

// ----------------------------------------------------
// Report Content
// ----------------------------------------------------

= Objectives
#goal[
  To study and implement a 3D mesh processing program using the Catmull-Clark Subdivision algorithm for 1 iteration. The program must support general polygons, correctly handle open boundaries (boundary edges), and display the resulting geometric structure in a wireframe format.
]

= Software Specifications
The program was developed using the following environment and tools:
- *Programming Language:* Python
- *Core Processing Library:* `NumPy` for mathematical calculations and vector array management (Vector Math).
- *Visualization Library:* `Pygame` for rendering and displaying a custom 3D wireframe viewer.
- *Input:* 3D model files in `.obj` format (utilizing the low-poly Clown model from The Stanford 3D Scanning Repository).

= Data Structure
#concept[
  *Adjacency Dictionary* \
  To achieve efficient neighborhood (adjacency) access, the program simulates a Half-edge Data Structure using a Dictionary format. This allows Point-Edge-Face relationships to be queried with an $O(1)$ time complexity, which is highly efficient for subdivision processing.
]
The primary data structures used are:
- `edge_to_faces`: Stores which faces are connected to each edge.
- `vertex_to_faces`: Stores which faces each vertex belongs to.
- `vertex_to_edges`: Stores which edges are connected to each vertex.


= Implementation Details
The program calculates new points based on the standard Catmull-Clark rules for general polygons, divided into three main components:

#definition[
  *1. Face Points ($F$)* \
  The center point of each face, calculated as the average position of all vertices that make up that face.
]

#definition[
  *2. Edge Points ($E$)* \
  For interior edges, it is calculated as the average of the two endpoints ($v_1, v_2$) and the face points of the two adjacent faces ($f_1, f_2$) sharing that edge:
  $ E = (v_1 + v_2 + f_1 + f_2) / 4 $
]

#definition[
  *3. Vertex Points ($V'$)* \
  For interior vertices, the new position is calculated based on surrounding points using the formula:
  $ V' = (F_"avg" + 2R_"avg" + (n-3)V) / n $
  Where $F_"avg"$ is the average of the surrounding face points, $R_"avg"$ is the average of the midpoints of the surrounding edges, and $n$ is the valence (number of connected edges).
]

= Boundary Edges Handling (Bonus)
To prevent open-boundary models (e.g., the fingertips or clothing edges of the model) from shrinking or deforming inappropriately, boundary detection and calculation logic were implemented:

1. *Detection:* If an edge is connected to only 1 face, it is classified as a boundary edge.
2. *Boundary Edge Points:* Face points are excluded from the average. Instead, the exact midpoint of the edge is used:
  $ E_"boundary" = (v_1 + v_2) / 2 $
3. *Boundary Vertex Points:* Calculated using a 1D Cubic B-spline formulation to preserve the curve of the boundary:
  $ V'_"boundary" = 3/4 V + 1/8 m_1 + 1/8 m_2 $
  *(where $m_1, m_2$ are the midpoints of the two adjacent boundary edges).*


= Experimental Results and Visualization
The images below illustrate the wireframe structure of the Clown model before and after the subdivision process (rendered via a custom 3D orthographic projection in Pygame).

#v(1em)
// Display images in a side-by-side grid
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  image-fig(image("assets/clown_before.png"), [Original Low-poly Model]),
  image-fig(image("assets/clown_after.png"), [Result after 1-Iteration Subdivision]),
)
#v(1em)

*Summary of Observations:*
- The polygon count increased systematically, and all faces were converted into quadrilaterals (quads) in accordance with the Catmull-Clark properties.
- The wireframe structure in the right image (result) is visibly denser and smoother (Smoothing effect).
- The boundary areas, specifically the fingertips and hair of the model, successfully retained their original shape without mesh collapse, demonstrating the correct implementation of boundary edge handling.
