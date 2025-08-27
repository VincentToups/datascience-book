Docker File
===========

We almost have a complete project here. We have source data, a few scripts,
a cartoon report, and a Makefile that ties it all together.

All we need to do now is make sure it all works by providing an environment
where the code can run. 

We can do that via a Dockerfile.

Here is one now!:

:student-select:invent a question; ../students.json::

```Dockerfile file=/fs/book/bios611/my-project/Dockerfile
# Start from rocker/verse (includes R, tidyverse, knitr, etc.)
FROM rocker/verse:latest

# Ensure root
USER root

# Install TeX Live, Pandoc, and extra LaTeX packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-xetex \
    texlive-luatex \
    lmodern \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install/upgrade R packages for rendering
RUN Rscript -e "install.packages(c('rmarkdown'), repos='https://cloud.r-project.org')"

# Default workdir
WORKDIR /project


```
And I find it useful to have a start script that looks like this:

```sidebar
Note this business with GID and UID. rocker/verse lets us tell it at run time
to make sure that the /home/rstudio/ directory belongs to someone who matches
your user id and group id. 

If you start your container and can't write files, you should try this. It can't hurt, actually,
so maybe it should be part of the standard instructions.
```
```bash file=/fs/book/bios611/my-project/start.sh
docker build . -t my-project
docker run --rm \
  -e USERID="$(id -u)" -e GROUPID="$(id -g)" \
  -p 8787:8787 \
  -v $(pwd):/home/rstudio/work \
  my-project

```
We need to update our README to something like this:

```markdown 
Voltage Trace Analysis
======================

This repo contains an analysis of some simulated voltage traces.

If you have Docker installed you can run this in Linux like this:

bash start.sh

This will build and launch the Docker container. Then you can visit
localhost:8787 and go to the terminal of the RStudio instance and run
`make clean` and `make report.pdf` to produce the final report.



```
Let's talk about ::homework:homework::!
