:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

## Conventions to bear in mind

```bash 
OLD_DIR=$(pwd)
cd /tmp # the temporary directory on a Linux machine.
touch test # touch just creates an empty file or updates a file's modification time.
cd $OLD_DIR
```


Also interesting: `pushd` and `popd`.

### find

`find` lets us search for files in a variety of ways. A simple example:


Finding all R files beneath the pwd.


```bash 
find . -iname "*.png"
```


```org 
./4.png
./z.png
```

`find` is very powerful and also a little weird in places. But it is so
useful that having a basic working knowledge of the command will be very
much worth it.

### grep

`grep` lets you search for things *in* files:


Using grep.


```bash 
grep -n hello unix.*
```


```org 
unix.html:776:<label class="org-src-name"><span class="listing-number">Listing 6: </span>my-commands/hello.sh</label><pre class="src src-bash"><span style="color: #7f7f7f;">#</span><span style="color: #7f7f7f;">!/bin/</span><span style="color: #1c86ee;">bash</span>
unix.html:778:<span style="color: #cd6600;">echo</span> hello world
unix.html:785:"hello.sh" permission to act as an executable:
unix.html:789:<pre class="src src-bash">chmod u+x my-commands/hello.sh
unix.html:799:hello.sh
unix.html:808:hello world
unix.org:344:#+CAPTION: my-commands/hello.sh
unix.org:348:echo hello world
unix.org:353:"hello.sh" permission to act as an executable:
unix.org:356:chmod u+x my-commands/hello.sh
unix.org:368:hello.sh
unix.org:373:hello world
unix.org:643:grep hello 
```

Given a string and a list of files as arguments, grep prints out the
file and line number (with the right command line switch `-n`) where the
string occurs.

### xargs

`xargs` deals its inputs to a command. The use case is when we want the
output of one command to go to the command line of a second command, as
opposed to going to the standard input of the second command.

If that isn't super clear, don't worry about it. I introduce `xargs`
here because I want to show one very useful use case:

Suppose I want to find everywhere a particular function is mentioned in
all the R files in a project. Then I say:


Using find with grep.


```bash 
find . -iname "*.R" | xargs grep read_csv
```


If we were to pipe the first term directly to `grep` we would just
search the filenames for the function `read_csv`. We don't want that -
we want to search `each` file with grep. Using `xargs` in this way
allows us to first find a set of files and then search for them.

Next, we’ll manage foreground and background processes: ::foreground_background_processes:Foreground and Background Processes::
