:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

# Shell Concepts

## Many Shells

Unix supports *many* different shells which behave similarly. Throughout
this course I will be assuming
[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) because it is
the most common. I'll be trying to write bash code which will run in
most other shells (most notably zsh, which is recently the default OSX
shell) for simplicity. But if you run into an issue, make sure you are
running bash by simply typing:


how to start bash


```bash 
bash
```
Note that if we press CTRL-D we exit the shell. A lot of shells, not just unix ones,
have an exit command or function, but on the unix shell you will often see me
exit an interactive shell by pressing CTRL-D. This is sort of interesting:
CTRL-D sends an "EOF" (end of file) character. Since unix shells treat their 
input and output as files, sending an EOF tells the process "the input is over
so its time to quit."

You will see me kill non-interactive processes with a CTRL-C, which seems similar
but is quite different: this sends a SIGINT, which most processes interpret 
as a "time to die."

Processes launched from a shell can be in the foreground, stopped, or in the 
background but going. 

If we run
```bash 
sleep 100 # sleep for 100 seconds
```

We can kill it with CTRL-C (send a sigint), stop it with a CTRL-Z (SIGSTP)
and then tell it to keep going in the background with a `bg`. We can bring it
back into the foreground with an `fg`. Both require the _job number_.

Processes also have process ids, which we can list with `ps` (docker/podman have
a ps subcommand which list running containers). Give a process id we can kill it
with `kill`.

Next, we’ll look at data types and the REPL: ::data_types_and_repl:Types of Data and the REPL::
