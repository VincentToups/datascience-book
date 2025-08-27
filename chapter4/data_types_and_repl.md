:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

## Types of Data

1.  Strings: an ordered collection of characters.
2.  Numbers (integers)
3.  arrays and associative arrays (sequences of things and name->thing maps)

On the shell things tend to pass back and forth between these types
pretty fluently. This is bad design but we have to live with it.

The most important thing to bear in mind is that when I say something is
"just a string" I mean that the computer doesn't know what to do with
it - it's just purely data.

## REPL

The shell is one example of a "read, eval, print" loop. It

1.  reads an input (typically a line of text)
2.  evaluates it (turning it into an action or side effect or value of
    some sort)
3.  and then prints the result (or nothing, if a side effect)

At its most superficial level this is how we interact with a shell:

```bash capture
ls
```


Reading is trivial - the input you type is just a list of characters.
Evaluation is where things get tricky:

Up next, we unpack how bash evaluates commands: ::evaluation_basics:Evaluation Basics::
