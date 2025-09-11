:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

## The PATH and other environment variables

When a string is evaluated the shell must find what command we want to
run. How does it do so?

Some background: apart from a few built in commands (the so-called
[builtins](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html))
commands in shell scripts are just executable files stored somewhere on
the hard drive. The command `which` tells us where such commands qua
files are located:

```bash 
which which
```

```bash 
/usr/bin/which
```

A good piece of jargon to have in your head here is that `which`
"resolves" to `/usr/bin/which`.

If you haven't seen unix style file locations, note:

1.  on a unix system *every file* lives beneath the so-called "root" of
    the file system, called `/`.
2.  anything between two `/` (called *path separators*) is a /directory.
3.  the last term may be a directory or a file. In this case, it is the
    executable file which implements the `which` commands.

`which` resolves in the same way that Bash resolves, but how does that
work?

They look in something called an environment variable called PATH. You
can see what an environment variable holds like this:

```bash capture
echo $PATH
```


To understand this behavior we need to add a new rule to our mental
"evaluation engine":

> When we see a $ followed immediately by a name we look up the value of
> the variable named and insert it into the string. This happens before
> the other rules are executed.

Apparently, `PATH` contains a series of locations on the filesystem
separated by ":" characters. Bash searches this list in order to find
executables during command evaluation.

So in the case of `which` it looks in

1.  `/home/toups/.local/bin` (no hit)
2.  `/usr/local/local/sbin` (no hit)
3.  `/usr/bin` (hit!)

By modifying this environment variable we can modify the way bash looks
up commands. But how would we create our own command to test out this
ability?

Let's create a directory

And then let's create a directory:

```bash capture
mkdir -p my-commands
readlink -f my-commands
```


(your file will obviously be somewhere else on your personal computer).

And now let's create the file


my-commands/hello.sh


```bash file=my-commands/hello.sh
#!/bin/bash

echo hello world

```


First we need to tell our Unix that we want to give the file "hello.sh"
permission to act as an executable:

```bash 
chmod u+x my-commands/hello.sh
```

And then we can

```bash 
PATH="$(readlink -f my-commands):$PATH"
hello.sh
```

```bash 
hello world
```

```txt file=rules.txt
1. after read, split by space
2. if a token looks like $NAME, then look in the env for NAME and replace the
   $NAME with whatever NAME is associated with.
3. see if the first token looks like NAME=VAL and if so we add an env
   (or export NAME=VAL)
4. tries to find a command associated with the first token 
   by looking in the path.

```


In order to understand this result we need to add another rule:

> If we see a name followed immediately by an equal sign and then a value,
> modify or create a new environment variable of that name with the
> specified value. No regular evaluation occurs but environment
> variables themselves are expanded before setting the value.

If some of the above steps are a little confusing to you, that is ok -
we're not going for a full understanding of working on the command line:
we want just enough to get around.

We will develop more as we go.

The PATH isn't the only environment variable. What variables are defined
will vary a lot by system and situation, but you can see a list of all
of them by saying:


the environment


```bash 
env | head
```


```org 
SHELL=/bin/bash
SESSION_MANAGER=local/cscc-laptop:@/tmp/.ICE-unix/2031,unix/cscc-laptop:/tmp/.ICE-unix/2031
QT_ACCESSIBILITY=1
SNAP_REVISION=1161
XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu-wayland:/etc/xdg
XDG_SESSION_PATH=/org/freedesktop/DisplayManager/Session0
XDG_MENU_PREFIX=gnome-
GNOME_DESKTOP_SESSION_ID=this-is-deprecated
SNAP_REAL_HOME=/home/toups
SNAP_USER_COMMON=/home/toups/snap/emacs/common
```

Next, we’ll introduce variables and substitution: ::variables_and_substitution:Variables and Substitution::
