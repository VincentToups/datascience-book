:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

## Variables

You can declare your own variables or modify those that already exist
(assuming they aren't read only).

The easiest way to declare a variable is:


declaring a variable


```bash 
VARNAME=somevalue
echo $VARNAME
```


Note that when we declare a variable we do *not* precede the name with a
`$`. The dollar sign is what tells Bash to look the variable value up
when we want to *use* it somewhere.

With variable definition and usage rules in our head, we can now extend
our mental model of bash evaluation.

1.  for every line in a script
    1.  perform variable substitution (wherever we see a $NAME look up

    the value and insert it into the line)
    1.  if the line is a command, do command evaluation otherwise do
        variable assignment

The only really important remaining ingredient is non-variable
substitution.

Consider again the following line from the above example:


Substitution


```bash 
PATH="$(readlink -f my-commands):$PATH"
```
```txt file=rules.txt
1. after read, split by space
2. if a token looks like $NAME, then look in the env for NAME and replace the
   $NAME with whatever NAME is associated with.
3. if an expression like $(...) is found, evaluate ... with these rules 
and put the output into the command.
4. see if the first token looks like NAME=VAL and if so we add an env
   (or export NAME=VAL)
5. tries to find a command associated with the first token 
   by looking in the path.

```

Ordinarily no *evaluation* occurs on the right hand side of an
assignment. The material there is just treated as a string (or a number,
if it happens to be a number). But by using a `$(...)` construct we can
perform a substitution: the interior of the `$(...)` is evaluated like a
command and the result is inserted into the line where it appears.

We can use this to compose together multiple commands. Consider that
`ls -t | head -n 1` will return the most recently modified file. `head
<filename>` will print out the first few lines of a file. If we want to
print the first few lines of the most recently modified file:


combining commands with substitution


```bash capture
head $(ls -t | head -n 1)
```


```org 
* Why Learn Unix

Unix, generally in the form of Linux, but also commonly encountered as
the underlying idiom of OSX and other important systems, powers the
world.

#+tblname: servers
| Source  | Month | Year | Unix | Windows |
|---------+-------+------+------+---------|
| W3Techs | May   | 2021 | 75.3 |    24.8 |
```

(The most recently modified file is this document!).

Next, we’ll cover standard I/O and pipes: ::io_and_pipes:Standard I/O and Pipes::
