Object Oriented Programming
===========================

Object Oriented Programming is a paradigm shared by a large plurality
of programming languages oweing to a deceptively simple typical
presentation:

You think about what you are programming as objects, usually of
discrete classes, and then you describe, via "methods" what sorts of
things those object do. Then you express your programs in terms of
operations on and with objects.

The main purported benefit of this is encapsulation: we think of our
objects as having some data inside of them, but the methods form an
interface to the object which allows a user to not pay attention to
the internal details.

This is a very loose idea, and you can already see example of it in R:
the tibble is a collection of named columns with types, but we don't
often think about how all that works. We just use the methods dplyr
and other packages give us and we do what we need to do.

Genericity
==========

There are other ideas associated closely with object oriented
programming, and one of them is genericity: the ability to call the
"same" method on different types of objects and have different, but
appropriate things, happen.

We actually have seen this lurking in R as well:

```

lmfit <- lm(...)
predict(lmfit,...)

glmfit <- glm(...)
predict(glmfit, ...)

```

`predict` in the above example is a method. Methods are purported to
be useful because you could write some code and change your model type
but not change your prediction lines. The method `predict` is
supposedly "generic" over its input type.

This kind of object oriented programming is easy to accomplish in R:

```R
make_sound <- function(x, ...) {
  UseMethod("make_sound")
}

dog <- function(name) {
  structure(list(name = name), class = "dog")
}

cat <- function(name) {
  structure(list(name = name), class = "cat")
}

fox <- function(name) {
  structure(list(name = name), class = "fox")
}

make_sound.dog <- function(x, ...) "Woof!"
make_sound.cat <- function(x, ...) "Meow!"
make_sound.fox <- function(x, ...) "Yip!"

# Example usage
fido <- dog("Fido")
whiskers <- cat("Whiskers")
todd <- fox("Todd")

make_sound(fido)
make_sound(whiskers)
make_sound(todd)
```

The key ideas here are that we first declare the existence of a method
`make_sound` and then we declare a series of "implementations" of the
method. In S3 (one of R's many object systems), the *name* of the
function determines both which method and which type the functions are
associated with. Those three function definitions cannot have
different names, otherwise this won't work.

Note that in the above, the objects returned by the so-called
`constructors` (the functions which return dogs, cats, etc) are indeed
lists - the structure function just decorates them with meta-data.

Perhaps you can already see the utility of such a system?

The next usual idea is ::02_inheritance:inheritance::.



