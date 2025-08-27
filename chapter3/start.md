Project Organization
====================

In the last chapter we created a little data analysis of some voltage
traces from some simulated neurons.

Roughly, 

We loaded the data (and did some tidying we didn't really talk about), performed
PCA on the traces, plotted them in 2D, noticed clusters, automatically clustered
the data, plotted the average traces, and then we flipped the problem around
and tried to see what points in time best split one of the clusters by doing
a logistic regression.

:student-select:invent a question; ../students.json::

These were split into a variety of files, but not in a formal way. So let's
create a more formal, if small, project.

But first let's lay out a few concepts and definitions.

1. **script**: a text file which, when "run" by a programming language's interpreter
   produces output and/or results, which we call artefacts.
2. **artefact**: a static thing that "is" rather than "does something." Obvious
   artefacts are image files (png, svg, pdf), documents (text, markdown, pdf), data-
   sets like csv files, SAS binary files, R binary files, Python pickles, etc. Less
   obvious artefacts are things we provide directly but are not created by scripts:
   scripts themselves are artefacts, raw data is an artefact, the source code for
   documents is an artefact.
3. **binary file**: a binary file is one which we need some external program to 
   interpret. Example binary files are executables (usually), Word documents,
   SAS binary files, RDS files, zip files, pickles, pngs. Note that it's almost 
   always the case that if we have a binary file it's an artefact, not source code.
4. **text file**: sometimes called "plain text" files to distinguish them from 
   binary files which represent text like Word documents. Plain text files just
   contain bytes (usually with an implicit or explicit *encoding* which determines
   which bytes constitute which characters). We don't need special programs to
   examine and edit text files. All the utilities on the Unix shell work with text
   files by default and we use something called a text editor to edit them. Back when
   ::ascii:ascii:: was the mostly standard way to denote text this distinction was more
   clear.
5. **text editor**: a special program dedicated to editing and manipulating plain 
   text files. Since scripts are always plain text files and most of the work of 
   doing data science is writing scripts, we need to use text editors to do the work.
   RStudio's editor is a plain text editor, but there is a long and varied tradition
   of text editing which includes programs like Emacs and Vim and modern "integrated
   development environments" like Visual Studio.

With this vocabulary we can describe our project with ::accuracy:more accuracy::.

:student-select:invent a question; ../students.json::
