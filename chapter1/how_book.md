What is This "Book"
===================

I wrote this book (with liberal assistance from an AI) because nothing
in the world of data science software met my requirements for teaching this
course.

Most of the software people use for data science (Jupyter notebooks in 
particular) seem to wish to insulate you from your development environment
and to provide a monolithic software object that you interact with. This, 
however, goes against a philosophy which I strongly support, often called the
Unix philosophy.

In the rest of the software world tools try to do as much as possible, at least
partially because they are often commercial products and commercial products
want to lock you into using them and part of the way to do that is to let 
you do whatever you want from the software. This is why Netflix wants
you to play games on their platform now, for example.


```sidebar
Zawinski’s Law of Software Envelopment, attributed to Jamie Zawinski:

"Every program attempts to expand until it can read mail. Those programs which cannot so expand are replaced by ones which can."

https://www.laws-of-software.com/laws/zawinski/
```
In contrast, I prefer the so-called "Unix Philosophy," which says:

>It was later summarized by Peter H. Salus in A Quarter-Century of Unix (1994):[1]
>1. Write programs that do one thing and do it well.
>2. Write programs to work together.
>3. Write programs to handle text streams, because that is a universal interface.


The problem is that modern data science software is much more like
Netflix than the Unix Philosophy. I think RStudio is closer to what I wanted
from teaching software, but the tools for writing lectures in that software
are not good: R Markdown in particular encourages us to interweave code
and writing in a way where there is a large shared scope and discourages
us from thinking of our data science as clear, distinct, steps with clear
inputs and outputs.

So I wrote this software to allow me to present a book-style interface without
the bad habits we get from using R Markdown or Jupyter Notebooks.

Parts
-----

The book is available in two parts. First of all the *contents* of the book 
itself are located here:

https://github.com/VincentToups/datascience-book.git

While the book software is located here:

https://gitlab.com/vincent-toups/labradore/

You should be able to run this software soon, since we are going to talk about
podman/Docker next.

Finally, the book itself is NEW but the old 611 notes are available here:

https://github.com/Vincent-Toups/6112024

Although the course will be somewhat different this year. I will try to make
sure each lecture is published before class along with a list of reading 
materials.

The Terminal
------------

First of all, to our left, black as the void, is a Unix terminal. Unix is
really key to the course because _half_ of what I want to teach you is how
to _really_ do the work, to be in command of the actual tools which you will
use as you do computer-assisted research. And central to that is Unix. 

Probably because of the Unix Philosophy, Unix is the de facto standard way of 
connecting tools together and inevitably, data scientists have to do that. 

Jupyter can only protect you for so long. 

So there is the terminal. You can just type commands into it. Try it!

But this book is meant to be much more than just a place where you can look at
the terminal.

We can also ::edit_exec:edit and execute code::.
