Javascript Objects
==================

Javascript is object oriented (as are most languages out there) and it has the decency to have but a 
single object system, although it is somewhat incondite.

The main thing to understand is the "dot" operator.

``` js demo
let subjects = [
    {name:"Ted", weight:185, height:1.7},
    {name:"Leo", weight:170, height:1.8}
]

console.log(subjects[0].name)
```


"Dot" seems innocuous at first: it just looks "inside" whatever is on the left hand
side and pulls it out. It has special behavior, however. if what is on the left hand side 
contains a function at that location:

``` js demo
let ted =  {name:"Ted", weight:185, height:1.7}
ted.greet = function(){
    let name = this.name
    console.log("Hello, I am "+name)
}
ted.greet()
```
The main idea here is this:

If the object retrieved is a function AND we are calling the result of the dot expression with `()` THEN `this` (a special variable bound inside function bodies)
is set to the value to the left of the dot operator. Note that we can now appreciate the difference between `function` functions and
*arrow* functions: *arrow* functions do not have a `this` and it doesn't get set when an arrow function is invoked, regardless of how.

Because of this, you should really always use `arrow` functions unless you really want this `this` behavior, since its faster and more
clear. In fact, if you ask me, the absolute best way is to write functions like this:

``` js demo
const f = x = x + 1
```

Unless you really need a mutable method. This allows Javascript to run quite a bit faster: it knows that you don't need `this` AND that the binding 
cannot change. 

Note that arrow functions may have a `{}` body but then you need an explicit return:

``` js demo
const f = x => {
    if(x < 10){
        return "Less than 10"
    } else {
        return "Greater than 10"
    }
    
}
```

But we could get clever:

``` js demo
const f = x => x < 10 ? "Less than 10" : "Greater than 10"
```

As always, however, there are limits to stupidity. 

Ok, so in the olden days you had to sort of hack together inheritance by hand but now JS has a more traditional class/object syntax.

``` js demo
class Animal {
  constructor(name) { this.name = name; }
  speak() { console.log(`${this.name} makes a noise.`); }
}

class Dog extends Animal {
  constructor(name, breed) {
    super(name);
    this.breed = breed;
  }
  speak() { console.log(`${this.name} barks.`); }
}

let a = new Animal("GenericAnimal")
a.speak()
let d = new Dog('Fido')
d.speak()

```


We don't really need to worry too much about how the object system works per se to do interactive visualization, but the `dot`
syntax is so ubiquitous that we should understand what it means. This is particularly true since JS doesn't have a native
pipe operator and `.` is often so pressed into service. We will see this pattern in `d3` a lot.  Very briefly, let's discuss
::04_arrays:arrays and their methods::.

