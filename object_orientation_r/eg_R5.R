## R5 (Reference Classes): Animal hierarchy + make_sound

Animal <- setRefClass(
  "Animal",
  fields = list(name = "character"),
  methods = list(
    make_sound = function() "Some generic animal noise"
  )
)

Dog <- setRefClass(
  "Dog",
  contains = "Animal",
  methods = list(
    make_sound = function() "Woof!"
  )
)

Cat <- setRefClass(
  "Cat",
  contains = "Animal",
  methods = list(
    make_sound = function() "Meow!"
  )
)

Fox <- setRefClass(
  "Fox",
  contains = "Animal",
  methods = list(
    make_sound = function() "Yip!"
  )
)

BorderCollie <- setRefClass(
  "BorderCollie",
  contains = "Dog",
  methods = list(
    make_sound = function() "Ruff!"
  )
)

Labrador <- setRefClass("Labrador", contains = "Dog")
IrishSetter <- setRefClass("IrishSetter", contains = "Dog")

Person <- setRefClass(
  "Person",
  contains = "Animal",
  methods = list(
    make_sound = function() name
  )
)
