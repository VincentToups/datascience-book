History of Build Systems
========================

Build systems come from the world of software engineering. It’s not critical to understand everything they do, but some history is useful.

In the olden days, software was built in pieces and then linked together. A compiler would produce object files — isolated chunks of code — 
and then these would be stitched together by a linker into a full executable. Compilation is expensive: it transforms a textual representation of
code into machine instructions, usually doing a fair amount of optimizing along the way, so you don't want to repeat it if you don't have to.

The fundamental idea here is that we need to tell our build system:

1. what we want to create
2. what we need to create it
3. how to create it

And we call these things something like:

1. the target or the artifact
2. the dependencies
3. and the recipe

One reason we learned Bash is that the recipe is a Bash command (or commands).

We've seen a ton of Makefiles in workshops already. Here is one we will begin building toward.

``` Makefile file=Makefile9

```
Let's ::03_step1:motivate this construction a bit::. 
