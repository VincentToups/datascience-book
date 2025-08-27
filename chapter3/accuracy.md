A Data Science Project Consists Of
==================================

Plain text scripts are run by binary executables. They load binary or plain text
data from the disk, and they create binary or plain text artefacts that are
written to the disk. 

Scripts are thus the fundamental actors in a data science project.

The benefits of organizing our thoughts like this might be obvious: if we want to
understand where an artefact came from, we need only look at the script that 
produced it. Ideally, we create small, distinct scripts that perform one or
two tasks only and produce one or two artefacts. 

:student-select:invent a question; ../students.json::

Another benefit is that artefacts, once produced, are independent of any script 
or programming language. 

A key idea here is that we should organize our project in a way that *reduces
cognitive load*.

Just thinking in these terms already reduces our brain load substantially. The
rest of our lecture today will involve improvements on this basic idea.

Let's work on ::preliminaries:preliminaries::.

```sidebar
cf. the Jupyter Notebook style of data science. In that world, _cells_ in the
notebook might read data from the disk or from a URL, and each cell might
perform a computation, the result of which is stored in memory as some
variable. 

The reason we don't like this is that it's conceptually fairly dirty: our code
is just a set of cells (which have only order to relate them), and our artefacts
are mixed in memory with all the other intermediate variables and values
we used to produce them.

```
