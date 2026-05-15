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

// Proof block.
#let proof(body) = block(width: 100%, inset: (left: 0.6em), spacing: 1em)[
  #text(style: "italic", weight: "semibold", fill: rgb("#1a3a5f"))[Proof idea.]
  #h(0.35em)
  #body
]

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
+ Alex Thieme & Twan Basten, _Minesweeper is difficult indeed! Technology scaling
  for Minesweeper circuits_;
+ Moti Ben-Ari, _Minesweeper is NP-Complete_ (2018).

The aim is not to referee a contradiction but to dissolve a confusion. The four
papers do not actually disagree with one another. They study two *different*
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
NP #sym.eq.not co-NP. One consequence matters here: *no problem is known to be
both NP-complete and co-NP-complete*, and if one ever were, it would force
NP = co-NP. So whenever a single "problem" seems to be both, the right reaction
is to suspect that two different problems have been mixed together.

== 2.3 Two Problems Hiding in One Game

This is the heart of the report. The informal task "solve Minesweeper" actually
names two distinct decision problems.

#definition[
  *Minesweeper Consistency Problem (MCP).* Given a partially marked board ---
  some cells show numbers, some are marked as known mines or known safe ---
  decide whether *there exists* an assignment of mines to the unmarked cells that
  is consistent with every shown number. In short: *could this board be real?*
]

#definition[
  *Minesweeper Inference Problem (MIP).* Given a board that is already known to
  be consistent, and a designated covered cell, decide whether that cell has the
  *same* value (mine, or safe) in *every* consistent completion of the board.
  In short: *does this real board force a particular move?*
]

The two problems differ in exactly one word --- "exists" versus "every" --- and
that is the entire story of this report. #mcp asks an *existential* question and
will turn out to be NP-complete. #mip asks a *universal* question and will turn
out to be co-NP-complete.

#concept[
  Consistency is about whether a board *could* exist. Inference is about what a
  board that *does* exist forces you to conclude. Conflating them is what makes
  the literature look contradictory.
]

= 3. Minesweeper Consistency Is NP-Complete

The first reading is Richard Kaye's 2000 paper, the result usually quoted as
"Minesweeper is NP-complete." Read carefully, the paper proves something more
precise: the *consistency* problem, #mcp, is NP-complete.

== 3.1 The Problem and Membership in NP

Kaye formalises the question a designer or analyst might ask of a board: is the
displayed pattern of numbers *internally possible at all*? Some patterns are not
--- they cannot arise from any mine layout whatsoever.

Membership of #mcp in NP is immediate. A *full mine placement* --- one bit per
cell, "mine" or "safe" --- is a certificate of size $O(m n)$. To verify it, walk
over every numbered cell and check that the count of mines among its neighbours
matches the displayed number; this takes $O(m n)$ time. If a consistent placement
exists, this certificate exhibits it. Hence #mcp #sym.in NP.

== 3.2 Kaye's Notation

To reason about *partial* boards, Kaye introduces a compact notation for the
state of a cell during a deduction.

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
  [Kaye's notation for tracking what is known about each cell while reasoning
   about a partially solved board.],
)

These labels let Kaye argue locally: a deduction step either *fulfils* a cell,
marks a neighbour, or exposes an *inconsistency*. The last case is the engine of
the hardness proof --- the construction will be rigged so that an inconsistency
appears exactly when a logical constraint is violated.

== 3.3 Local Configurations Force Global Structure

A single number is a surprisingly strong constraint, because it pins down its
whole neighbourhood at once. Kaye illustrates this with the *Square of Twos*: a
ring of cells each showing the number *2*.

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
the ring of *2* clues are squeezed into only a few possible patterns. The companion
*Square of Threes* shows the opposite extreme: with the numbers raised to *3*,
some such configurations become *unsatisfiable* --- there is simply no mine
placement that works, and the board is a *no*-instance of #mcp. Two lessons
follow: boards genuinely can be inconsistent, and small local gadgets can *encode
constraints*. Kaye's proof turns that second observation into a machine.

== 3.4 Building Boolean Circuits on a Board

The decisive idea is that a Minesweeper board can physically *embed a Boolean
circuit*. The components are built from forced mine patterns.

The basic component is a *wire*. Along a corridor of cells, the consistency
constraints leave exactly *two* possible mine patterns, and nothing in between.
We read them as a Boolean value: in Kaye's encoding, a *0* is "a mine followed by
an open cell" and a *1* is "an open cell followed by a mine." A wire therefore
carries a bit $x$, and its complement $x'$ appears interleaved along the same
track.

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
- A *NOT gate* outputs the negation $x'$ of its input.
- *AND* and *OR gates* combine two signals into one.

Wires, splitters, and gates are exactly the components of a Boolean circuit.
Anything those circuits can express can therefore be drawn as a Minesweeper
board.

== 3.5 The Reduction from SAT

Given any Boolean formula $phi.alt$, lay out a board $B(phi.alt)$ whose wires
correspond to the variables of $phi.alt$ and whose gate gadgets implement the
connectives. The layout is computed in polynomial time. The board is designed so
that a wire's two states correspond to the truth values of its variable, and each
gate gadget is *consistent* precisely when its output is the correct Boolean
function of its inputs. Consequently $B(phi.alt)$ has a consistent mine placement
*if and only if* $phi.alt$ has a satisfying assignment.

#theorem("1", "Kaye, 2000")[
  The #mcp problem is *NP-complete*. It remains NP-complete even when restricted
  to boards drawn on the standard square grid.
]

#proof[
  Membership in NP was shown in Section 3.1: a full mine placement is a
  polynomial-size, polynomially-checkable certificate. For hardness, the
  construction above is a polynomial-time many-one reduction from SAT: $phi.alt$
  is satisfiable exactly when $B(phi.alt)$ is consistent. Since SAT is
  NP-complete, #mcp is NP-hard; together with NP membership, it is NP-complete.
]

The fourth reading, Moti Ben-Ari's 2018 paper of the same name, revisits this
proof. Ben-Ari rebuilds the wire, splitter, and gate gadgets with a cleaner,
more pedagogical construction, and is careful to frame the result as a statement
about the *consistency* problem. It confirms Kaye's theorem rather than competing
with it.

= 4. Minesweeper Inference May Not Be NP-Complete

The second reading, by Scott, Stege and van Rooij, accepts Kaye's proof in full
--- and then asks whether it answered the question we cared about.

== 4.1 "But That Is Not How We Play"

A real game of Minesweeper never hands the player an inconsistent board. The
board always came from an actual mine layout, so it is consistent by
construction. The player therefore never needs to ask "could this board be
real?" --- the answer is always *yes*. What the player *does* ask, on every
single turn, is different: *given this real board, which covered cell is safe to
click?* That is the inference problem #mip, not the consistency problem #mcp.

== 4.2 Inference Is a Universal Question

Why does this change the complexity? Because of the quantifier.

"Cell $X$ is safe" is true exactly when, in *every* mine placement consistent
with the visible board, $X$ is not a mine. The word "every" is a *universal*
quantifier. Compare consistency, whose defining word is "there exists." An
existential guarantee with a short witness is the signature of NP; a universal
guarantee is the signature of co-NP.

This also pins down membership directly. To *disprove* "$X$ is safe," it is
enough to exhibit *one* consistent completion in which $X$ is a mine --- a
polynomial-size, polynomially-checkable certificate. So the *complement* of #mip
is in NP, which means #mip itself is in co-NP.

#block-quote[
  Consistency asks whether a board *could* exist, and is settled by exhibiting one
  witness. Inference asks what a board that *does* exist forces, and is settled
  only by ruling every witness out. The first is existential; the second is
  universal.
]

== 4.3 The Reduction from UNSAT

For hardness, Scott, Stege and van Rooij reduce from a co-NP-complete problem ---
UNSAT --- rather than from SAT. The intuition reuses Kaye's machinery in reverse:
take the circuit board $B(phi.alt)$ for a formula $phi.alt$, and attach a gadget
with one designated cell wired so that the cell is *forced safe* exactly when
$phi.alt$ can be satisfied by *no* assignment. Then asking "is this cell safe?"
is the same as asking "is $phi.alt$ unsatisfiable?".

#theorem("2", "Scott, Stege & van Rooij, 2011")[
  The #mip problem is *co-NP-complete*.
]

#proof[
  Membership in co-NP was shown in Section 4.2: a single completion placing a
  mine on the designated cell certifies a *no*-instance. For hardness, the
  construction above is a polynomial-time reduction from UNSAT to #mip. Since
  UNSAT is co-NP-complete, #mip is co-NP-hard; together with co-NP membership,
  it is co-NP-complete.
]

== 4.4 Hard Nonetheless

The hedge in the paper's title is exact. The problem a player solves is, to all
appearances, *not in NP at all* --- so calling it "NP-complete" is simply the
wrong label. But "not NP-complete" is no comfort to the player: #mip is
*co-NP-complete*, and co-NP-complete problems are just as intractable as
NP-complete ones unless P = NP. There is no efficient algorithm that always finds
a provably safe move. This is the precise, formal reason that expert Minesweeper
still comes down to *guessing*.

= 5. Reconciling the Two Results

The third reading, by Thieme and Basten, addresses the apparent clash head-on ---
and finds that there is nothing to resolve.

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

Thieme and Basten also return to the gadgets themselves. They make Kaye's wires,
splitters, and logic gates concrete and study how they *scale*: how the board
area grows with the size of the encoded circuit, and how reliably the gadgets
compose into large constructions. Treating the board as a circuit technology in
its own right, their work reinforces the reconciliation: pick the question you
mean --- consistency or inference --- and the matching earlier result applies,
unchanged.

#concept[
  There was never a contradiction. "Minesweeper" is not one problem but two.
  Choose *consistency* and the answer is *NP-complete* (Kaye; Ben-Ari). Choose
  *inference* and the answer is *co-NP-complete* (Scott, Stege & van Rooij). The
  two theorems are compatible precisely because they are about different
  questions --- as they must be, since no single problem can be complete for both
  classes without collapsing NP and co-NP.
]

= 6. Conclusion

So: is Minesweeper NP-complete or co-NP-complete? The honest and complete answer
is that the question is under-specified, and once it is made precise it has two
parts.

- The *consistency problem* --- does a board admit *any* valid mine layout? --- is
  *NP-complete* (Kaye 2000; Ben-Ari 2018).
- The *inference problem* --- is a given move *forced* on a genuine, already
  consistent board? --- is *co-NP-complete* (Scott, Stege & van Rooij 2011).
- These results do not contradict each other (Thieme & Basten). They concern
  different decision problems, and they *could not* both label one problem
  without collapsing NP and co-NP.

For a player, the verdict is the same either way. Assuming P #sym.eq.not NP, no
efficient algorithm can always certify a board or always find a provably safe
move; Minesweeper is genuinely, provably hard.

The broader lesson reaches past this one game. A single informal task --- "solve
Minesweeper" --- can hide several formal decision problems with genuinely
different complexities. Complexity theory is sensitive to the *exact* question
being asked, and the discipline of stating that decision problem precisely is
what turns an apparent contradiction in the literature into two compatible,
correct theorems.

#pagebreak(weak: true)

= Reference

+ Richard Kaye. _Minesweeper is NP-complete._ The Mathematical Intelligencer,
  22(2):9--15, 2000.
+ Allan Scott, Ulrike Stege, and Iris van Rooij. _Minesweeper May Not Be
  NP-Complete but Is Hard Nonetheless._ The Mathematical Intelligencer,
  33(4):5--17, 2011.
+ Alex Thieme and Twan Basten. _Minesweeper is difficult indeed! Technology
  scaling for Minesweeper circuits._ Eindhoven University of Technology.
+ Moti Ben-Ari. _Minesweeper is NP-Complete._ The Mathematical
  Intelligencer,~2018.
