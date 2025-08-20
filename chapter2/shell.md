:genimg:a cool guy in a suit jacking into the matrix with a keyboard and a terminal::


It is crazy that OpenAI still lets you generate images with DALL-E. It is really
bad!

```sidebar
“Whatever you now find weird, ugly, uncomfortable and nasty about a new medium will surely become its signature. CD distortion, the jitteriness of digital video, the crap sound of 8-bit - all of these will be cherished and emulated as soon as they can be avoided. It’s the sound of failure: so much modern art is the sound of things going out of control, of a medium pushing to its limits and breaking apart. The distorted guitar sound is the sound of something too loud for the medium supposed to carry it. The blues singer with the cracked voice is the sound of an emotional cry too powerful for the throat that releases it. The excitement of grainy film, of bleached-out black and white, is the excitement of witnessing events too momentous for the medium assigned to record them.”

-Brian Eno
```

I like to perform a mental exercise from time to time. We can all easily roll
back the present to the last 10 seconds or so. Ten seconds ago felt pretty real,
right?

But if we repeat that process 122811660 times we are supposed to believe that
that moment, which is the lifetime of Aristarchus (~-310 BCE), a guy who figured out that
the universe is really big, is physically contiguous with us. 

https://en.wikipedia.org/wiki/Aristarchus_of_Samos

It seems implausible, right?




Anyway, the terminal is an interesting example of a technology which makes
this process of moving through the past really clear. 

```bash 
echo "Believe it or not this object is continuous with the telegraph."
```

Fundamentally, the shell will be the place where we tell the computer what to do.
For the most part we will consider two contexts for using the shell: our "host"
computer or the host computer where someone using our code will be. This shell
might vary considerably from computer to computer and might not even be
a "posix" style shell if you are on Windows.

The other shell will be the shell inside our Docker containers. This shell will
be more or less the same for everyone, so will be a nice baseline for us to 
build our packages from. Inside the container we will most use the shell to
run code via make, and to do miscellaneous file manipulations, test-run scripts,
that kind of thing. 

Shells can be intimidating at first - but the main idea is that the shell
exposes all the files in the operating system, your local stuff, and all the
applications that you can use, in a single, useful form so that you can 
manipulate (and, most importantly, automate) stuff.

The shell is very powerful - you can even do a bit of data science on it.

```bash file=example.sh
echo Data Set Columns:
head -n1 dogs-ranking-dataset.csv | tr ',' '\n'
echo -----------------
echo Type Counts
tail -n+2 dogs-ranking-dataset.csv | cut -d',' -f 2 | sort | uniq -c
```
```sidebar
invocation: I often refer to a snippet of shell code as an "invocation," and usually
this suggests that you don't need to think too hard about it, for now. It's magic.
```

If you know a bit of dplyr you may even see where it got the idea of "pipes" from.
"|" is called the pipe operator.

We learn the shell both because it's the native interface to linux and we need to 
use it to run and configure our ::docker:docker containers::, but also because it's not uncommon
for you to get shell access to machines with data you need and sometimes 
knowing a little shell magic can make your life better.

