Docker/Podman
=============

Ten years ago if you joined a software company one of the first things
you'd likely do was set up a "development environment." Writing software
typically involves multiple programming languages with different versions, support
software, databases, etc. All that stuff is brittle in its configuration: your app
might not work if you try to run it on Postgres 14.2 instead of 14.1 or 14.3. 
It wasn't unusual for the deep magic required to set up a development environment
to be stored in one linchpin person and it could take days or weeks to get started
in some places. 

Similar issues occur with data science environments. Then there is the issue of
deploying software. These environments can be even more challenging to maintain
and eventually we started to go nuts.

:genimg:a software engineer going crazy::


We used to use virtual machines to solve this problem: an entire operating system could be
set up (maybe even by hand) inside a VM and then you could clone that for other users
and, with a little fiddling, get a reasonable development environment. At my last
real job the dev environment consisted of three huge VMs and our company laptops
were the size of cars so we could all run the dev environment.

Enter Containerization
======================

The pedants among us will sometimes make us distinguish between linux and 
the GNU software suite, which together constitute the GNU/Linux operating system.

Linux, strictly speaking, is the _kernel_ of the operating system, which mediates
between the hardware and the user. But an OS consists, perhaps even mostly, of 
a bunch of programs.

```bash 
ls /usr/bin | head -n 20
```

```sidebar
"bin" in /usr/bin refers to "binary" files, of which executables are a very common type. Really a binary file is just any file which requires special software to interpret. 
```

There is a magic command we can use in linux: chroot (change root). Chroot
makes all future executables think that the "root" of the operating system is some other
directory. 

If you put all the _files_ that make up an operating system in a directory and then
chroot to that directory, then programs running in the "chroot"ed environment 
_sort of_ think they are running in another OS. There are many details to think
about: when you are using a linux OS you are usually running as a specific user
with limited permissions, controlled by the operating system by user and group
permissions. When you chroot, you don't change user, so Docker/Podman do a few
other fancy tricks to make it all work, but the idea here is that a container
provides many of the benefits of a VM but really doesn't take up any more memory
or processing power than a regular process.

```sidebar
process: whenever we execute code on an operating system it becomes a "process",
which is just a bundle of information that the OS uses to keep track of how it's
going. Processes have numbers and you can list them, kill them, stop them, restart them
etc. 

When we press CTRL-C, for example, we send the currently running process a "signal"
that tells it to interrupt itself, usually causing it to die.
```


Automation
----------

A huge benefit of using shells is that processes can be automated. A "shell script"
is just a text file with some shell code in it that we can run as if we typed
it all in. If you were lucky your company would have a script to set up a dev
environment, but even that could be a real headache if some part of it broke - you'd have to
reinstall the whole machine, sometimes.

Docker's big innovation was encapsulating all that into a Dockerfile format:

```Dockerfile 
FROM rocker/verse:latest

# System dependencies for GIS and R spatial packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        libudunits2-dev \
        libgdal-dev \
        libgeos-dev \
        libproj-dev \
        libsqlite3-dev \
        gdal-bin \
        proj-bin \
        && rm -rf /var/lib/apt/lists/*

# Install R spatial libraries
RUN R -e "install.packages(c( \
      'sf', \
      'terra', \
      'raster', \
      'sp', \
      'rgdal', \
      'maptools', \
      'tmap', \
      'leaflet' \
    ), repos='https://cloud.r-project.org/')"

```

The idea here is that as you work on your project you keep your Dockerfile updated with all the software configuration
you need for the project. That way you can just build the container and get started anywhere. 
I like to say that if you are using ::git:git:: and Docker, you won't care if your laptop is run over by a truck - clone the repo, build the image, keep going.
