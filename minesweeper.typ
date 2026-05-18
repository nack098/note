#import "templates/title_template.typ": report-cover
#import "templates/chapter_template.typ": block-quote, callout, chapter, concept, definition

// ===========================================================================
// Helpers
// ===========================================================================

// Classic Minesweeper number colours.
#let _mine-num = (
  "1": rgb("#1565c0"),
  "2": rgb("#2e7d32"),
  "3": rgb("#c62828"),
  "4": rgb("#1a237e"),
  "5": rgb("#6d4c41"),
  "6": rgb("#00838f"),
  "7": rgb("#37474f"),
  "8": rgb("#90a4ae"),
)

// Render a Minesweeper board from a 2D array of string codes.
//   "#" covered      "." revealed-empty   "*" mine        "@" exploded mine
//   "o" no-mine ring "1".."8" number      ""  blank cell  else -> text
#let board(data, cell: 1.55em, plain: false) = {
  let ncols = data.at(0).len()
  let covered = if plain { white } else { rgb("#c4c4c4") }
  let revealed = if plain { white } else { rgb("#ececec") }
  let gridline = if plain { 0.6pt + rgb("#2b2b2b") } else { 0.8pt + rgb("#9b9b9b") }

  align(center)[
    #table(
      columns: (cell,) * ncols,
      rows: cell,
      stroke: gridline,
      align: center + horizon,
      inset: 0pt,
      ..data.flatten().map(code => {
        let c = if type(code) == str { code } else { str(code) }
        let fill = revealed
        let body = []
        if c == "#" {
          fill = covered
        } else if c == "" or c == " " {
          fill = revealed
        } else if c == "*" {
          body = circle(radius: 0.3em, fill: black)
        } else if c == "@" {
          fill = rgb("#e53935")
          body = circle(radius: 0.3em, fill: black)
        } else if c == "o" {
          body = circle(radius: 0.27em, stroke: 0.7pt + black, fill: white)
        } else if c == "." {
          fill = revealed
        } else if c in _mine-num {
          body = text(
            weight: "bold",
            size: 0.95em,
            fill: if plain { rgb("#1a1a1a") } else { _mine-num.at(c) },
          )[#c]
        } else {
          body = text(weight: "medium", size: 0.88em, fill: rgb("#1a1a1a"))[#c]
        }
        table.cell(fill: fill)[#body]
      })
    )
  ]
}

// Native (non-image) figure, matching the template's caption styling.
#let fig(body, cap) = block(width: 100%, breakable: false)[
  #v(0.9em)
  #figure(body, caption: cap, kind: image, supplement: [Figure], gap: 1.1em)
  #v(0.9em)
]

// Theorem box, built on the template's callout system.
#let theorem(num, name, body) = callout(
  [Theorem #num#if name != "" [ — #name]],
  rgb("#8e44ad"),
  body,
)

// Proof-sketch block (for results whose full proof is deferred to the papers).
#let proof(body) = block(width: 100%, inset: (left: 0.6em), spacing: 1em)[
  #text(style: "italic", weight: "semibold", fill: rgb("#1a3a5f"))[Proof idea.]
  #h(0.35em)
  #body
]

// Lemma box, built on the template's callout system.
#let lemma(num, name, body) = callout(
  [Lemma #num#if name != "" [ --- #name]],
  rgb("#16a085"),
  body,
)

// Full (complete) proof block, closed with a QED mark.
#let fullproof(body) = block(width: 100%, inset: (left: 0.6em), spacing: 1em)[
  #text(style: "italic", weight: "semibold", fill: rgb("#1a3a5f"))[Proof.]
  #h(0.35em)
  #body
  #h(1fr)
  #box(width: 0.4em, height: 0.4em, fill: rgb("#16a085"))
]

// Construction box (a precisely-stated, cited building block).
#let construction(num, name, body) = callout(
  [Construction #num#if name != "" [ --- #name]],
  rgb("#b9770e"),
  body,
)

// Small-caps problem name.
#let pname(body) = smallcaps(text(weight: "semibold")[#body])
#let mcp = pname[Minesweeper Consistency]
#let mip = pname[Minesweeper Inference]

// ===========================================================================
// Cover
// ===========================================================================

#report-cover(
  report-type: "Final Report (Reading)",
  title: "The Computational Complexity of Minesweeper",
  subtitle: "Is It NP-Complete or co-NP-Complete?",
  author: "Tapaneeya Odmung",
  student-id: "6530186721",
  advisor: "Dr. Suthee Ruangwises",
  course: "2110404 Computational Theory",
  term: "Semester 2, Academic Year 2568",
  faculty: "Department of Computer Engineering, Faculty of Engineering",
  institution: "Chulalongkorn University",
  date: "May 2026",
  cover_image: board(
    (
      (".", "1", "#", "2", "1", "1"),
      ("1", "2", "2", "2", "#", "1"),
      ("1", "#", "2", "2", "2", "1"),
      ("2", "2", "2", "#", "2", "1"),
      ("#", "1", "1", "1", "2", "#"),
    ),
    cell: 2.0em,
  ),
)

// ===========================================================================
// Body
// ===========================================================================

#show: chapter.with(
  name: "2110404 · Computational Theory",
  title: "Minesweeper",
  subtitle: "Final Report · Reading",
  author: "Tapaneeya Odmung",
  cover_image: board(
    (
      ("1", "2", "#", "1"),
      ("1", "#", "2", "1"),
      ("2", "2", "2", "1"),
      ("#", "1", "1", "#"),
    ),
    cell: 3em,
  ),
)

#show figure.caption: set text(size: 8pt, weight: "light", fill: black.lighten(20%))

// Keep multi-line headings left-aligned (the template justifies body text).
#show heading: set par(justify: false)

#block(fill: rgb("#f3f5f7"), inset: 12pt, radius: 3pt, width: 100%)[
  #text(weight: "bold", fill: rgb("#1a3a5f"))[Abstract]
  #v(0.35em)
  #text(style: "italic")[
    Minesweeper is one of the most widely played puzzles in computing history, yet
    the question of how *hard* it is has produced a literature that, at first glance,
    seems to contradict itself: some papers prove that Minesweeper is NP-complete,
    while others argue that it "may not be" and is in fact co-NP-complete. This
    reading report studies four works on the topic and shows that there is no
    contradiction. The single word "Minesweeper" hides two different decision
    problems --- *consistency* and *inference*. The consistency problem is
    NP-complete; the inference problem, which is the one a player actually solves,
    is co-NP-complete. Both results are correct, because they answer different
    questions.
  ]
]

= 1. Introduction

Minesweeper shipped with practically every personal computer of the 1990s and
2000s, and most people who have ever used a desktop computer have played it. The
rules look trivial: uncover squares one by one, never uncover a mine, and use the
numbers that appear to deduce where the mines are. Underneath this casual puzzle,
however, lies a question that has occupied complexity theorists for more than two
decades --- and, more curiously, a question whose answer the research literature
appears to disagree on. Some papers state plainly that "Minesweeper is
NP-complete." Others reply that it "may not be NP-complete" and is instead
co-NP-complete.

This report is a *reading project*. It surveys four works on the computational
complexity of Minesweeper:

+ Richard Kaye, _Minesweeper is NP-complete_ (2000);
+ Allan Scott, Ulrike Stege & Iris van Rooij, _Minesweeper May Not Be NP-Complete
  but Is Hard Nonetheless_ (2011);
+ Alex Thieme & Twan Basten, _Minesweeper is Difficult Indeed! Technology Scaling
  for Minesweeper Circuits_ (2022);
+ Moti Ben-Ari, _Minesweeper is NP-Complete_ (2018), an expository manuscript.

The aim is not to referee a contradiction but to dissolve a confusion. The four
readings do not actually disagree with one another. They study two *different*
decision problems that the everyday word "Minesweeper" silently conflates. Once
those problems are stated precisely, the NP-completeness result and the
co-NP-completeness result stand side by side, both correct.

#concept[
  *Two guiding questions* steer this report.
  + What is the decision problem that "solving Minesweeper" actually refers to?
  + In which complexity class does that problem lie --- and why does the
    literature appear to give two different answers?
]

= 2. Preliminaries

Before the complexity results make sense, we must fix the rules of the game and
recall just enough complexity theory to state them. This section also draws the
single most important distinction in the whole report.

== 2.1 The Game of Minesweeper

A game of Minesweeper is played on an $m times n$ rectangular grid of cells. A
hidden subset of the cells contains *mines*; the rest are *safe*. The player
repeatedly uncovers cells:

- Uncovering a mine ends the game immediately --- the player loses.
- Uncovering a safe cell reveals a *number*: the count of mines among that cell's
  up-to-eight neighbours (the orthogonal and diagonal cells around it). A revealed
  cell whose number is zero triggers a cascade that automatically uncovers its
  neighbours.

The player wins by uncovering every safe cell. To keep track of deductions, the
player may *flag* cells believed to hide a mine. The numbers are the only
information the player ever receives: every inference about where the mines are
must be derived from them.

#fig(
  board((
    ("1", "2", "*", "1"),
    ("1", "*", "2", "1"),
    ("2", "2", "2", "1"),
    ("*", "1", "1", "*"),
  ), cell: 2.05em),
  [A fully revealed $4 times 4$ board. Every number equals the number of mines
   among its (at most eight) neighbouring cells --- the only rule of the game.],
)

== 2.2 Decision Problems and Complexity Classes

A *decision problem* is a question with a yes/no answer, taken over a family of
inputs. Complexity theory sorts such problems by how much work an answer takes.

#definition[
  *P* is the class of decision problems solvable in polynomial time.
  *NP* is the class of problems whose *yes*-instances admit a polynomial-size
  *certificate* that can be verified in polynomial time --- an *existential*
  guarantee ("there exists a witness"). *co-NP* is the mirror class: its
  *no*-instances admit short refutations, or equivalently its *yes*-instances are
  characterised by a *universal* statement ("for all witnesses...").
]

A problem is *C-hard* (for a class C) if every problem in C reduces to it by a
polynomial-time many-one reduction; it is *C-complete* if it is also a member of
C. The canonical NP-complete problem is *SAT*: given a Boolean formula, is there
an assignment that makes it true? Its complement, *UNSAT* --- is a formula true
under *no* assignment? --- is the canonical co-NP-complete problem.

It is almost universally believed that P #sym.eq.not NP and that
NP #sym.eq.not co-NP. The second belief has a consequence this report leans on
twice, so we prove it.

#lemma("2", "The NP / co-NP barrier")[
  If a single decision problem is both NP-complete and co-NP-complete, then
  NP $=$ co-NP.
]

#fullproof[
  Let $Q$ be such a problem. Being co-NP-complete, $Q$ is a member of co-NP.
  Being NP-complete, $Q$ is NP-hard, so every problem in NP reduces to $Q$ by a
  polynomial-time many-one reduction. Now co-NP is closed under such reductions:
  if $R$ reduces to a problem in co-NP, then $R$ is in co-NP. Hence every problem
  in NP is in co-NP, i.e. NP $subset.eq$ co-NP. For the reverse inclusion, take
  any $L$ in co-NP; its complement $overline(L)$ is in NP $subset.eq$ co-NP, so
  $overline(L)$ is in co-NP, and therefore $L$ is in NP. Thus co-NP
  $subset.eq$ NP as well, and the two classes coincide.
]

So whenever a single informal "problem" appears to be complete for both classes,
Lemma 2 says the right reaction is to suspect that two genuinely different
problems have been conflated --- which, for Minesweeper, is exactly what has
happened.

== 2.3 Two Problems Hiding in One Game

This is the heart of the report. The informal task "solve Minesweeper" actually
names two distinct decision problems, and almost every apparent contradiction in
the literature comes from sliding between them.

#definition[
  *Minesweeper Consistency Problem (MCP).* Given a partially marked board ---
  some cells show numbers, some are marked as known mines or known safe ---
  decide whether *there exists* an assignment of mines to the unmarked cells
  that is consistent with every shown number. In short: *could this board be
  real?*
]

#definition[
  *Minesweeper Inference Problem (MIP).* Given a partial board *already known to
  be consistent*, decide whether the status of some covered cell can be
  *inferred* --- whether there is a covered, unflagged cell that holds a mine in
  *every* consistent completion, or is safe in *every* consistent completion.
  In short: *does this real board force a move?*
]

#mcp asks an *existential* question --- "there exists a placement..."; #mip asks
a *universal* one --- "...in every completion..." That single change of
quantifier is the whole story, and it is why the two problems will come to rest
on opposite sides of the complexity map.

Scott, Stege and van Rooij add two refinements worth stating now. First,
inference has a *search* version --- actually name a forced cell and its content
--- and a *decision* version --- merely answer yes or no to "is any cell
forced?" The decision version is the one we analyse, and the one Theorem 2 will
pin down. Second, #mip is a *promise problem*: its input is *promised* to be a
consistent board. That promise is not a mere formality. Kaye's theorem says
recognising consistency is itself NP-hard --- so the player is given, for free,
the answer to a problem that is hard even to verify, and is then asked the
genuinely different question of what that board forces.

#concept[
  Consistency asks whether a board *could* exist; it is settled by exhibiting one
  witness. Inference asks what a board that *does* exist forces; it is settled
  only by ruling every witness out. Conflating the two is exactly what makes the
  literature look self-contradictory.
]

= 3. Minesweeper Consistency Is NP-Complete

The first reading is Richard Kaye's 2000 paper, the result usually quoted as
"Minesweeper is NP-complete." Read carefully, the paper proves something more
precise: the *consistency* problem, #mcp, is NP-complete. Kaye's construction is
intricate, so this section also leans on the fourth reading --- Moti Ben-Ari's
2018 manuscript _Minesweeper is NP-Complete_, which, in its own words, "presents
Kaye's result with detailed explanations." The notation and worked examples
below are Ben-Ari's; the theorem and the proof are Kaye's.

#callout("A Note on Rigour", rgb("#5d6d7e"))[
  This is a *reading* report, and it is worth saying plainly how its proofs are
  organised. *Every theorem and lemma below is proved in full.* The hardness
  proofs rest on a single cited input --- Construction 1, the existence of the
  gadget toolkit. We state that toolkit precisely; its representative member,
  the wire, is verified outright in Lemma 1, while the remaining cell-by-cell
  gadget checks are worked through in Ben-Ari's 2018 manuscript and Kaye's
  Figures 6--13 (and, for the inference side, Scott, Stege and van Rooij's
  Figures 8--16). Isolating that one construction is deliberate: it lets the
  rest of the argument --- membership, composition, and the complexity-class
  reasoning --- stand as complete proofs, and it pins down the exact point where
  this report defers to its sources. Every claim has been checked against those
  originals.
]

== 3.1 The Problem and Membership in NP

Kaye formalises the question a designer or analyst might ask of a board: is the
displayed pattern of numbers *internally possible at all*? Some patterns are not
--- they cannot arise from any mine layout whatsoever.

Membership of #mcp in NP is immediate. A *full mine placement* --- one bit per
cell, "mine" or "safe" --- is a certificate of size $O(m n)$. To verify it, walk
over every numbered cell and check that the count of mines among its neighbours
matches the displayed number; this takes $O(m n)$ time. If a consistent placement
exists, this certificate exhibits it. Hence #mcp #sym.in NP.

Kaye also observes, presciently, that the *complement* --- deciding that a board
is *inconsistent* --- is not obviously in NP, since it is unclear what one could
guess to witness inconsistency. Section 4 builds on exactly this asymmetry.

== 3.2 Reading a Partial Board

To reason about *partial* boards, Ben-Ari's exposition introduces a compact
notation for the state of a cell during a deduction. A cell is *fulfilled* when
its number already equals the count of mines around it, *unfulfilled* when mines
are still missing, and *inconsistent* when its number cannot be met at all.

#fig(
  table(
    columns: (auto, auto),
    align: (center + horizon, left + horizon),
    inset: (x: 9pt, y: 6pt),
    stroke: 0.5pt + rgb("#b8b8b8"),
    table.header(
      text(weight: "bold", size: 0.85em)[Symbol],
      text(weight: "bold", size: 0.85em)[Meaning],
    ),
    rect(width: 0.62em, height: 0.62em, fill: black),
    [A cell known to contain a mine.],
    circle(radius: 0.32em, stroke: 0.8pt + black, fill: white),
    [A cell known to be safe (no mine).],
    text(weight: "bold")[?],
    [A cell that may or may not be a mine.],
    strike(text(weight: "bold")[2]),
    [An *inconsistent* cell --- its number cannot possibly be satisfied.],
    box(stroke: 0.7pt + black, inset: (x: 3.5pt, y: 1.5pt))[#text(weight: "bold")[2]],
    [A *fulfilled* cell --- all of its mines are already accounted for.],
    text(weight: "bold")[2],
    [An *unfulfilled* cell --- still missing some adjacent mines.],
  ),
  [Ben-Ari's notation for tracking what is known about each cell while reasoning
   about a partially solved board.],
)

These labels make a deduction step concrete: it either *fulfils* a cell, marks a
neighbour, or exposes an *inconsistency*. The last case is the engine of the
hardness proof --- the construction will be rigged so that an inconsistency
appears exactly when a logical constraint is violated.

== 3.3 Local Configurations Force Global Structure

A single number is a surprisingly strong constraint, because it pins down its
whole neighbourhood at once. Ben-Ari illustrates this with two worked puzzles.
The first is the *Square of Twos* --- a ring of cells each showing the number
*2* (the same puzzle appears, unnamed, as Figure 4 of Kaye's paper).

#fig(
  board((
    ("", "", "", "", "", ""),
    ("", "2", "2", "2", "2", ""),
    ("", "2", "0", "0", "2", ""),
    ("", "2", "0", "0", "2", ""),
    ("", "2", "2", "2", "2", ""),
    ("", "", "", "", "", ""),
  ), cell: 1.7em, plain: true),
  [The "Square of Twos". The inner block of *0* cells has no adjacent mines, which
   forces the mines into a tightly constrained pattern along the surrounding
   ring --- a local clue cascading into global structure.],
)

Because the inner *0* cells forbid mines anywhere near them, the mines satisfying
the ring of *2* clues are forced into a single placement. Ben-Ari's companion
puzzle, the *Square of Threes*, shows the opposite extreme: with the numbers
raised to *3*, the configuration becomes *unsatisfiable* --- no mine placement
works at all, so the board is a *no*-instance of #mcp. Two lessons follow: boards
genuinely can be inconsistent, and small local patterns can *force* large-scale
structure. Kaye's proof turns that second observation into a machine.

== 3.4 Building Boolean Circuits on a Board

The decisive idea is that a Minesweeper board can physically *embed a Boolean
circuit*. The components are built from forced mine patterns.

The basic component is a *wire*. Along a corridor of cells, the consistency
constraints leave exactly *two* possible mine patterns, and nothing in between:
either the cells marked $x$ hold the mines, or the cells marked $x'$ do. Kaye
fixes a direction for the wire and calls its value *true* when the $x$ cells are
mined. (Ben-Ari's manuscript uses an equivalent shorthand: an open cell followed
by a mine reads as *1*, a mine followed by an open cell as *0*.) Either way, a
wire carries one Boolean value $x$, with its negation $x'$ interleaved along the
same track.

That "exactly two patterns" claim is the hinge of the entire reduction, so ---
rather than only assert it --- we prove its smallest instance outright.

#lemma("1", "The bit gadget")[
  Take the $3 times 2$ board fragment whose four corner cells all show the
  number 1 and whose two middle cells, labelled $x$ and $x'$, are covered. It
  has *exactly two* consistent completions: one with a mine on $x$ and none on
  $x'$, and one with a mine on $x'$ and none on $x$.
]

#fig(
  grid(
    columns: 3,
    column-gutter: 1.6em,
    row-gutter: 0.7em,
    align: center,
    board((("1", "1"), ("x", "x'"), ("1", "1")), cell: 1.7em, plain: true),
    board((("1", "1"), ("*", "o"), ("1", "1")), cell: 1.7em, plain: true),
    board((("1", "1"), ("o", "*"), ("1", "1")), cell: 1.7em, plain: true),
    text(size: 0.82em)[the gadget],
    text(size: 0.82em)[completion: $x$ mined],
    text(size: 0.82em)[completion: $x'$ mined],
  ),
  [Lemma 1 --- the bit gadget and its only two consistent completions. A filled
   disc marks a mine, a ring a cell now known to be safe.],
)

#fullproof[
  A completion assigns "mine" or "safe" to each of the two covered cells $x$ and
  $x'$, giving four candidates. Every one of the four numbered cells sits at a
  corner of the fragment, adjacent to *both* $x$ and $x'$ and to no other covered
  cell --- the top-left numbered cell, for instance, has as neighbours only the
  top-right cell, $x$ and $x'$, of which just $x$ and $x'$ can hold a mine. Each
  numbered cell therefore counts exactly the mines placed on $x$ and $x'$, and a
  cell showing 1 is satisfied precisely when that count equals 1. Among the four
  candidates, mining both $x$ and $x'$ makes every count 2, and mining neither
  makes every count 0 --- both violate the 1s. The two survivors --- a mine on
  $x$ alone, or on $x'$ alone --- make every count exactly 1 and satisfy the
  fragment. Hence it has exactly two consistent completions.
]

Two consequences follow at once. First, the fragment *stores a bit*: its state
is the choice of which cell is mined. Second --- and this is what Section 4 will
turn on --- *no cell of the fragment can be inferred from the fragment alone*,
since both completions exist and so neither $x$ nor $x'$ is forced. That is the
local *non-leaking* property in miniature.

Kaye's wire is this bit scaled up. A long corridor of covered cells is sealed,
top and bottom, by rows of revealed numbers so that --- exactly as in Lemma 1 ---
only two global mine-patterns survive, and the bit is carried from one end of the
board to the other.

#fig(
  board((
    ("0", "0", "0", "0", "0", "0", "0", "0"),
    ("1", "1", "1", "1", "1", "1", "1", "1"),
    ("x", "1", "x'", "x", "1", "x'", "x", "1"),
    ("1", "1", "1", "1", "1", "1", "1", "1"),
    ("0", "0", "0", "0", "0", "0", "0", "0"),
  ), cell: 1.75em, plain: true),
  [A *wire*. The constraints admit only two mine patterns, so the corridor
   transmits one Boolean value $x$; the value $x$ and its negation $x'$ alternate
   along the central track.],
)

From wires Kaye builds a full toolkit of gadgets:

- *Bent wires* and *terminated wires* route a signal around corners and end it
  cleanly, so wires can be laid out anywhere on the grid.
- A *splitter* duplicates a signal --- it provides *fan-out*, so one variable can
  be fed into many places at once.
- A *NOT gate* outputs the negation $x'$ of its input, and an *AND gate*
  combines two signals (an *OR gate* then follows from AND and NOT, or vice
  versa).
- A *crossover* lets two wires cross without interacting. This is essential: the
  board is planar, yet a circuit's wires need not be, and Kaye builds the
  crossover from three splitters and three XOR gates.

Wires, gates, and crossovers are exactly the components of a Boolean circuit, so
anything a circuit can express can be drawn as a Minesweeper board. To use that
in a proof, though, we need the gadgets stated precisely rather than sketched.

#definition[
  A *gadget* is a fixed-size rectangular board fragment carrying designated
  *ports* on its boundary. Each port is the end of a wire and so holds one
  Boolean value (Lemma 1). A gadget *realises* a relation $R$ among its ports
  when its consistent completions, read off at those ports, are exactly the
  tuples of $R$.
]

#construction("1", "The gadget toolkit")[
  There exist gadgets, each fitting inside a box of fixed size, that realise:
  - *wire* and *turn* --- one input port, one output port, equal values;
  - *split* --- one input, two outputs, all three values equal;
  - *NOT* --- output the negation of the input;
  - *AND* and *OR* --- two inputs, one output, joined by the named connective;
  - *crossover* --- two wires that cross in the plane without interacting;
  - *terminator* --- a single port pinned to a fixed value.
  Lemma 1 verifies the heart of the wire outright. Ben-Ari's 2018 manuscript
  then works the wire, the NOT gate and the OR gate cell by cell --- this is why
  this report reads Kaye *through* Ben-Ari --- and Kaye's Figures 6--13 carry the
  rest of the library, turns, splitters, crossovers and the AND gate included.
  This toolkit is the one input the hardness proof takes as given.
]

== 3.5 The Reduction from SAT

With the toolkit fixed, the reduction is short to describe. Take any Boolean
circuit $C$ --- equivalently a CNF formula --- with variables $p_1, ..., p_n$.
Lay out a board $B(C)$ as follows: start each variable as a wire at an input
port; replace each gate of $C$ by the matching AND-, OR- or NOT-gadget of
Construction 1; carry gate outputs to gate inputs along wires, bending them with
*turns*, duplicating them with *splits* wherever a value is used more than once,
and passing them over one another with *crossovers* wherever the wiring is
non-planar; and cap the wire carrying $C$'s output with a *terminator* fixed to
*true*. Each gadget occupies a bounded box and the wiring is a routine planar
layout, so $B(C)$ is produced in time polynomial in the size of $C$.

#theorem("1", "Kaye, 2000")[
  #mcp is *NP-complete*. Kaye's reduction is in fact slightly stronger: the
  boards it produces need no pre-marked mines, and can be arranged so that every
  cell adjacent to a *0* is already uncovered --- so the game's automatic
  cascade-clearing offers no shortcut.
]

#fullproof[
  *Membership.* A full mine placement --- one bit per cell --- is a certificate
  of size $O(m n)$, and checking that every numbered cell counts the right
  number of neighbouring mines takes $O(m n)$ time. So #mcp is in NP.

  *Hardness.* We show $B(C)$ is consistent exactly when $C$ is satisfiable.

  First suppose $B(C)$ has a consistent mine placement. By Construction 1 each
  wire then sits in one of its two states, which we read as a Boolean value; the
  variable wires thereby fix a truth assignment $alpha$. At every gadget,
  consistency forces the port relation of Construction 1 to hold --- so each
  AND-, OR- and NOT-gadget outputs the correct connective of its inputs, and
  each split repeats its value along both branches. Tracing the circuit from its
  inputs to its output, the value delivered on $C$'s output wire is exactly
  $C(alpha)$. The terminator forces that value to be *true*; hence
  $C(alpha) =$ true, and $C$ is satisfiable.

  Conversely, suppose $C$ is satisfiable, with $C(alpha) =$ true for some
  assignment $alpha$. Put each variable wire into the state that encodes
  $alpha$. By Construction 1 every gadget, given the values now on its input
  ports, *admits* a consistent completion whose output port carries the correct
  value; wires, turns, splits and crossovers admit completions carrying the
  routed values likewise. Laying these completions down from inputs to output
  fills all of $B(C)$ consistently, and the output wire carries
  $C(alpha) =$ true --- exactly what the terminator requires. So $B(C)$ is
  consistent.

  The two directions give: $B(C)$ is consistent if and only if $C$ is
  satisfiable. The map from $C$ to $B(C)$ runs in polynomial time, so SAT
  reduces to #mcp; with SAT NP-complete and #mcp in NP, the problem #mcp is
  NP-complete.
]

This is the theorem behind the everyday claim "Minesweeper is NP-complete," and
the one Ben-Ari's 2018 manuscript expounds in full --- working through the
notation, the two puzzles, and each gadget in turn. Ben-Ari does not compete with
Kaye; he makes Kaye's proof legible. Two points deserve emphasis before we move
on. First, what is NP-complete is *consistency*, not "playing the game." Second,
Kaye's own remark that *inconsistency* is not obviously in NP already hints that
a different question about the same game may carry a different complexity ---
which is precisely the next reading's claim.

= 4. Minesweeper Inference May Not Be NP-Complete

The second reading --- Allan Scott, Ulrike Stege and Iris van Rooij, writing in
the same journal eleven years after Kaye --- accepts Theorem 1 in full, and then
makes an uncomfortable observation: it does not say what it is usually quoted as
saying.

== 4.1 The Oversight in Kaye's Argument

Kaye proved that #mcp is NP-complete, and the title and framing of his article
invite the conclusion that *Minesweeper* --- the game --- is therefore hard.
Scott, Stege and van Rooij locate a gap in that final step.

Kaye's own bridge from consistency to the game runs like this. Suppose we owned
a fast procedure $M$ for consistency. To decide whether a covered cell $s$ is
forced, first ask $M$ whether the board is still consistent once $s$ is set to
"mine." If it is not, then $s$ cannot be a mine, and is safe. If it is, ask $M$
about the nine boards in which $s$ instead shows each number $0, 1, ..., 8$; if
all nine come back inconsistent, $s$ is forced to be a mine. Otherwise $s$ is
genuinely undetermined --- move on to the next covered cell. A consistency
oracle, run this way, decides inference.

The trouble is what this argument proves. It is a reduction *from* inference
*to* consistency, and a reduction in that direction yields only an *upper*
bound: it shows inference is *no harder than* consistency. It cannot show
inference is *hard*. Scott, Stege and van Rooij put it plainly --- Kaye's
procedure "is not necessarily the only strategy" for solving inference; some
cleverer method might decide "are we forced to guess?" without ever brute-forcing
a consistency query. To show the *game* is hard one needs a *lower* bound on
inference itself, and that is exactly what Kaye's article never supplies.

#callout("The Direction of a Reduction", rgb("#e67e22"))[
  Reducing problem $A$ *to* problem $B$ shows $A$ is *no harder than* $B$ --- an
  upper bound on $A$. Showing $A$ is *hard* needs a reduction the *other* way:
  a known-hard problem reduced *into* $A$. Kaye reduced inference to
  consistency; that bounds inference from above, never from below.
]

== 4.2 What the Player Actually Solves

A real game never hands you an inconsistent board --- it was generated from an
actual mine layout. So "could this board be real?" is a question the player
never has to ask: the answer is always *yes*. The question asked on *every* turn
is the other one, #mip from Section 2.3 --- looking at the revealed numbers, *is
any covered cell forced*, so that it can be opened or flagged without a gamble?

Scott, Stege and van Rooij sharpen this into two versions. The *search* version
must actually produce a forced cell and its content, or report "the player is
forced to guess." The *decision* version merely answers yes or no to "is some
cell forced?" Playing well needs the search version, but the decision version is
already the crux: if even the yes/no question is intractable, the search version
cannot be easier. The theorem below is about the decision version.

== 4.3 Inference Lives in co-NP

Why should inference land in a different complexity class from consistency? The
answer is the quantifier, and it surfaces first in *membership*.

A covered cell is *inferably safe* exactly when, in *every* consistent completion
of the board, that cell is not a mine --- and *inferably mined* when it is a mine
in every completion. "Every" is a universal quantifier. An existential guarantee
backed by a single short witness is the hallmark of NP; a universal guarantee is
the hallmark of co-NP.

Scott, Stege and van Rooij make membership concrete with a verifier game between
an argument-maker, Anna, and a checker, Vince. To show #mip lies in co-NP, every
*no*-instance --- every board on which *nothing* can be inferred --- must come
with an argument that Anna can write down and Vince can check quickly.

Anna's argument is wonderfully direct. For *each* covered cell $s$ she supplies
*two* consistent completions of the board: one that places a mine on $s$, and one
that leaves $s$ safe. The pair witnesses that $s$ is genuinely undetermined.
Vince checks each completion the obvious way --- every revealed number must equal
the count of mines around it. A board has at most $n m$ cells, each check
inspects eight neighbours, and there are two completions per cell, so Vince
finishes in on the order of $n^2 m^2$ steps. A *no*-answer therefore carries a
short, quickly checkable certificate, and #mip is in co-NP.

#block-quote[
  Consistency, answered *yes*, is settled by one witness: a single mine layout.
  Inference, answered *no*, is settled only by two completions for every covered
  cell. The first is the shape of NP; the second is the shape of co-NP.
]

== 4.4 co-NP-Hardness: Reducing from Unsatisfiability

Membership is the easy half --- an upper bound. The lower bound, the half Kaye's
argument never delivered, is *hardness*. Scott, Stege and van Rooij prove it by
reducing from *Unsatisfiability* (UNSAT): given a Boolean formula in conjunctive
normal form, is it satisfied by *no* assignment at all? UNSAT is the
co-NP-complete complement of SAT, so a polynomial-time reduction from it into
#mip makes #mip co-NP-hard.

The reduction carries a formula $F$ to a Minesweeper board in three stages.

+ *Reshape the formula.* $F$ is first cleaned into an equivalent $F'$.
  Tautological clauses --- those containing both a variable and its negation,
  hence always true --- are deleted; a fresh single-variable clause is appended
  as a private hook for the construction; and every AND is rewritten with ORs
  and NOTs by De Morgan's law, leaving $F'$ built from OR- and NOT-connectives
  only. Each step preserves (un)satisfiability and runs in polynomial time.
+ *Build a circuit.* $F'$ is wired into a Boolean circuit $C_(F')$, its clauses
  fed through a cascade of OR-gates, which outputs *true* on exactly the
  assignments that satisfy $F'$.
+ *Build a board.* $C_(F')$ is laid out as a Minesweeper board $B_(F')$. Each
  wire, gate and crossing becomes a *tile* --- a small fixed block of covered and
  numbered cells. Variables enter through *input terminals* on the left edge;
  the circuit's output arrives at one *output terminal* at the bottom right.

#fig(
  {
    set text(size: 8.5pt)
    let fnode(body, fill) = block(
      width: 66mm,
      fill: fill,
      stroke: 0.6pt + rgb("#9aa7b4"),
      inset: 7pt,
      radius: 4pt,
    )[#align(center, body)]
    let fdown = block(width: 66mm)[#align(
      center,
      text(size: 1.15em, weight: "bold", fill: rgb("#1a3a5f"))[#sym.arrow.b],
    )]
    align(center, stack(
      dir: ttb,
      spacing: 0.5em,
      fnode([*Unsatisfiability* instance --- \ a CNF formula $F$], rgb("#fdf2e0")),
      fdown,
      fnode([cleaned formula $F'$ \ (OR- and NOT-connectives only)], rgb("#eef1f4")),
      fdown,
      fnode([Boolean circuit $C_(F')$], rgb("#eef1f4")),
      fdown,
      fnode(
        [Minesweeper board $B_(F')$ --- \ a *yes*-instance of inference iff $F$
         is unsatisfiable],
        rgb("#fdf2e0"),
      ),
    ))
  },
  [The reduction from Unsatisfiability to Minesweeper Inference. Every stage runs
   in polynomial time and preserves the answer.],
)

Scott, Stege and van Rooij assemble a full library of tiles --- wire-tiles,
shifters and joints to route a signal, crossovers to let two wires pass over one
another in the plane, and NOT-, OR- and splitter-tiles for the logic --- each a
block whose side lengths are multiples of three and whose mine count is fixed in
advance, so that the total number of hidden mines $k$ is itself determined,
exactly as the real game requires. The decisive property they impose is that *no
tile leaks*: within any single tile, the content of a covered cell can never be
deduced from that tile alone --- information enters only through the wires from
neighbouring tiles.

That non-leaking property is what makes the board behave like the circuit, and
it lets us prove the theorem outright.

#theorem("2", "Scott, Stege & van Rooij, 2011")[
  The decision version of #mip is *co-NP-complete*.
]

#fullproof[
  *Membership.* Section 4.3 exhibited, for every *no*-instance, a
  polynomial-size and polynomially-checkable certificate --- two consistent
  completions per covered cell. So #mip is in co-NP.

  *Hardness.* We show the board $B_(F')$ is a *yes*-instance of #mip exactly
  when $F$ is unsatisfiable. The reshaping step makes $F'$ satisfiable precisely
  when $F$ is; $F'$ is realised by the circuit $C_(F')$, and $C_(F')$ by the
  board $B_(F')$ through the tile library above. By construction $B_(F')$ is
  consistent, so it is a legal input to inference.

  First suppose $F$ --- equivalently $C_(F')$ --- is unsatisfiable. Then under
  *every* setting of the input wires the circuit outputs *false*, so in *every*
  consistent completion of $B_(F')$ the designated cell of the output terminal
  holds a mine. That cell is thus inferably mined: something can be inferred,
  and $B_(F')$ is a *yes*-instance.

  Conversely, suppose $F$ is satisfiable. A satisfying assignment makes $C_(F')$
  output *true*, and the matching consistent completion leaves the output cell
  *safe*. The reshaping step had deliberately given $F'$ a spare single-variable
  clause; setting that variable to *false* makes $C_(F')$ output *false*
  whatever else is chosen, so a second consistent completion leaves the same
  cell *mined*. The output cell is therefore undetermined. Every other covered
  cell lies inside one tile, and the *no tile leaks* property forbids
  determining it without information from neighbours. Hence no covered cell at
  all is forced, and $B_(F')$ is a *no*-instance.

  So $B_(F')$ is a *yes*-instance if and only if $F$ is unsatisfiable. The board
  has size polynomial in the number of literals of $F$, so the map from $F$ to
  $B_(F')$ is a polynomial-time reduction from UNSAT. As UNSAT is co-NP-complete
  and #mip is in co-NP, the problem #mip is co-NP-complete.
]

== 4.5 What "May Not Be NP-Complete" Means

The hedge in the paper's title is precisely calibrated, and worth unpacking.
#mip is co-NP-complete. Could it *also* be NP-complete? That would require it to
lie in NP in the first place --- and a problem that is both in NP and
co-NP-complete forces NP $=$ co-NP, a collapse almost every complexity theorist
believes does not occur. So, unless that belief is mistaken, #mip is *not* in NP,
and therefore not NP-complete. "May not" is exact: it reads "is not,"
conditioned on the widely held but still unproven conjecture that
NP $eq.not$ co-NP.

This is more than bookkeeping. Scott, Stege and van Rooij dramatise it with a
friend reading over your shoulder while you are stuck. There are two cases. If in
truth *nothing* can be inferred, your friend can convince you cheaply --- the
two-completions-per-cell certificate of Section 4.3 is exactly such an argument,
and you can check it in polynomial time. But if something *can* be inferred, your
friend can *not*, in general, hand you any short, quickly checkable proof that a
safe move exists at all --- not unless NP $=$ co-NP. The asymmetry is genuine:
"you are forced to guess" is easy to certify; "a safe move exists" is not.

#concept[
  For the player, the verdict is the same from either direction. Assuming
  P $eq.not$ NP, no efficient algorithm can always find a provably safe move;
  assuming NP $eq.not$ co-NP, there is not even a short, checkable proof that a
  safe move *exists*. This is the precise, formal reason that expert Minesweeper
  --- once the easy deductions run out --- still comes down to *guessing*.
]

= 5. Reconciling the Two Results

The third reading, by Thieme and Basten (2022), revisits the circuit
constructions themselves. Along the way it lays out both earlier results side by
side, which makes it the natural place to settle the title's question.

== 5.1 Two Questions, Two Answers

Kaye answered the question "*is this board consistent?*" and proved it
NP-complete. Scott, Stege and van Rooij answered the question "*is this move
forced on a consistent board?*" and proved it co-NP-complete. These are two
different decision problems, so two different answers is exactly what we should
expect. Both proofs are valid; neither refutes the other.

There is also a purely theoretical reason the two results *must* be about
different problems. As noted in Section 2.2, if one and the same problem were
simultaneously NP-complete and co-NP-complete, that would force NP = co-NP --- a
collapse almost no complexity theorist believes. So the only way Kaye's theorem
and the Scott--Stege--van Rooij theorem can both be true is for them to describe
*different* problems. And they do.

== 5.2 Technology Scaling for Minesweeper Circuits

The paper's own contribution is engineering. Kaye's and Scott et al.'s gadgets
are large --- Kaye's AND gate alone spans a $23 times 13$ block, and a wire
crossing costs two dozen gates --- because they use *safe* squares to fence
information flows apart. Thieme and Basten instead use *mines* to carry and
isolate the flows, and build every gate from a single $3 times 3$ kernel. The
result is far more compact: a sample three-literal circuit that needs a
$204 times 84$ board with the older templates fits in $57 times 21$ with theirs.
They also fold negation into the wiring, so explicit NOT gates disappear, and
give a layered scheme for *synthesising* a board automatically from a formula's
parse tree --- this is the "technology scaling" of the title.

One subtlety makes their re-proof more than a restatement. Kaye's reduction does
not control the *total number of mines*, yet a real game of Minesweeper announces
that count up front. Thieme and Basten's templates hold a predetermined number of
mines regardless of the inputs, which lets them close that gap.

#theorem("3", "Thieme & Basten, 2022")[
  #mcp remains *NP-complete* for the standard game in which the total number of
  hidden mines is fixed and given as part of the input.
]

#fullproof[
  Run the reduction of Theorem 1, but assemble $B(C)$ from Thieme and Basten's
  templates in place of Kaye's. Each template carries a number of mines fixed in
  advance, independent of the values on its ports, so the total mine count of
  $B(C)$ is determined by $C$ alone; compute it by summing over the templates
  used and write it onto the instance. The composition argument of Theorem 1 is
  untouched --- it never relied on any freedom in the mine count --- so $B(C)$ is
  consistent if and only if $C$ is satisfiable, now as an instance of the
  mine-count-given game. That version of #mcp is therefore NP-hard; it is in NP
  by the certificate of Theorem 1, hence NP-complete.
]

The same templates also drop straight into Scott et al.'s co-NP-completeness
proof. Knowing how many mines are hidden, it turns out, makes Minesweeper no
easier --- on either question.

#concept[
  There was never a contradiction. "Minesweeper" is not one problem but two.
  Choose *consistency* and the answer is *NP-complete* (Kaye, expounded by
  Ben-Ari, re-proved for the standard fixed-mine-count game by Thieme & Basten).
  Choose *inference* and the answer is *co-NP-complete* (Scott, Stege & van
  Rooij). The two theorems are compatible precisely because they are about
  different questions --- as they must be, since no single problem can be
  complete for both classes without collapsing NP and co-NP.
]

= 6. Conclusion

So: is Minesweeper NP-complete or co-NP-complete? The honest and complete answer
is that the question is under-specified, and once it is made precise it has two
parts.

- The *consistency problem* --- does a board admit *any* valid mine layout? --- is
  *NP-complete* (Kaye 2000; expounded by Ben-Ari 2018, and re-proved for the
  standard mine-count-given game by Thieme & Basten 2022).
- The *inference problem* --- is some move *forced* on a genuine, already
  consistent board? --- is *co-NP-complete* (Scott, Stege & van Rooij 2011).
- These results do not contradict each other. They concern different decision
  problems, and they *could not* both label one problem without collapsing NP
  and co-NP.

For a player, the verdict is the same either way. Assuming P #sym.eq.not NP, no
efficient algorithm can always certify a board or always find a provably safe
move; Minesweeper is genuinely, provably hard.

The broader lesson reaches past this one game. A single informal task --- "solve
Minesweeper" --- can hide several formal decision problems with genuinely
different complexities. Complexity theory is sensitive to the *exact* question
being asked, and the discipline of stating that decision problem precisely is
what turns an apparent contradiction in the literature into two compatible,
correct theorems.

A closing curiosity shows how far that discipline reaches. Kaye later studied
Minesweeper on *infinite* boards, and found that version *co-RE-complete* --- a
rung of the genuinely uncomputable. At first this looked odd: finite
NP-complete problems usually have RE-complete infinite analogues, not
co-RE-complete ones. Scott, Stege and van Rooij supply the resolution. The
infinite board generalises the *inference* problem --- the universal, co-NP side
--- and not Kaye's existential consistency problem. The very conflation this
report set out to untangle had quietly reappeared, one infinity higher up.

#pagebreak(weak: true)

= Reference

+ Richard Kaye. _Minesweeper is NP-complete._ The Mathematical Intelligencer,
  22(2):9--15, 2000.
+ Allan Scott, Ulrike Stege, and Iris van Rooij. _Minesweeper May Not Be
  NP-Complete but Is Hard Nonetheless._ The Mathematical Intelligencer,
  33(4):5--17, 2011.
+ Alex Thieme and Twan Basten. _Minesweeper is Difficult Indeed! Technology
  Scaling for Minesweeper Circuits._ In A Journey from Process Algebra via Timed
  Automata to Model Learning (Festschrift for Frits Vaandrager), Lecture Notes
  in Computer Science 13560, pp. 472--490, Springer, 2022.
+ Moti Ben-Ari. _Minesweeper is NP-Complete._ Expository manuscript, Weizmann
  Institute of Science, 2018.
