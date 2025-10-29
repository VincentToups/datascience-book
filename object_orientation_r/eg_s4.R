library(tidyverse)
## S4 Example: Animal hierarchy, Person inherits from Animal

setClass("Animal", slots = list(name = "character"))
setClass("Dog", contains = "Animal")
setClass("Cat", contains = "Animal")
setClass("Fox", contains = "Animal")

setClass("BorderCollie", contains = "Dog")
setClass("Labrador",     contains = "Dog")
setClass("IrishSetter",  contains = "Dog")

## Person is also an Animal
setClass("Person", contains = "Animal")

## Generics
setGeneric("make_sound", function(x) standardGeneric("make_sound"))
setGeneric("interact", function(x, y) standardGeneric("interact"))

## make_sound methods
setMethod("make_sound", "Animal", function(x) "Some generic animal noise")
setMethod("make_sound", "Dog",    function(x) "Woof!")
setMethod("make_sound", "Cat",    function(x) "Meow!")
setMethod("make_sound", "Fox",    function(x) "Yip!")
setMethod("make_sound", "Person", function(x) x@name)
setMethod("make_sound", "BorderCollie", function(x) "Ruff!")

## interact methods (multi-dispatch)
setMethod("interact", c("Person", "Dog"),
  function(x, y) paste(x@name, "plays fetch with", y@name))

setMethod("interact", c("Dog", "Cat"),
  function(x, y) paste(x@name, "chases", y@name))

setMethod("interact", c("Cat", "Dog"),
  function(x, y) paste(x@name, "hisses at", y@name))

setMethod("interact", c("Dog", "Fox"),
  function(x, y) paste(x@name, "barks at", y@name))

setMethod("interact", c("Fox", "Dog"),
  function(x, y) paste(x@name, "dodges", y@name))

setMethod("interact", c("Person", "Person"),
  function(x, y) paste(x@name, "says hello to", y@name))

## Fallback interaction for any two animals
setMethod("interact", c("Animal", "Animal"),
  function(x, y) paste(x@name, "and", y@name, "acknowledge each other"))
