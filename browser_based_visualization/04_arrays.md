Arrays
======

In R we are used to dealing with homogeneous arrays and data frames and lists. Arrays in JS are heterogenous (you can 
actually reach for *homogenous arrays* but its not common). 

A fusion of "object oriented" and "functional" programming is the standard thing in Javascript.

``` js demo
let x = [1,2,3,4,5]
console.log(x.map(x => x + 1))
console.log(x)
console.log(x.reduce((accumulator, iterant) => accumulator + iterant))
```
And note that the semantics of `.` allow us to chain them together almost like a `%>%`:

``` js demo
console.log([1,2,3,4,5]
 .map(x => x + 1)
 .reduce((ac, it) => ac + it))
```
You will see this sort of thing all over the place. We almost have enough juice here to start writing
a visualization. We just need to think a bit about the ::05_document:document:: itself first. 