:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

# Linux Variants and Package Managers

The primary reason we want to develop some comfort with Linux is because
we will be using it to build environments for doing data scientific
work. And the most frequent thing we will do to set those environments
up is install software.

Throughout this book we will be using Ubuntu Linux (in the form of the
`rocker/verse` Docker containers) as our basis for our data science
projects. Sometimes we might want to extend that container with other
tools like Python and Jupyter. Adding software to a Linux system is the
job of a package manager.

Complicating this discussion is the fact there are a variety of package
managers for a variety of linux variations.

Here, we will almost always be using `apt` to install packages (unless
we use a programming language specific package manager, of which more
later). But be aware that at some point in the future you might have to
look up how to use another system's package manager.

Finally, let’s wrap up with a few concluding notes: ::concluding_notes:Concluding Notes::
