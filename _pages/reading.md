---
layout: page
title: What to read
---

A curated list of books for programmers who want to build things that endure.
Click any title below to read commentary.

## Books

- [Douglas Hofstadter — *Gödel, Escher, Bach* (GEB)](#geb)
- [Harold Abelson and Gerald Jay Sussman - *Structure and Interpretation of Computer Programs* (SICP)](#sicp)
- [Charles Petzold — *The Annotated Turing*](#annotated-turing)
- [Eric S. Raymond — *The Cathedral and the Bazaar*](#cathedral-bazaar)
- [A. G. Sertillanges — *The Intellectual Life*](#sertillanges)
- [Edward A. Lee — *Plato and the Nerd*](#plato-nerd)

## Articles/Papers

- [John Backus - *Can Programming Be Liberated from the von Neumann Style?*](#backus-liberated)
- [Peter J. Landin — *The Next 700 Programming Languages*](#landin-700)
- [Ken Thompson — *Reflections on Trusting Trust*](#thompson-trust)

<br>

## Why I made this list

I’ve been working with novice and experienced programmers for almost fifteen years.
Thousands of students have attended my lectures; I’ve supervised a few dozen more closely.
And every so often, someone stands out — a young, curious mind who senses that something’s missing.

They can’t quite name it.
They just feel a kind of **void** — like they’re *doing* things, solving problems, writing code — but not *growing* in the way they hoped.

I feel that too.
Even after twenty years of professional work, first in electronics, now in protocols and software engineering;
that sense never quite disappears.
There’s always another layer.
Another connection to make.
Another system to understand more deeply.

This list is for them; and for the twenty-year-old me.
If you feel that same restlessness, that hunger for something more than just the next framework or ticket, I hope this list offers a starting point.

It’s not a checklist.
It’s a **conversation across time** with people who thought deeply and built carefully.
You don’t read these books to finish them.
You read them to *join* that tradition.

I hope it serves you well.

<br>
<details>
<summary><strong>Now, truly why I care about this list...</strong></summary>
<div>

<h2>Most software today is built to be forgotten</h2>

<p>Written in haste, layered with abstractions, then discarded with the next trend.
We build like amnesiacs: few know how the systems beneath them truly work.
Fewer care.
The result is not progress, but erosion masked as innovation.
Like a civilization building towers higher and higher while forgetting how to quarry stone.</p>

<p>Jonathan Blow warned us of this trajectory:
a slow technological decline driven not by catastrophe, but by accumulated ignorance.
As layers pile on, foundations are lost.
One day, the lights will go out—not because no one tried to keep them on, but because no one remembered how.</p>

<p>There is another path.</p>

<p>We can choose to treat software not as a disposable product, but as a form of cultural expression.
A craft whose goal is not speed or scale, but clarity, permanence, and meaning.</p>

<p>This is the path of Emacs, Vim, Unix, and many other libraries and systems built and maintained in C — that old, unsafe language.
The very same language used to build and maintain most of the internet’s infrastructure.
Systems some now call “legacy,” but which are, in truth, civilizational infrastructure.</p>

<p>People say JavaScript is the language of the internet.</p>

<p>It is not.</p>

<p>The true languages of the internet are plain old C and C++, the very languages no one wants to teach or learn anymore.
Sorry to say, but JavaScript is just a rushed wrapper over decades of C and C++.
It can do some cool, good-looking stuff, because the marvel that is a modern web browser; guess what, written in C and C++.
But we can’t count on it to keep the edifice from falling apart.</p>

<p>Don’t get me wrong — we need those things too.
A Ferrari isn’t a Ferrari without leather seats and polished interiors.
But no one dreams of owning one because of the leather.
They dream of the engine, the pristine mechanics, the architecture that makes performance possible, and the artisanship of a machine built by engineers and technicians who are also craftsmen.</p>

<p>These things have not survived in spite of their age.
They have survided because some people took the time to develop rare and deliberate skills.
They have survived because these people want to transcend their own lives by doing timeless artifacts.</p>

<p>To walk this path requires more than technical competence.
It requires erudition.</p>

<p>Erudition is not mere knowledge—it is the discipline of memory.
It is the refusal to discard what came before simply because it is old.
It is what separates the craftsman from the technician.
The former builds tools; the latter uses them.</p>

<p>This is not a call for nostalgia.
It is a call for depth.</p>

<p>Edsger Dijkstra argued that software should be beautiful, that clarity and elegance are moral virtues in code.
Richard Stallman, despite his politics, glimpsed something similar: software, if well written and liberated from arbitrary dependencies, becomes free from its creators.
It becomes self-sufficient, a thing that exists on its own terms.</p>

<p>To write such software is not merely engineering.
It is a form of authorship.</p>

<p>And yet, why bother?</p>

<p>Economics can’t fully explain open source.
Eric Raymond got close.
Yes, incentives matter, but the real motivation is harder to measure.
It’s not just reputation or signaling.
It’s something older, deeper.
The pride of the artisan.
The drive to leave something behind.
The desire to see one's soul reflected in a functioning machine.</p>

<p>We don't need more developers.
We need stewards of tradition.
Programmers who see themselves as participants in a conversation older than their tools.
Programmers who understand that code is not just meant to work, but to last.</p>

<h4>On Education and the Cult of Utility</h4>

<p>Our institutions are not preparing the next generation to build what endures.
I know that very well, I'm a professor at a major university in Brazil.
And truth be told, I'm probably more part of the problem than the solution.</p>

<p>Schools are increasingly pressured into “project-based,” “real-world,” “hands-on” pedagogies—buzzwords that too often mean building whatever solves the most immediate problem, then moving on.
This is the educational branch of the same Silicon Valley rot: fail fast, fail often, ship it, forget it.</p>

<p>At the same time, theory-driven programs—those that ground students in algorithms, computation, and systems—are dismissed as outmoded.
Why study SMTP when you can deploy a serverless app in five minutes?
Why implement a shell when you can call one?
Why understand when you can use?</p>

<p>This is a catastrophe disguised as relevance.</p>

<p>Real-world problems aren’t just the ones we face now—they are the ones we’ve already solved.
The wheel, once invented, is worth studying.
But we rarely ask students to reimplement anything that matters.
How many have written a shell?
A CLI email client?
A toy compiler?
A browser?
An operating system?
These are exercises not in nostalgia, but in transmission—how to pass down the thinking behind software that actually lasts.</p>

<p>Instead, we hand students tools as if they were gifts from God.</p>

<p>But God does not maintain software. That’s up to us.</p>

<p>But wait, Edil — what do you mean by <em>us</em>?
Where’s the timeless code you’ve written yourself?
You might ask me that.
And it hits me hard.
I truly envy some of the programmers I’ve worked with. 
When I watch them do their craft, I wish I were doing that too.</p>

<p>But I’ve also come to realize that, almost as important as having the artists working, is inspiring and guiding the next generation of artists.
I believe I could be building good software.
But I also believe I’m most valuable when I help build good people.</p>

<p>I hope I’m doing that well enough.
But only time will tell.
And I don’t care if nobody sees it.
I’m trying to shape people in a tradition I believe leads to real progress, not just good-looking frontends.
If two or three of them end up helping to build something truly foundational — something that lasts — that’s probably more than I could have done myself.</p>

<h4>On AI and the Seduction of Vibe Coding</h4>

<p>The recent obsession with large language models has amplified the very disease we aim to treat.
It is now fashionable to "vibe code"; to prompt a machine, skim the output, and paste until it runs.
It feels like programming.
It looks like productivity.
But it is neither.</p>

<p>Vibe coding is just the latest form of disposable software creation.
It encourages the illusion of mastery while hollowing out the discipline itself.
You are not becoming a better developer by prompting until it compiles.
You are simply becoming a more efficient operator of a glorified autocomplete engine.</p>

<p>There is nothing wrong with using LLMs, when used with intentionality and craft.
For the erudite programmer, these models are like sharpened chef’s knives: amazing tools for thought that can accelerate judgment, precision, and depth.
But in unskilled hands, they do not produce better software.
They produce more software.
Worse software.
Cheap, flimsy, mass-produced code—the Chinese plastic of the digital world.</p>

<p>And worst of all:
we are deceiving ourselves.
We confuse activity with learning.
We conflate output with experience.
We mistake convenience for growth.</p>

<p>Like junk food for the mind, we’re intoxicating ourselves with crap software.
It fills you up, but it doesn’t nourish.
And over time, it rots your taste, until you can’t even tell the difference between a fine wine and vinegar.</p>

<p>This is why we read.
Not to memorize syntax, but to train our taste.
Not to chase novelty, but to understand roots.
Not to master tools, but to become worthy of building them.</p>

<p>Let others chase the ephemeral.
We are here to build what endures.</p>

<h4>Why I Care About This List</h4>

<p>Because I remember, every single day, what it feels like to be lost in the noise.
To want to become a great engineer, but not know where to look.
To feel that something important is missing, some deeper foundation, and yet be handed only tools, frameworks, and deadlines.
And to feel lonely (and a little afraid that I'm crazy) because no one around seems to feel the same.</p>
    
<p>This list is my attempt to push back against that.
To offer a path.
A tradition.
Not a curriculum.
Not a checklist.
Just a thread you can pull — if you're ready to go deeper.</p>

<p>This is a way to start a conversation with the great minds who came before us.
Because great people have always existed.
Because brilliant thinkers lost sleep over the problems we now treat as trivial.
Because they offered solutions in a time of scarcity, when computing was expensive, memory was counted in kilobytes, and mistakes had consequences.
They had no resources to waste like we do now.</p>

<p>I’ve read every reference in this list — some of them many times.
I’ve read far more than what’s here, but these are the books that made me think.
These are the ones I wish I had started with, twenty years ago.
No, these are the ones I wish I had read in spite of all others.
I can’t go back in time.
But maybe I can help someone else avoid the fast-food books and disposable references.</p>

<p>Learning is not a linear process.
Other than <em>GEB</em> and <em>SICP</em>, I don’t think there’s a right order to begin digesting these works.
Embrace the chaos.
Read these books in any order.
Study them while you work your day job.
Keep your mind’s eyes sharp and open and over time, you’ll begin to see where the pieces connect, and how to create better artifacts.
Not by doing it right the first time, but by iterating.
By refining.
By caring.</p>

<p>Finally, I care because I’ve seen what happens when a curious student finds the right book or the right questions at the right time.
It changes everything.
Sometimes, all someone needs is a door left slightly open, and a hint that there’s more on the other side.</p>

</div>
</details>

---

### Douglas Hofstadter; Gödel, Escher, Bach (GEB) {#geb}
If you're going to read only one book from this list, make it this one.

It’s not a book about software development per se.
The central question it explores is:
**how can inanimate systems become animate?**
Or put differently: how can self-awareness emerge from formal, mechanical rules?

The thesis is deeply relevant to the way we think as programmers.
Formal systems are the atoms of computer science.
Every programming language is a formal language; every computer implements a formal system.
And yet, Hofstadter shows how these rigid systems can give rise to self-reference, recursion, and ultimately, meaning.

This book will stretch your intuition.
It uses computers not just as tools, but as metaphors.
It draws analogies between symbols in logic, notes in music, and patterns in biology.
It connects Gödel’s incompleteness theorems to Bach’s fugues and Escher’s paradoxes, all in the service of understanding what it means for something to *think*.

To understand computing deeply is not to build apps or automate workflows.
It is to see the world differently.
*Gödel, Escher, Bach* offers a lens; one that most people will refuse to wear, but that will permanently rewire how you think if you do.

### Harold Abelson and Gerald Jay Sussman - *Structure and Interpretation of Computer Programs* (SICP) {#sicp}
This is the best book on computer engineering.

It’s old. It uses LISP, a language many today consider dead or academic.
So yes, it *feels* old-fashioned.
But its content?
Timeless.

SICP teaches you how to think about **abstractions**, the cornerstone of software engineering.
It builds everything from first principles, using elegant code examples and exercises that still challenge experienced developers today.

If you’re used to only listening to hip-hop, the symphony that is this book might sound boring, maybe even useless.
But every rock and pop star studied classical music.
Not to write fugues, but to understand how good ideas are put together to make art.

You don’t read SICP to learn a language.
You **study** it to learn how to build *anything* — in any language that matters today.

You can also watch the [MIT lectures on their OpenCourseWare platform](https://ocw.mit.edu/courses/6-001-structure-and-interpretation-of-computer-programs-spring-2005).
There are also excellent commentaries on the [code_report youtube channel](https://youtube.com/playlist?list=PLVFrD1dmDdvdvWFK8brOVNL7bKHpE-9w0&si=I5TNlBWIYFl9nXHo).

### Charles Petzold — *The Annotated Turing* {#annotated-turing}

Ah, Alan Turing — the founding father of computer science.

He wasn’t trying to build machines or start a revolution.
He was trying to solve a **fundamental problem in mathematics**:
what can or cannot be proved?
His 1936 paper on the *Entscheidungsproblem* (decision problem) is to computer science what Einstein’s first paper on relativity is to physics: a new kind of foundation we now take for granted.

Turing did the unthinkable.
He **defined what a computer is**, before computers existed.
In his time, a “computer” meant a person who carried out calculations by hand.

And yet, despite the influence of his work, I’d wager 99% of programmers and computer scientists have never read this paper.

It’s not that hard.
The notation is strange, sure; we’ve had nearly a century to clean that up.
But the ideas are astonishing.
This is a human being formalizing the limits of reason, the boundary between mechanical logic and intuition.
It’s philosophy in math’s clothing.

Charles Petzold’s book walks you through Turing’s original paper, line by line, with commentary and context.
It’s like sitting beside Turing at the blackboard — with a patient guide explaining what he was trying to do and why it mattered.

If you call yourself a computer scientist and haven’t read this yet, consider this your invitation.
Or your reckoning.

### Eric S. Raymond — *The Cathedral and the Bazaar* {#cathedral-bazaar}

> “Writing software is about people, not about computers.”

That’s something I say often, especially when someone comes to me eager to learn how to program.

On one hand, writing software is about communicating an idea.
But it's also about solving a problem; and problems are something **people** have, not computers.
Computers just sit there.
It’s *people* who use them as tools.

This book is a collection of essays about **how** software is developed by people.
Most programmers experience the *Cathedral* model:
a highly organized, top-down structure, usually a company, building a product in a planned, centralized way.

And yet, those same programmers are relying on dozens (or hundreds) of libraries and tools built under an entirely different model: open source.

Eric Raymond’s essays reflect on the *Bazaar* model — chaotic, decentralized, voluntary collaboration.
Why do people do it?
What are the unwritten rules of etiquette?
And how can a supposedly disorganized mess of programmers working after hours — unpaid — somehow build the most reliable and fundamental parts of the internet?

Read this to think about the **sociology of software**.
Because if these people ever stop doing what they do, we may well regress into the digital stone age.

### A. G. Sertillanges — *The Intellectual Life* {#sertillanges}

"Should I do a master's? A PhD? Or something else?"

That’s one of the most common questions I hear from young people with bright minds and a growing itch they can’t quite name.
I often answer with something like:
*“It depends on who you want to become.”*

That's a truly difficult question, maybe the ultimate question of life.
Because what many of them are truly seeking is not a diploma, but a life.
A way of living.
They’re yearning for the intellectual life — they just don’t have the words for it yet.

This book gives them those words.

Written in the early 20th century by a French Dominican priest, *The Intellectual Life* is a profound guide to pursuing truth through study, reflection, and discipline.
It speaks to anyone drawn to a life of the mind — whether inside the university or far beyond it.

Yes, having a good advisor can help.
Yes, formal institutions can offer structure.
But the real journey of intellectual growth is solitary, humble, and internal.
No institution can give it to you — and none can take it away.

If you’ve ever felt that hunger to go deeper — to read more, write better, think harder — this book is a quiet but powerful companion.

And it aligns perfectly with the spirit of this reading list:
It’s not about following trends.
It’s about cultivating a deeper, slower kind of growth.
The kind that makes you useful to others — not just because of what you can do, but because of how you think, and who you are becoming.

### Edward A. Lee — *Plato and the Nerd* {#plato-nerd}

This is an unusual one.
Written by Berkeley professor Edward Lee, *Plato and the Nerd* is a philosophical reflection on engineering and the nature of technology.
It’s one of the rare books that treats engineers not as tool builders or code monkeys, but as thinkers — creators of models, theories, and meaning.

The core idea is that engineering is fundamentally a **top-down process**.
We don't start from physical constraints and work up.
We start from ideas.
From abstractions.
From *models* — which we then try to realize in the physical world.

Sure, physical constraints eventually push back.
But the act of invention is, at its core, *free*.
It’s Platonic.
It comes from the mind, not from the material.

This is an important corrective to the current obsession with “just build it” and “move fast” cultures.
Engineering is not about duct-taping things until they run.
It’s about thinking deeply and systematically.
It’s about crafting elegant models that survive contact with reality — and sometimes even reshape it.

If you’ve ever felt that your work is more than code, more than tools — that you’re participating in a centuries-old tradition of modeling the world — this book will resonate.

It’s a call to take that tradition seriously.

---

### John Backus — *Can Programming Be Liberated from the von Neumann Style?* {#backus-liberated}
[https://doi.org/10.1145/359576.359579](https://doi.org/10.1145/359576.359579)

John Backus was an engineer, not an academic.
He built Fortran — the first truly useful high-level language.
So useful, in fact, that we maintain some of the best linear algebra libraries still in use today in Fortran, forming the numerical backbone of our so-called AI era.

Fortran is an imperative language — a style that mirrors how computers work.
Each line is a command, compiled into more primitive machine instructions.
And that’s still how most mainstream languages work today.

This paper is the transcript of Backus’s Turing Award lecture (the closest thing to a Nobel in computer science).
He used the stage not to celebrate his creation, but to question it.
To say: *“I helped build this, it shaped the field… but I think we’ve gone astray.”*

Backus observed that we design programming languages primarily to extract performance from imperative machines.
And yes — software does have to run on computers.
But programming languages are, above all, **languages**.
People use them to express ideas.

And language shapes thought.
The way we write code constrains how we reason about it — and even what we can imagine.

In this paper, Backus argues that we should design languages around how **humans think**, not how computers execute.
The computer is the tool.
It’s the machine that should adapt to us — not our minds to its architecture.

### Peter J. Landin — *The Next 700 Programming Languages* {#landin-700}
[https://dl.acm.org/doi/10.1145/365230.365257](https://dl.acm.org/doi/10.1145/365230.365257)

If this paper were taught in first-year computer science programs, we probably wouldn’t have so many shallow languages today.

Think of the countless JavaScript frameworks — each acting as a specialized dialect.
None introduces a new way to think.
They just make it more convenient to express certain patterns:
Need a button on the screen?
Call this function.
Need to load a video?
Call that other one.
And now even the simplest landing page runs a dreadful amount of unnecessary (and potentially harmful) code.

If John Backus warned us about the von Neumann style poisoning our minds, Landin gave us the first serious blueprint for escaping it.
He advocated for a shift from **operational semantics** — what the computer does — to **denotational semantics** — what the program *means*.

Even if you never write a line of code in a purely functional language, this way of thinking will change how you see software.
It will make you a better designer of abstractions.
It will train you to care not just about what code does, but about what it *says*.

### Ken Thompson — *Reflections on Trusting Trust* {#thompson-trust}
[https://dl.acm.org/doi/10.1145/358198.358210](https://dl.acm.org/doi/10.1145/358198.358210)

A short but devastating paper by one of the wizards of our field — co-creator of Unix, C, and Go.

In just a few pages, Ken Thompson demonstrates how easy it is to hide malware in a compiler, in a way that survives even if you inspect and recompile the source code.
The point is not the exploit — it’s the insight:
**trust in software is never absolute**.
Every tool you use is built on a foundation you probably didn’t verify.

This paper should be required reading in the age of dependency hell.
Who hasn’t compiled a small Go or Rust program, only to see hundreds of direct and indirect dependencies pulled in automatically?
It's convenient, sure — but it’s also terrifying.
Auditing that much software is nearly impossible.
And the more we depend on layers we don’t understand, the more fragile and opaque our stack becomes.

And now we’re generating even more of that opaque code — with AI.
Models trained on an ocean of unknown-quality code are producing snippets we didn’t write, can’t fully audit, and often don’t truly understand.
We’re not just trusting code — we’re trusting code that was written by code that was trained on untrusted code.

We are building castles on sand — and the sand is now writing the blueprints.

Thompson’s warning still stands:
*“You can’t trust code that you did not totally create yourself.”*
That doesn’t mean you should write everything from scratch — but it does mean you should *understand what you're trusting, and why.*
