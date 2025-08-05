---
layout: post
title: What's Functional Programming?
date: 2025-08-05 16:06 -0300
tags:
- functional programming
categories:
- fp
---

When people talk about functional programming, you'll often hear terms like “pure functions,” “immutability,” “first-class functions,” and “no side effects.”
These are certainly important characteristics—but they don’t capture the _essence_ of what functional programming really is.

This confusion is understandable.
Many developers still see programming primarily as the act of controlling a computer.
From this perspective, any paradigm is judged by how it manipulates machine behavior.
So it’s natural to reduce functional programming to a list of contrasting traits.

But that’s not what programming really is—not at its core.

> Programming is the art and engineering of expressing computational ideas in code.

And that raises a deeper question: what exactly is computation?

Here’s something that might surprise you: **computation is not a given thing—computation is an engineered concept.**
It’s not a law of nature.
It’s something we define.
In fact, we typically define computation as “whatever a computer does.”
I’m not exaggerating, this is precisely how the foundation of computer science was laid.

Which leads to an interesting circularity: if computation is what a computer does, then what is a computer?
The answer is that a computer is an _abstract machine_ that has to be defined.
And once we specify how that machine operates, we’ve defined what computation means **in that model**.
That’s exactly what we do when we define a Turing Machine or the abstract machine implied by any programming language.

That is to say that different machines imply different notions of computation.
Now, here’s a key insight that follows from our definition of programming: instead of defining the computer that will carry out the computation, we can define the _language_ in which we express the idea.

This brings us to the heart of the matter:

> Functional programming is the discipline of expressing computational ideas with functions—and functions alone.

It’s a discipline for the mind, not for the machine.
And it can be practiced in virtually any programming language (though some languages make it easier than others).

To appreciate what this really means, we need to explore different notions of computation—and how functional programming builds on a radically different foundation than the imperative model.
Today, we’ll begin by examining the traditional approach:
imperative programming.

## The Imperative Approach: Computation as Machine Operation

The **imperative** paradigm is the most familiar approach to programming today.
The most relevant such machine to model this paradigm is the **Turing Machine**, introduced by Alan Turing in the 1930s.
Informally, a Turing Machine is a **finite-state automaton**—a finite state machine—that operates on an **infinite tape**.
This tape serves as both memory and communication medium.

The machine can perform three operations:
1. it can read symbols from the tape (including symbols we pre-record as input),
2. write new symbols (both intermediate data and final outputs), and
3. move the tape head left or right.

Let’s look at a concrete example:
a Turing Machine that increments a binary number by 1.
If the input is `1011` (which is 11 in decimal), the correct output should be `1100` (which is 12).

#### Machine Components
- **States**: `start`, `carrying`, `done`
- **Tape symbols**: `0`, `1`, `B` (blank)
- **Initial head position**: the rightmost digit of the input
- **Initial state**: `start`

#### Transition Rules[^1]
1. In `start`, if reading `0` → write `1`, halt in `done`
2. In `start`, if reading `1` → write `0`, move left, enter `carrying`
3. In `carrying`, if reading `0` → write `1`, halt in `done`
4. In `carrying`, if reading `1` → write `0`, move left, stay in `carrying`
5. In `carrying`, if reading `B` → write `1`, halt in `done`

[^1]: There is a serious bug in this formulation that I will discuss in another post. Can you see what it is?

#### Execution Trace

```
Initial:  B 1 0 1 1
                  ^ (head position)
Step 1:   B 1 0 1 0  (write 0, move left, carrying)
                ^
Step 2:   B 1 0 0 0  (write 0, move left, carrying)
              ^
Step 3:   B 1 1 0 0  (write 1, done)

Result:   B 1 1 0 0  (which is 1100 = 12)
```

Notice what’s happening: **the machine “computes” by manipulating symbols on a tape according to its current state**.
There is no notion of variables, no functions, no data types—just raw mechanical state transitions.
The idea of computation here is fully **mechanistic**.
The “logic” (the algorithm) is embedded in the machine’s wiring:
states and transition rules do all the work.

Note that:
1. The semantics of an algorithm described by a Turing Machine is based on the mechanics of the abstract mechanism. 
   Compare the intended behavior—incrementing a binary number by 1—with the implementation in terms of states and transitions: they look like completely different things.
   That’s why reading and reviewing code written by others is often harder than writing it ourselves.
   We need to simulate what the machine will do and try to infer the abstract behavior it implements.
   In other words, **we are given an implementation and we have to figure out its specification**.
2. Reasoning about the machine is done in terms of state transitions and memory (the tape) manipulations.
   This is the basis of complexity analysis, a fundamental tool for understanding resources usage (time and space) by software.
   But this makes it quite hard to analyze correctness.
   And we could argue that a fast but incorrect program is rarely useful in practice.
   That’s not entirely true—correctness in real-world systems is subtle, and often manifests as bugs rather than blatantly erroneous results.
   But that only makes correctness more expensive to achieve—just ask anyone who's worked with large-scale software maintenance.
3. Data is inherently mutable, since we can always overwrite what’s written on the tape.
   This is excellent for enabling hardware optimizations, but it becomes a liability when multiple machines need to work in parallel toward a common goal.
4. The evaluation order is unique and unambiguous.
   This is an advantage, actually. We will see that this aspect complicates the implementation of programming in the functional paradigm.

Alan Turing did a magnificent work starting with this model of computation and I highly recommend reading [his paper](https://www.cs.virginia.edu/~robins/Turing_Paper_1936.pdf) at least once.
In the paper, he builds a library of useful procedures and "program" a Universal Machine:
a Turing Machine that can simulate all other Turing Machines given an encoded description on its tape.
That's remarkable, not only because of the mathematical result (proving the impossibility of solving the Entscheidungsproblem), but also because he unintentionally observed that data written in the machine's memory (tape) could be interpreted as procedures to be executed, subtly blurring the line between data and code.
In some sense, we can say that Turing's framework already accounts for the idea of first-class functions, but nobody noticed.

## From Abstract Machines to Physical Computers: The von Neumann Architecture

While Turing Machines offer a powerful theoretical foundation, they are not practical devices we can build.
What we build instead—what nearly all physical computers implement—is based on a different model altogether: the **von Neumann Architecture**.

This model was first articulated in John von Neumann's 1945 report, _First Draft of a Report on the EDVAC_.
Building on ideas already in development by engineers like J.
Presper Eckert and John Mauchly, the report introduced a general-purpose design that became the near-universal blueprint for digital computers.

A von Neumann machine consists of:
- A **CPU** (central processing unit) that performs operations
- A **memory** that stores both data and program instructions
- A **control unit** that fetches and executes instructions from memory
- **Input/output** devices to interact with the outside world

The revolutionary insight was to store both program instructions and data in the same memory space.
Earlier machines had to be rewired or manually altered to change behavior; von Neumann’s model made computers _programmable_ in the modern sense—behavior could be changed by simply loading a new program into memory.

But von Neumann didn’t just unify memory—he also introduced the very notion of an **instruction**: a way of encoding operations the machine could perform.
These instructions specified the machine’s primitive capabilities, such as arithmetic operations, logic operations, control flow, and memory manipulation.
This invention laid the foundation for what we now call **machine language**, and its human-readable descendant: **assembly**.

Although von Neumann did not explicitly define _registers_—the small, fast storage locations inside a CPU where operations are performed—his design implicitly required such temporary storage close to the arithmetic unit.
The concept of registers emerged shortly thereafter, as engineers realized the inefficiency of fetching every operand from memory.
Registers became essential to mitigating the performance cost of memory access, especially under the shared bus architecture.

### Why It Matters: The von Neumann Bottleneck

This flexibility came at a cost.
Because both data and code use the same memory bus, the CPU must constantly shuttle information back and forth across a shared channel.
This limitation was described by John Backus in his 1977 Turing Award lecture "[Can Programming Be Liberated from the von Neumann Style?](https://dl.acm.org/doi/10.1145/359576.359579)" as the **von Neumann bottleneck**:

> "Surely there must be a less primitive way of making big changes in the store than by pushing vast numbers of words back and forth through the von Neumann bottleneck."

Think about the last time you wrote code in C or Python or JavaScript:
how much of your time was spent thinking about _what_ computation to express, and how much was spent managing _how_ data flows, is stored, or updated.
That’s the hidden cost of programming atop a machine model: **we think we’re writing logic, but we’re often just orchestrating memory movement**.

To make the bottleneck even clearer, let’s look at a simple C program:

```c
int square(int num) {
    return num * num;
}

void main(void) {
    volatile int arr[] = {0,1,2,3,4};
    for(int i = 0; i < sizeof(arr)/sizeof(int); i++) {
        arr[i] = square(arr[i]);
    }
}
```

This program stores five integers in an array, then squares each one.
Here's the ARM Cortex-M3 assembly generated by GCC with `-O2` (i.e., with aggressive compiler optimizations):

```armasm
main:
    mov     ip, #0                ; i = 0
    push    {r4, lr}              ; save r4 and return address in the stack
    ldr     r4, .L7               ; load address of arr initializer
    sub     sp, sp, #24           ; make space on stack for arr
    add     lr, sp, #4            ; set destination pointer for arr copy
    ldmia   r4!, {r0, r1, r2, r3} ; load arr[0..3] from .data
    stmia   lr!, {r0, r1, r2, r3} ; store arr[0..3] on stack
    ldr     r3, [r4]              ; load arr[4]
    str     r3, [lr]              ; store arr[4] on stack

.L4:
    add     r2, sp, ip, lsl #2    ; compute &arr[i] on stack
    ldr     r3, [r2, #4]          ; load arr[i]
    add     ip, ip, #1            ; i++
    mul     r3, r3, r3            ; square arr[i]
    cmp     ip, #5                ; compare i to number of elements in arr (5 ints)
    str     r3, [r2, #4]          ; store result
    bne     .L4                   ; repeat if i < 5
    add     sp, sp, #24           ; clean up stack
    pop     {r4, pc}              ; return

.L7:
    .word   .LANCHOR0
    .set    .LANCHOR0,. + 0
.LC0:                             ; array data
    .word   0
    .word   1
    .word   2
    .word   3
    .word   4
```

Let’s unpack what’s happening:

- The `main` starts by copying the array **from a read-only memory section (.data) into stack memory**.
This already involves multiple memory reads (`ldmia`) and writes (`stmia`) and address calculations (`add` and `sub`).
- Inside the loop that starts in the symbol `.L4`:
    - The index `i` is held in register `ip`, and used to calculate a memory address: `&arr[i]`.
    - The value is **loaded** from memory (`ldr`), squared (`mul`), and then **stored** back into memory (`str`).
    - The loop body contains only **one meaningful operation** (`mul`) and **several instructions managing memory access and loop control**.
- The loop itself requires multiple updates to `ip`, address calculations (`add`), comparisons (`cmp`), and conditional branching (`bne`).

What’s striking is this:
**the cost of orchestrating access to the data completely overshadows the cost of computing with it**, even in the presence of smart compiler optimizations (like inlining the `square` function).
The CPU isn’t slow—the `mul` instruction is fast.
But everything surrounding it (the “plumbing”) is where most of the program’s activity lies.

This is not a compiler inefficiency;
it’s a reflection of how von Neumann machines operate:
- Data is kept in memory.
- Computation happens in registers in the CPU.
- Moving data between the two is a **necessary and constant overhead**.

This example generalizes:
in real-world programs, most instructions involve managing memory, not computing values.
This is the **essence** of the von Neumann bottleneck.
This simple example also shows just how blazingly fast modern CPUs must be to support the fluid, responsive interfaces we take for granted today.

### An Architecture That Shapes Thinking

Backus goes deeper into the problem of the von Neumann bottleneck:

> "Not only is this tube a literal bottleneck for the data traffic of a problem, but, more importantly, it is an *intellectual bottleneck* that has kept us tied to word-at-a-time thinking..."

Because our programming languages evolved to match this architecture, they inherit its low-level concerns:
variables, memory locations, stateful updates.
These are not natural features of computation—they’re conveniences for the machine, not for the humans.

Languages designed for von Neumann machines assume mutable memory, sequential execution, and step-by-step control.
These assumptions are not inherent to computation—they are artifacts of a particular hardware-oriented model.
And while these languages make it easier to control the computer, they don’t necessarily make it easier to express or reason about computational ideas.
For instance, in our C program example, we wanted to say "square each element of this array", but we had to also describe how to control the dataflow with the `for` loop.

Functional programming begins by rejecting this machine-centered model.
It doesn't start with memory or instruction sequences—it starts with _mathematics_.
Specifically, with the notion of a function as a rule for transforming inputs into outputs.

Backus didn’t just critique the von Neumann model—he proposed a radically different vision of programming based on mathematical functions rather than memory manipulation.
In place of mutable state and instruction sequences, Backus imagined a system where computation is built from function composition, higher-order operations like map and reduce, and an algebra of programs that allows reasoning and transformation at a high level of abstraction.

> “The conventional programming languages are growing ever more enormous, but not stronger.”

He argued that functional programming could offer:
- Greater modularity and reusability
- A clear semantic model free from side effects
- Better support for parallelism and formal reasoning

His prototype language FP, though not widely adopted, planted the seed for a rich family of functional languages—from Haskell and ML to modern JavaScript's embrace of map, filter, and pure functions.
This is the intellectual path we’ll explore in the rest of this series.

## What's Next?

In the next post of this series, I'll introduce the **lambda calculus** in detail—the mathematical system that serves as the theoretical foundation for functional programming.
We'll see how this elegant formalism can express any computation using nothing but functions, and how it provides a fundamentally different but equivalent approach to the Turing machine model.

We'll explore how numbers, arithmetic, conditionals, loops, and even data structures can all be represented as pure functions, giving us a complete computational system that thinks in terms of mathematical transformation rather than mechanical operation.
