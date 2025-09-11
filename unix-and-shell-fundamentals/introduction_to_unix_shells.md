:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

# Introduction to Unix Shells

## Some Vocab!

1. shell - a program which lets you interact with all the functionality of
a system. In this context, the operating system. But other systems have
shells too. Its called a "shell" because its a shell around the OS.
2. terminal emulator - this is tricky. A shell is something that sits between
a user and an OS and the "place" it sits is the terminal emulator. At a most
basic level the user sends bytes to the shell and the shell sends bytes back.
But there all sorts of things we might want to do besides just show text: color code,
animate, show images, etc. A Terminal Emulator can do special stuff with bytes
returned by the shell to present effects, control, etc.
3. process - something running on your computer
4. signal - things we can send to processes to tell them to do something
5. standard input, standard output - each process has these. They can read
characters from the input and write to the output.
6. command line arguments - things we pass to a process when we start it
7. the environment - all the stuff a process can see when its running. Its morally
ok to imagine that when one process starts another, the child process sees all
the same stuff as the parent.

There are many shells and many terminal emulators and you can mix and match them.

We will now dive much deeper into the computer than you may have before.
What may be surprising about this jump is just how much more water there
is beneath us still: Unix Shells, while providing what must seem like
shockingly low level access to the workings of a machine compared to
modern graphical user interfaces, still afford us an almost entirely
abstract representation of our computer, albeit one which has traded
implicitness for explicitness to a great degree.

A shell (in this context) is a textual interface between you and the
services provided by your operating system. From the shell we can do all
the things we ordinarily do from a graphical user interface: inspect
files, launch programs, organize data, poke and peek at various system
resources and settings. We do these things by executing commands.

Before we dive into the details you might ask yourself: why would we
*want* to have such low level access? It is true, these text-mode shells
impose a substantial cognitive burden on the user, particularly at
first. What do we purchase with that additional cognitive energy?

1.  control - the shell gives us enormous, fine-grained, control over
    the resources the computer gives us.
2.  reproducibility - because all the actions we might undertake with
    the shell are represented as text, we can easily copy and paste them
    into a file and re-run them.

## Running a Shell

If you are on Linux or OSX you will want to run your Terminal
application. If you are working on a Windows machine you may want to
install Git Bash, Cygwin, or install Ubuntu or another Linux variant in
a Virtual Machine or spin up an Ubuntu container in Docker.

## Control

The unix Shell is loosely organized under the banner of "The Unix
Philosophy". Whereas graphical user interfaces tend to become monoliths
from which it is difficult to escape, the Unix Philosophy suggests that
tools (programs) should:

1.  do one thing
2.  do it well

This philosophy is enabled by a very simple organizational principle:
almost everything in Unix is represented as a file. All programs operate
on files, typically by reading an input file and producing an output
file. More complex outcomes are achieved by stringing many small
programs together, each operating on the output of the previous until a
desired result occurs. Text based files are very commonly the inputs and
outputs of these processes.

## Reproducibility

Unix Shells are text based interfaces. While it can seem onerous,
initially, to have to laboriously type out each desired command to the
shell, doing so is very traceable. After we understand what we want to
do by interacting with a shell directly, we can copy and paste the
commands we've concocted into a "shell script" and re-execute them.
Repetitive tasks can be trialed a few times and then run over and over
again and gradually refined.

When you combine this fact with tools like git, which make it easy to
record the history of a file over time, you have system for ensuring
that what you do is recorded for posterity and reproducible.

Graphical User Interfaces, in contrast, introduce many non-meaningful
degrees of freedom (for instance, the precise x, y coordinate of a
folder on your desktop) which make it difficult to automate workflows
for them, even when such tools exist.

Learning to use the Shell will teach you a powerful way of simple and
easily orchestrating work your computer does.

We begin shell concepts with different shells: ::many_shells:Many Shells::
