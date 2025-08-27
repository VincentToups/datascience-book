:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

## Evaluation

A theme of this course is that *all programming languages* do more or
less the same thing: they translate text into actions. If you develop a
good mental model of that process then you *understand* the language.

Given the ubiquity of Bash, its evaluation model is surprisingly
complicated. Luckily for us, we will be concerned with its simplest
aspects.

Superficially and in the simplest case, bash does the following when you
type a command:

1.  the text is split into tokens on the spaces
2.  the first token is assumed to be a command you want to execute. Bash
    tries to find a file which implements this command by looking it up
    on the "PATH" (of which more later).
3.  the subsequent tokens are passed to the command as "arguments".
    Arguments are additional pieces of information the command may want
    or need to change the way it executes.

So when we typed "ls" above, bash read this as us wanting to run the
command "ls" which it found on our hard drive. Then it saw that we
passed no arguments to the command, so it executed it without any.

### Eg 1

```bash capture
ls -t -l
```


In the above example, the shell reads "ls -t -l", splits it apart on the
spaces like this: `[ls, -t, -l]` finds the `ls` command, and passes the
`-t` and `-l` arguments to it. Note that these arguments are just passed
as strings to the `ls` command. It is up to `ls` to decide what, if
anything, they mean. In this case, they mean "sort the file list by
modification time" (`-t`) and "print out more information about the
files" (`-l`)

### Eg 2

```bash 
something_silly a b c
```

The above will generate an error like this:

    bash: line 1: something_silly: command not found

How does the shell know what command we want to run?

Next, we’ll explore PATH and environment variables: ::path_and_environment:PATH and Environment Variables::
