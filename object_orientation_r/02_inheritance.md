Inheritance
===========

Superficially it seems like objects tend to live in hierarchies. For example:

There are animals, of which dogs and cats and foxes are examples, and
those groups are further broken down into smaller groups eg, Irish
Setters, Border Collies, Labradors are all dogs.

The main idea behind inheritance is that if we represent those
hierarchies in our programs then we can save work:

```R
# S3 multiple-inheritance demo: animals, dogs, and dog breeds

make_sound <- function(x, ...) {
  UseMethod("make_sound")
}

# Base constructors
animal <- function(name) structure(list(name = name), class = "animal")
dog    <- function(name) structure(list(name = name), class = c("dog", "animal"))
cat    <- function(name) structure(list(name = name), class = c("cat", "animal"))
fox    <- function(name) structure(list(name = name), class = c("fox", "animal"))

# Dog breeds (inherit from dog -> animal)
border_collie <- function(name) structure(list(name = name), class = c("border_collie", "dog", "animal"))
labrador      <- function(name) structure(list(name = name), class = c("labrador", "dog", "animal"))
irish_setter  <- function(name) structure(list(name = name), class = c("irish_setter", "dog", "animal"))

# Methods
make_sound.border_collie <- function(x, ...) "Ruff!"
make_sound.dog           <- function(x, ...) "Woof!"
make_sound.cat           <- function(x, ...) "Meow!"
make_sound.fox           <- function(x, ...) "Yip!"
make_sound.animal        <- function(x, ...) "Some generic animal noise"
make_sound.default       <- function(x, ...) "Silence"

```

In this example we can see that each type of thing in our little
system has multiple classes to which it belongs. Note that we list
these in order of most specific to least specific, so that when our
method is invoked we get the most specific implementatioin possible.

In code we can always just call "make_sound" and now we have a method
which is both generic *and* implements an object hierarchy.

```R
# Example Usage

fido  <- dog("Fido")
milo  <- cat("Milo")
todd  <- fox("Todd")

shep  <- border_collie("Shep")
buddy <- labrador("Buddy")
seamus<- irish_setter("Seamus")

make_sound(fido)    # "Woof!"
make_sound(milo)    # "Meow!"
make_sound(todd)    # "Yip!"

make_sound(shep)    # "Ruff!" (breed-specific override)
make_sound(buddy)   # "Woof!" (inherits dog method)
make_sound(seamus)  # "Woof!" (inherits dog method)
```

This system is a little informal - it captures the essence of some of
object oriented programming but in a loose way.

Thus, R has an absolute zoo of object oriented programming systems, of
which the next is ::03_s4:S4::.

