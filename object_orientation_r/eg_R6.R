# R6 rewrite: Animal hierarchy with make_sound and double-dispatch interact

library(R6)

Animal <- R6Class("Animal",
  public = list(
    name = NULL,
    initialize = function(name) { self$name <- name },
    make_sound = function() "Some generic animal noise",
    # Double dispatch: delegate to 'other' based on self's class
    interact = function(other) other$interact_with_animal(self),

    # Handlers when 'other' initiates with specific types
    interact_with_animal = function(other) paste(self$name, "and", other$name, "acknowledge each other"),
    interact_with_dog    = function(other) paste(self$name, "and", other$name, "acknowledge each other"),
    interact_with_cat    = function(other) paste(self$name, "and", other$name, "acknowledge each other"),
    interact_with_fox    = function(other) paste(self$name, "and", other$name, "acknowledge each other"),
    interact_with_person = function(other) paste(self$name, "and", other$name, "acknowledge each other")
  )
)

Dog <- R6Class("Dog",
  inherit = Animal,
  public = list(
    make_sound = function() "Woof!",
    interact = function(other) other$interact_with_dog(self),
    # Dog-others specifics
    interact_with_cat = function(cat)  paste(self$name, "chases",   cat$name),
    interact_with_fox = function(fox)  paste(self$name, "barks at", fox$name)
  )
)

Cat <- R6Class("Cat",
  inherit = Animal,
  public = list(
    make_sound = function() "Meow!",
    interact = function(other) other$interact_with_cat(self),
    # Cat-others specifics
    interact_with_dog = function(dog) paste(self$name, "hisses at", dog$name)
  )
)

Fox <- R6Class("Fox",
  inherit = Animal,
  public = list(
    make_sound = function() "Yip!",
    interact = function(other) other$interact_with_fox(self),
    # Fox-others specifics
    interact_with_dog = function(dog) paste(self$name, "dodges", dog$name)
  )
)

# Breeds
BorderCollie <- R6Class("BorderCollie",
  inherit = Dog,
  public = list(
    make_sound = function() "Ruff!"
  )
)
Labrador    <- R6Class("Labrador",    inherit = Dog)
IrishSetter <- R6Class("IrishSetter", inherit = Dog)

# Person is also an Animal
Person <- R6Class("Person",
  inherit = Animal,
  public = list(
    make_sound = function() self$name,
    interact = function(other) other$interact_with_person(self),
    # Person-others specifics
    interact_with_person = function(p2) paste(self$name, "says hello to", p2$name),
    interact_with_dog    = function(dog) paste(self$name, "plays fetch with", dog$name)
  )
)
