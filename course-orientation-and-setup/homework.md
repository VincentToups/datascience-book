:genimg:HOMEWORK? (line drawing, sketch)::

Our first homework is to set up Podman and/or Docker on your computer.

:next:containerization:Docker and Podman are Containerization Systems:: that are
broadly compatible with one another. 

We will revisit this topic over and over again in this course because they
are foundational technologies, but the idea is this:

You have a computer. It has all sorts of stuff on it. Important files,
programs which make it run, and the software libraries they depend on.

This is all pretty fragile and so most systems have a series of permissions
which prevent you from mucking about, installing incompatible libraries,
breaking things.

But as people dipping our toes into _software_ development we will need to
configure our computers to support that. Unfortunately, as we take our
first baby steps towards this end there is a good chance we break something.

:genimg:baby steps::

Even if we don't break things, other problems arise. Sometimes two different
projects require two different versions of the same software or maybe two
different pieces of software won't play with one another. Further issues:
when we install software we really don't have any idea whether its going
to email own home directory to some hacker somewhere. By default your OS
might not even let you install software, but if it does, chances are it has
_free_ access to all your files. 

Containers solve all these problems by letting us set up many, tiny, temporary,
"virtual" computing spaces. We can make as many as we want, mess them up however
we want and throw them away, give them access to only a very limited set of our
files, if any at all, and best of all, other people have done lots of work
to set up environments for us.

For example:

```bash 
podman run rocker/verse
```
Will run an R studio server with a little linux distribution inside of it. 

```bash 
podman run jupyter/datascience-notebook
```

Will run a jupyter lab interface. Either one of these images will give you a
linux shell to play around with and you don't need to worry about messing anything
up. 

:student-select:Have you ever used a command line interface?;../students.json::

I _stronly_ recommend you try this out. 

