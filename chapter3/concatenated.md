Project Organization
====================

In the last chapter we created a little data analysis of some voltage
traces from some simulated neurons.

Roughly, 

We loaded the data (and did some tidying we didn't really talk about), performed
PCA on the traces, plotted them in 2D, noticed clusters, automatically clustered
the data, plotted the average traces, and then we flipped the problem around
and tried to see what points in time best split one of the clusters by doing
a logistic regression.

These were split into a variety of files, but not in a formal way. So let's
create a more formal, if small, project.

But first let's lay out a few concepts and definitions.

1. **script**: a text file which, when "run" by a programming language's interpreter
   produces output and/or results, which we call artefacts.
2. **artefact**: a static thing that "is" rather than "does something." Obvious
   artefacts are image files (png, svg, pdf), documents (text, markdown, pdf), data-
   sets like csv files, SAS binary files, R binary files, Python pickles, etc. Less
   obvious artefacts are things we provide directly but are not created by scripts:
   scripts themselves are artefacts, raw data is an artefact, the source code for
   documents is an artefact.
3. **binary file**: a binary file is one which we need some external program to 
   interpret. Example binary files are executables (usually), Word documents,
   SAS binary files, RDS files, zip files, pickles, pngs. Note that it's almost 
   always the case that if we have a binary file it's an artefact, not source code.
4. **text file**: sometimes called "plain text" files to distinguish them from 
   binary files which represent text like Word documents. Plain text files just
   contain bytes (usually with an implicit or explicit *encoding* which determines
   which bytes constitute which characters). We don't need special programs to
   examine and edit text files. All the utilities on the Unix shell work with text
   files by default and we use something called a text editor to edit them. Back when
   ::ascii:ascii:: was the mostly standard way to denote text this distinction was more
   clear.
5. **text editor**: a special program dedicated to editing and manipulating plain 
   text files. Since scripts are always plain text files and most of the work of 
   doing data science is writing scripts, we need to use text editors to do the work.
   RStudio's editor is a plain text editor, but there is a long and varied tradition
   of text editing which includes programs like Emacs and Vim and modern "integrated
   development environments" like Visual Studio.

With this vocabulary we can describe our project with ::accuracy:more accuracy::.

:student-select:invent a question; ../students.json::

A Data Science Project Consists Of
==================================

Plain text scripts are run by binary executables. They load binary or plain text
data from the disk, and they create binary or plain text artefacts that are
written to the disk. 

Scripts are thus the fundamental actors in a data science project.

The benefits of organizing our thoughts like this might be obvious: if we want to
understand where an artefact came from, we need only look at the script that 
produced it. Ideally, we create small, distinct scripts that perform one or
two tasks only and produce one or two artefacts. 

Another benefit is that artefacts, once produced, are independent of any script 
or programming language. 

A key idea here is that we should organize our project in a way that *reduces
cognitive load*.

Just thinking in these terms already reduces our brain load substantially. The
rest of our lecture today will involve improvements on this basic idea.

Let's work on ::preliminaries:preliminaries::.

```sidebar
cf. the Jupyter Notebook style of data science. In that world, _cells_ in the
notebook might read data from the disk or from a URL, and each cell might
perform a computation, the result of which is stored in memory as some
variable. 

The reason we don't like this is that it's conceptually fairly dirty: our code
is just a set of cells (which have only order to relate them), and our artefacts
are mixed in memory with all the other intermediate variables and values
we used to produce them.

```

A Git Repo
==========

Setting up a git repository is easy but involves a few complicated steps
if you've never done it before.

First we decide where we want to set it up.

```sidebar
master vs main
--------------

Historically the main branch of a git repository was called "master" but
this language is needlessly hierarchical. Thus the trend has been to use
"main" instead. Will this fix all the social problems in the world? No, but
it's harmless in and of itself and I do it. 

```

Note the following concepts:

:student-select:invent a question; ../students.json::

1. users: on modern computers access is controlled primarily via users. Ultimately
a user is just a number associated with a name and some permissions. Users all 
have a home directory. In unix-like operating systems the user's home directory
is usually `/home/<username>/` and you can always "get" there by using `cd` (change directory)
like this: `cd ~` (the tilde is expanded to the home directory).
Note that the "root" user is a special user who has freedom to do anything. The
root user's home directory is `/root`. 
2. directories: a directory is just a "place" on your computer where you can put files
and directories. We can create a directory by saying `mkdir <directory name>`.
Note that files and directories have access modifiers set on them which 
determine who is allowed to read, write, and execute (for files) those files. We
will need to think carefully about this from time to time (see sidebar).
3. working directory: every process (thing that does something) has a "working directory" relative to which
all filenames are resolved unless you specify a full path.

```sidebar
Docker & Podman and Permissions
-------------------------------
> true hell 

Docker runs containers _as_ the root user. Thus with Docker we often set up
our user _in the container_ to match our user id _outside_ the container so that
we can access files we mount in the container, in which we run as a non-root
container user.

In _podman_ we run containers _as_ our host user. So _inside_ the container it's
convenient to run as the container's _root_ user (who has our user id). This allows
us to access host files without fiddling with permissions. 

Usually "running as root" is a _bad idea_ since you can cause major trouble accidentally but
in a container running as an unprivileged user, we can run as root safely, since
at most we could mess up our container, which is disposable anyway.

But when we run our container via Docker, the docker process itself is (speaking morally)
run by the root user, so we want to at least run as a non-root user in the container.

Confusing, right?
```

Here is one major way we can simplify our lives when doing data science:
always assume when writing code that the working directory is the main project 
directory. If we follow this rule we never need to "cd" or otherwise set our
working directory in our code.

:student-select:invent a question; ../students.json::

Anyway, let's create a repository.

```bash 
# this is just to make this idempotent
rm -rf ~/my-project

cd ~
mkdir my-project
cd my-project 

# note we could say mkdir -p ~/my-project

git init
git branch -m main 


```



Note that our _git repository_ is totally distinct from _GitHub_, which is just
a service. We've created a git repo here and at present it's empty.

```bash pwd=/bios611/my-project/
git status
```
Great. We have a new, fresh, git repository in our project directory.

Before it's worth syncing it up with GitHub we need to actually put something in 
it.

The natural first thing is a ::a_readme:"README.md"::.

A readme is just a file which by convention everyone will look at 
when they load your repo. In fact, GitHub will render your readme
to HTML and show it on the home page of your repo, so it's important.

Let's create a README.

It will look like this:

```markdown 
Voltage Trace Demo
==================

This is a repository that analyses simulated voltage traces for the purposes
of demonstrating data science methods and tools.


```
Now we can make our first commit.
```bash pwd=/bios611/my-project/
git add README.md
git commit -m "Added README. Initial commit."

```
Now we can actually push to our git repo. Let's create one. We do that by going to GitHub, creating a new repo, and then
following the instructions for pushing a new repo.

:student-select:invent a question; ../students.json::

But first a few notes about ::ssh_keys:ssh, ssh keys, git remotes, etc.::

Secure Shell
============

"ssh" stands for secure shell. We've talked about _terminals_ aplenty, or
at least seen a few. A problem we might need to solve is how to securely
connect two computers over the internet so that you can execute commands 
on one of them from somewhere else.

Secure shell handles this problem. The server machine runs a server, and the
client connects to it (`ssh <some-server>`) and then an authentication happens
and the two computers can exchange data or you can run commands on the remote
machine.

Git supports using ssh as a transport protocol for git data. To use that feature
with GitHub, which is the recommended way, we need to have an ssh key pair. 
This is a cryptographic thingy with the following basic properties: 

1. it's two numbers
2. if I have the private number and you have the public number you can verify
that I have the private number even though you can't see the private number.

We generate one with ssh-keygen.

:student-select:Suppose we wanted to know what the ssh-keygen command does? How would we figure that out?; ../students.json::
```bash 
cd ~/.ssh/
ssh-keygen

```
Note that we now have two files, the public and the private one. 

We can share the public one with whomever we want! The private one we must never
share and never put in our git repo. Anyone who has the private key can pretend
to be us.

:student-select:invent a question; ../students.json::

We visit GitHub, go to our settings, add our public key, and then we can follow
the rest of the instructions, which are like this:

``` 
ssh-agent bash
ssh-add ~/.ssh/id_rsa 
git add remote origin <git ssh style url>
git push -u origin main
```
Now we can get to work on our actual data science.

Starting with our ::data:data::. 

Provenance of Data
==================

Almost all projects start with some raw data. I usually call this "source_data"
because it is just assumed to exist, we don't create it in the project itself.

My practice is always to put source_data in a specific spot:

```bash pwd=/bios611/my-project
mkdir -p source_data
```
For simplicity today we are going to just treat our source data as given and 
manage it in the repository.

:student-select:invent a question; ../students.json::

Now we can build our first script. Recall what our example code looked like:

```r file=../chapter2/plot_voltages.R
library(tidyverse)

voltages <- read_csv("voltages_wide.csv")

voltages_long <- voltages %>%
  select(-label,index) %>%
  pivot_longer(
    cols = `0`:`250`,
    names_to = "time",
    values_to = "voltage"
  ) %>%
  mutate(time = as.numeric(time)) %>%
  filter(complete.cases(.))


p <- ggplot(voltages_long, aes(x = time, y = voltage, group = index)) +
  geom_line(alpha = 0.5) +
  labs(x = "Time", y = "Voltage", title = "Voltage Time Series") +
  theme_minimal()

write_csv(voltages_long,"voltages_long.csv")

ggmd(p)

```
```sidebar
If our data set is too big to fit in git we can create a task that creates it
in our makefile

<pre>
source_data/raw_data.csv:
    mkdir -p source_data
    wget <someplace> -o source_data/raw_data.csv
</pre>
```

Many people begin their work by using a markdown file or a python notebook
or whatever. So we often find ourselves translating our file into
a distinct task. That process always goes like this:

Given a code snippet identify the inputs and outputs and make a note of them.
Outputs might not be obvious. If we were just looking at a figure then we 
need to think of that as an output and write it to disk. We could modify/annotate
our code like this:

```R file=/fs/bios611/my-project/plot_voltages.R
library(tidyverse)

# this is an input, so we point it at where we put our data officially
voltages <- read_csv("source_data/voltages_wide.csv")

voltages_long <- voltages %>%
  select(-label,index) %>%
  pivot_longer(
    cols = `0`:`250`,
    names_to = "time",
    values_to = "voltage"
  ) %>%
  mutate(time = as.numeric(time)) %>%
  filter(complete.cases(.))


p <- ggplot(voltages_long, aes(x = time, y = voltage, group = index)) +
  geom_line(alpha = 0.5) +
  labs(x = "Time", y = "Voltage", title = "Voltage Time Series") +
  theme_minimal()

# this is an output. Let's put it someplace nice.
ensure_directory <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  invisible(TRUE)
}

ensure_directory("derived_data")
write_csv(voltages_long,"derived_data/voltages_long.csv")

ensure_directory("figures")

ggsave("figures/voltages.png")
```
Once we have modified our function we can actually create an entry for it in our
makefile. Don't worry about the details here, just get the vibe:

:student-select:invent a question; ../students.json::

```makefile 
# recall 
# <artefacts>: <requirements>
#   recipe

derived_data/voltages_long.csv figures/voltages.png: plot_voltages.R source_data/voltages_wide.csv
    Rscript plot_voltages.R
```

Make Clean, Make Good
---------------------

This is a good time to introduce the idea of a clean task. Remember:

*Everything we build with source code is transient like the wind. We trust
code, not the results.*

So it's good to have a pseudo-task in our Makefile that deletes all our artefacts
so we can rapidly test rebuilding things.

```Makefile 
.PHONY: clean

clean:
    rm -rf derived_data
    rm -rf figures


derived_data/voltages_long.csv figures/voltages.png: plot_voltages.R source_data/voltages_wide.csv
    Rscript plot_voltages.R

```
Let's do ::one_more:one more::. 

Another example:
================

Recall

```R file=../chapter2/pca.R
# pca_summary.R
# Load voltages_wide.csv, run PCA on time columns, plot cumulative variance vs PCs
# and scatter of PC1 vs PC2.

library(tidyverse)

# Load data
df <- read_csv("voltages_wide.csv", show_col_types = FALSE)

# Identify and order time columns numerically in (0, 250]
time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "label", "index")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  keep(~ {
    v <- as.numeric(.x)
    v > 0 && v <= 250
  }) |>
  (\(x) x[order(as.numeric(x))])()

# Matrix for PCA
X <- df |>
  select(all_of(time_cols)) |>
  drop_na() |>
  as.matrix()

# PCA
pca <- prcomp(X, center = TRUE, scale. = TRUE)

# Variance explained
ve <- (pca$sdev^2) / sum(pca$sdev^2)
ve_tbl <- tibble(
  PC = seq_along(ve),
  cum_var = cumsum(ve)
)

# Plot 1: cumulative variance explained
p_var <- ggplot(ve_tbl, aes(x = PC, y = cum_var)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +
  labs(
    title = "Cumulative Variance Explained",
    x = "Number of Principal Components",
    y = "Cumulative Variance"
  ) +
  theme_minimal()

ggmd(p_var)

# Plot 2: scatter of first two PCs
scores <- as_tibble(pca$x[, 1:2], .name_repair = "minimal") |>
  rename(PC1 = 1, PC2 = 2)

ve1 <- scales::percent(ve[1])
ve2 <- scales::percent(ve[2])

p_scatter <- ggplot(scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "PCA Scores Scatterplot",
    x = paste0("PC1 (", ve1, ")"),
    y = paste0("PC2 (", ve2, ")")
  ) +
  theme_minimal()

ggmd(p_scatter)

write_csv(scores, "projection.csv");

```

:student-select:invent a question; ../students.json::

:student-select:Help me find the inputs and outputs and make them fit our project?; ../students.json::
If we have time we'll do one more. Otherwise let's talk about the ::final_step:final step::.

Reporting
=========

Most of the time we are trying to produce a report. Lots of folks use 
Microsoft Word to author papers (I've heard). There are good reasons to do
this I guess, not the least of which is that people have collaborators who
might not be technical.

But there is a good argument to be made for using some kind of authoring
system that converts a plain text document to a pdf or final file.

We will be using RMarkdown for this, but there are a variety of tools we could
use.

Here is an example:

```markdown file=/fs/bios611/my-project/report.Rmd

This is a report. Here is a figure:

![](figures/voltages.png)

```
If we now look at our full Makefile:

:student-select:invent a question; ../students.json::

```makefile file=/fs/bios611/my-project/Makefile
.PHONY: clean

clean:
    rm -rf derived_data
    rm -rf figures

derived_data/voltages_long.csv figures/voltages.png: plot_voltages.R source_data/voltages_wide.csv
	Rscript plot_voltages.R


report.pdf: report.Rmd figures/voltages.png
	Rscript --vanilla -e "rmarkdown::render('report.Rmd', output_file = 'report.pdf', output_format = 'pdf_document')"

```
All that is left is for us to create a ::docker_file:docker file:: for our project. 

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
