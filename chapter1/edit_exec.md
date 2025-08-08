How Code is Integrated into this Book
=====================================

This class will involve writing a lot of code.

```sidebar
Even though nowadays AI writes a lot of code for us, a good text editor
and the knowledge of how to use it is still indespendible.
```

Code appears in our book in blocks like this:

```r 
cat("Hello World!!!\n")

```
A major part of this course pertains to _how_ we organize our code and thus
we want to sometimes talk about specific _files_ with specific code in them.

We can do that easily here:

```r file=example.R
cat("<md>\n")
cat("This is a code block which corresponds to a file.\n</md>\n")

```
If you are running the book software you can edit any chunk of text or code
or even create new files by clicking a section and pressing CTRL-C CTRL-C twice
in rapid succession. 

Files are executed either in the current directory or in the nearest parent 
directory above which contains a git repository or a .project file. This
will make more sense when we cover unix stuff like directories, executables, etc.

Futhermore, we will sometimes capture output from a file and put it into the
current document. We can do this be enclosing that output in `<md>` and `</md>`
tags.

Now that that preliminary material is out of the way:

::what_data_scientist:What is a data scientist?::
