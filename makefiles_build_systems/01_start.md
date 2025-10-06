Build Systems
=============

The secret to maintaining any large or long-term software project is
encapsulation: the process by which we separate what can be separated.

A failure to encapsulate is one of the biggest problems of notebook-style work:
we have a single global environment that does not enforce a particular sequence
of execution events. 

This leaves us with an unpleasant trade-off: if we want a
"canonical" result that reflects the most recent version of every code block,
we have to execute all the blocks in order. This may be prohibitively expensive
if some steps are computationally intensive. Thus we are often tempted to update
only the blocks we think we need, but this can be error-prone because all blocks
share the same global namespace and variables may be reused in different places.

So it’s not unusual for figures or tables produced by such a notebook to be of
uncertain provenance — which versions of which cells, executed in which order, produced
which figure or table?

The solution to this problem is a ::02_build_system:build system::.



