:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

## stdin, stdout, stderr and pipes

We have one more important element of the shell to learn. Recall that
shell commands communicate by reading input from somewhere and writing
it out to a new location. Most often the place they read from is the
"standard input" (abbreviated stdin). And the most common place they
output things is the "standard output". If there is an error of some
kind most processes report this on another file called the "standard
error."

In the above example, when we used the command `head` we passed a
filename in as a command line argument and the result was printed to the
standard output.

We can also redirect the standard output to a file:


Redirecting the standard output.


```bash 
ls -t > files-in-order
head files-in-order -n 3
rm files-in-order
```


```org 
files-in-order
unix.org
unix.html
```

The syntax `<COMMAND> > file` sends the standard output to `file`.

But often creating a temporary file is a hassle if we just want to apply
many commands in sequence. Thus we can also "pipe" one command's output
to another's input. In that case the second command reads from the
output of the previous *instead* of from the stdin file.


Piping output into input.


```bash 
ls -t | head -n 3
```


```org 
unix.org
unix.html
my-commands
```

The `|` (called a "pipe") means: take the output from the first item and
send it to the second. We can pipe many times in a row.


A chain of pipes.


```bash 
ls -t | head -n 3 | grep y
```


```org 
my-commands
```
```txt file=rules.txt
1. after read, split by space
2. if a token looks like $NAME, then look in the env for NAME and replace the
   $NAME with whatever NAME is associated with.
3. if an expression like $(...) is found, evaluate ... with these rules 
and put the output into the command.
4. see if the first token looks like NAME=VAL and if so we add an env
   (or export NAME=VAL)
5. if our expression contains | or > then look at the pieces of the expression
   (broken on the pipes or before the redirects).
   For pipes start the first commend, connect stdout the next, etc. 
   for redirects send the stdout to the file
5. tries to find a command associated with the first token 
   by looking in the path.

```

The output of `ls` goes to `head` and the output of `head` goes to
`grep`. Some bash scripts are little more than a long series of pipes.
Learning to program this way is very enlightening and we'll see a
similar "chain of operations" approach in R and Python.

Next, we’ll navigate directories and search with core tools: ::navigation_and_search:Navigation and Search::
