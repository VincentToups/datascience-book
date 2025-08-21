
Lecture 2
=========

An overview of the tools we will use in the course.

Think of this as a high-level overview of the tools we will use in the class
so that it's not so overwhelming when we cover them in detail.

Technical Tools
---------------

These tools are:

1. the unix/linux shell
2. bash (a shell scripting language)
3. Docker/Podman Containers (little temporary computers)
4. git
5. make (a build system, it controls how your analysis runs)
6. R (a statistical programming language)
7. Python (a general purpose programming language)
8. SQL (a programming language just for querying databases)
9. Markdown, LaTeX (ways of authoring results)

Data Science Related Stuff
--------------------------

1. dimensionality reduction (how to get a look at data with our little 2d brains)
2. clustering (how to find groups in data)
3. regression and classification (if you know the groups, how do you assign a point to them)
4. visualization with ggplot (how to make good visualizations)
5. model selection

We are going to try to do all these things by constructing a project as we go.
But today we are just going to give a brief introduction to all these ideas.

Starting with the :next:shell:the unix/linux shell::.

:student-select:What is your main goal for this course (e.g., learn basics, build a project, improve job skills)?; ../students.json::
:student-select:What days/times are you generally available for group work?; ../students.json::
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


:student-select:Have you opened a terminal before? If yes, on which operating system?; ../students.json::
:student-select:What operating system do you use most (Windows/macOS/Linux/ChromeOS)?; ../students.json::
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

:student-select:Have you ever had trouble installing software because of versions or dependencies (yes/no)?; ../students.json::
:student-select:What computer setup do you use for most schoolwork (personal laptop, lab machines, shared, other)?; ../students.json::
Git
===

Version control is much, much more than just a backup of your repository.

The fundamental technology beneath version control is the patch/diff utility.

For one thing, it can give us a very detailed history of a project:

```bash 
git log -n 10 --stat | cat
```
All that can be intimidating when you first look at it, but consider this:

```text file=version1.txt
To be, or not to be, that is the question:
Whether 'tis nobler in the mind to suffer
The slings and arrows of outrageous fortune,
Or to take arms against a sea of troubles
And by opposing end them. To die—to sleep,
No more; and by a sleep to say we end
The heart-ache and the thousand natural shocks
That flesh is heir to: 'tis a consummation
Devoutly to be wish'd. To die, to sleep—
To sleep—perchance to dream: ay, there's the rub,
For in that sleep of death what dreams may come,
When we have shuffled off this mortal coil,
Must give us pause—there's the respect
That makes calamity of so long life.
For who would bear the whips and scorns of time,
Th'oppressor's wrong, the proud man's contumely,
The pangs of dispriz'd love, the law's delay,
The insolence of office, and the spurns
That patient merit of th'unworthy takes,
When he himself might his quietus make
With a bare bodkin? Who would fardels bear,
To grunt and sweat under a weary life,
But that the dread of something after death,
The undiscovere'd country, from whose bourn
No traveller returns, puzzles the will,
And makes us rather bear those ills we have,
Than fly to others that we know not of?
Thus conscience does make cowards of us all,
And thus the native hue of resolution
Is sicklied o'er with the pale cast of thought,
And enterprises of great pitch and moment
With this regard their currents turn awry
And lose the name of action.
```
```text file=version2.txt
To be, or not to be, that is the question:
Whether 'tis nobler in the heart to suffer
The slings and arrows of outrageous fortune,
Or to take up arms against a sea of troubles
And by opposing end them. To die—to sleep—
No more; and by a sleep to say we end
The heart-ache and the thousand natural shocks
That flesh is heir to: 'tis a consummation
Devoutly to be wish'd. To die, to sleep—
To sleep—perchance to dream: ay, there's the rub,
For in that sleep of death what dreams may come,
When we have shuffled off this mortal coil,
Must give us pause—there's the respect
That makes calamity of so long life.
For who would bear the whips and scorns of time,
Th'oppressor's wrong, the proud man's contumely,
The pangs of dispriz'd love, the law's delay,
The insolence of office, and the spurns
That patient merit of th'unworthy takes,
When he himself might his quietus make
With a bare bodkin? Who would fardels bear,
To grunt and sweat under a weary life,
But that the dread of something after death,
The undiscover'd country, from whose bourn
No traveller returns, puzzles the will,
And makes us rather bear those ills we have,
Than fly to others that we know not of?
Thus conscience does make cowards of us all,
And thus the native hue of resolution
Is sicklied o'er with the pale cast of thought,
And enterprises of great pith and moment
With this regard their current turn awry
And lose the name of action.

```
```bash file=showdiff.sh
diff -u version2.txt version1.txt
```
If you use git, you eventually have this level of granular understanding of what
your code has done over time. Extremely valuable for both understanding a new
codebase and maintaining an old one.

Knowing how to use your version control can be the difference between hours
or days of debugging and minutes.

Now let's talk about ::makefiles:Makefiles::.

:student-select:Have you ever saved multiple versions of a file (e.g., report_v1, report_v2)? How did you keep track?; ../students.json::
:student-select:Have you used any version control tool before (yes/no/unsure)?; ../students.json::
Makefiles
=========

Nothing beats looking at a Makefile to get a sense of why it is valuable.

```Makefile 
# Makefile
# Assumes that report.Rmd, slidedeck.Rmd, all *.R scripts, and raw_data.csv already exist.

all: report.pdf slidedeck.pdf

report.pdf: summary.csv fig1.png fig2.png
	Rscript -e "rmarkdown::render('report.Rmd', output_file='report.pdf')"

slidedeck.pdf: summary.csv fig1.png fig2.png
	Rscript -e "rmarkdown::render('slidedeck.Rmd', output_file='slidedeck.pdf')"

summary.csv: cleaned_data.csv
	Rscript summary.R

fig1.png: analysis1.csv
	Rscript fig1.R

fig2.png: analysis1.csv analysis2.csv
	Rscript fig2.R

cleaned_data.csv: raw_data.csv
	Rscript clean_data.R

analysis1.csv: cleaned_data.csv
	Rscript analysis1.R

analysis2.csv: cleaned_data.csv
	Rscript analysis2.R

clean:
	rm -f report.pdf slidedeck.pdf summary.csv cleaned_data.csv analysis1.csv analysis2.csv fig1.png fig2.png

```

```js browser
import {makefileGraph} from '/js/makefile_graph.js'

const makefileDeps = {
  "report.pdf": ["report.Rmd", "summary.csv", "fig1.png", "fig2.png"],
  "slidedeck.pdf": ["slidedeck.Rmd", "summary.csv", "fig1.png", "fig2.png"],
  "summary.csv": ["summary.R", "cleaned_data.csv"],
  "fig1.png": ["fig1.R", "analysis1.csv"],
  "fig2.png": ["fig2.R", "analysis1.csv", "analysis2.csv"],
  "cleaned_data.csv": ["clean_data.R", "raw_data.csv"],
  "analysis1.csv": ["analysis1.R", "cleaned_data.csv"],
  "analysis2.csv": ["analysis2.R", "cleaned_data.csv"],
  "raw_data.csv": [],
  "summary.R": [],
  "fig1.R": [],
  "fig2.R": [],
  "clean_data.R": [],
  "analysis1.R": [],
  "analysis2.R": [],
  "report.Rmd": [],
  "slidedeck.Rmd": []
};

makefileGraph("makefile", makefileDeps);

```
<svg id="makefile"></svg>
The idea here is that a linux utility called "make" can read our make file and automatically determine what pieces of
our project need to be rebuilt when other pieces change. By using timestamps on the files, it can automatically build
only those things which need rebuilding. Recreating our entire project is as simple as:

```bash 
make report.pdf
```

The goal here is to get you as comfortable as possible with the idea that your figures, intermediate data sets, reports,
are _transient_ objects that you can rebuild _at any time_.

Now ::programming_languages:programming languages::.

:student-select:What repeated task in your studies would you most like to automate?; ../students.json::
:student-select:List a short sequence of steps you do often (e.g., load data → clean → plot).; ../students.json::
Programming
===========

Programming is a key skill for any technical professional because lots 
of stuff can be automated and you're just leaving a lot of time on the table
if you don't know how it works.

The good news is that programming really has almost nothing to do with 
programming languages, per se. They are all almost identical. 

What I will try to teach you is how to think about programming in general 
and hopefully, if I succeed, you'll be comfortable picking up any language
that you want except perhaps for the really weird ones.

For data scientists in particular, we just mostly glue methods together, so our
programming is usually very simple. But not always!

```r file=little_scheme.scm
;; Meta-circular evaluator (simplified SICP version)

;; Entry point
(define (eval exp env)
  (cond
    ((self-evaluating? exp) exp)
    ((variable? exp) (lookup-variable-value exp env))
    ((quoted? exp) (text-of-quotation exp))
    ((assignment? exp) (eval-assignment exp env))
    ((definition? exp) (eval-definition exp env))
    ((if? exp) (eval-if exp env))
    ((lambda? exp) (make-procedure (lambda-parameters exp)
                                   (lambda-body exp)
                                   env))
    ((begin? exp) (eval-sequence (begin-actions exp) env))
    ((cond? exp) (eval (cond->if exp) env))
    ((application? exp)
     (apply (eval (operator exp) env)
            (list-of-values (operands exp) env)))
    (else (error "Unknown expression type -- EVAL" exp))))

(define (apply procedure arguments)
  (cond
    ((primitive-procedure? procedure)
     (apply-primitive-procedure procedure arguments))
    ((compound-procedure? procedure)
     (eval-sequence
       (procedure-body procedure)
       (extend-environment
         (procedure-parameters procedure)
         arguments
         (procedure-environment procedure))))
    (else (error "Unknown procedure type -- APPLY" procedure))))

;; Helpers for evaluation
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)

```
It's kind of hard to state how simple programming languages are, really, but above is a little dumb trick called the scheme meta-circular evaluator.
It is a full programming language defined in a handful of lines of code. Really,
once you get this idea, most other dynamically typed programming languages are
just "sugar" on top of these ideas.

Now to the "data" part of ::data_science:data science::.

:student-select:What is your current programming experience level (none/beginner/intermediate/advanced)?; ../students.json::
:student-select:What’s one thing you’d like to automate or build by the end of the course?; ../students.json::
Data Science
============

We are going to cover the standard suite of methods in this course. 

The basic idea behind _all exploratory data analysis_ is that given any
data set there is less than meets the eye in it. That is to say,
when we do dimensionality reduction we are saying

"I can represent this data with fewer numbers than it started with"

when we do clustering we say

"I can represent this data as a small set of clusters which are characterized by a few
numbers or properties"

When we do regression we are saying

"One variable in our data is actually representable as a combination of other variables"

and this is true for classification as well (which is just regression with a discrete
variable).

Even though it's complicated, model selection and characterization is just detail
work we need to do to choose specific representations given some criteria. That 
is it: ALL DATA SCIENCE IS SUMMARIZATION.

We will start with ::dimensionality_reduction:dimensionality reduction::.




:student-select:Which part sounds most interesting right now: exploring data, finding patterns, predicting, or visualizing?; ../students.json::
:student-select:What kind of data would you enjoy analyzing (sports, health, music, finance, other)?; ../students.json::
Dimensionality Reduction
========================

Here is a very concrete example of dimensionality reduction:

Consider these voltage traces from a (simulated) neuron.
```R file=plot_voltages.R
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
```R file=pca.R
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
OK, so we can see that there are just three types of voltage traces. 

We can use ::clustering:clustering:: to see which traces belong in which cluster.

:student-select:If you had many measurements, which 2–3 would you keep to summarize something familiar (e.g., a song, a class)?; ../students.json::
:student-select:Name two characteristics that best summarize a hobby or interest of yours.; ../students.json::
Clustering
==========

The simplest clustering method automatically gives a label to each 
trace:

```R file=cluster.R
# kmeans_pc12_traces.R
# Cluster projection.csv on PC1 & PC2, color-coded scatter,
# then average original traces per cluster and plot mean traces.

# S1: Imports
library(tidyverse)

# S2: Params (k from CLI; default k = 3)
args <- commandArgs(trailingOnly = TRUE)
k <- if (length(args) >= 1 && !is.na(suppressWarnings(as.integer(args[1])))) {
  as.integer(args[1])
} else 3

set.seed(42)

# S3: Load scores and pick PC1, PC2
scores_raw <- read_csv("projection.csv", show_col_types = FALSE)

pc_cols <- c("PC1", "PC2")
if (!all(pc_cols %in% names(scores_raw))) {
  # Fallback: first two numeric columns
  num_cols <- names(scores_raw)[map_lgl(scores_raw, is.numeric)]
  if (length(num_cols) < 2) stop("Need at least two numeric columns or named PC1 and PC2.")
  pc_cols <- num_cols[1:2]
  message(sprintf("Using columns: %s, %s", pc_cols[1], pc_cols[2]))
}

scores <- scores_raw |>
  select(all_of(pc_cols)) |>
  rename(PC1 = 1, PC2 = 2)

# S4: K-means on (PC1, PC2)
if (anyNA(scores)) stop("projection.csv contains NA in PC1/PC2; cannot run k-means safely.")
km <- kmeans(scores[, c("PC1", "PC2")], centers = k, nstart = 25)
scores$cluster <- factor(km$cluster)

# S5: Scatter PC1–PC2 colored by cluster
ggmd(ggplot(scores, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.75) +
  labs(
    title = sprintf("k-means on PC1–PC2 (k = %d)", k),
    x = "PC1",
    y = "PC2",
    color = "Cluster"
  ) +
  theme_minimal())

# S6: Load original wide data and select time columns 0..250 (inclusive)
df <- read_csv("voltages_wide.csv", show_col_types = FALSE)

time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "label", "index")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  keep(~ {
    v <- as.numeric(.x)
    v >= 0 && v <= 250
  }) |>
  (\(x) x[order(as.numeric(x))])()

wide_time <- df |> select(all_of(time_cols))

# S7: Sanity check: rows must match scores to cbind labels
if (nrow(wide_time) != nrow(scores)) {
  stop(sprintf(
    "Row count mismatch: voltages_wide (%d) vs projection.csv (%d).\nEnsure projection.csv was produced from the same rows in the same order.",
    nrow(wide_time), nrow(scores)
  ))
}

labelled <- wide_time |>
  mutate(cluster = scores$cluster);

write_csv(labelled, "labelled_traces.csv")

# S8: Average traces per cluster
avg_wide <- wide_time |>
  mutate(cluster = scores$cluster) |>
  group_by(cluster) |>
  summarise(across(everything(), ~ mean(.x, na.rm = TRUE)), .groups = "drop")

avg_long <- avg_wide |>
  pivot_longer(-cluster, names_to = "time", values_to = "avg_voltage") |>
  mutate(time = as.numeric(time))

# S9: Plot mean traces per cluster
ggmd(ggplot(avg_long, aes(x = time, y = avg_voltage, color = cluster)) +
  geom_line() +
  labs(
    title = "Mean Voltage Traces per Cluster",
    x = "Time",
    y = "Mean Voltage",
    color = "Cluster"
  ) +
  theme_minimal())

```
Now let's cook up a use for ::classification:classification::.

:student-select:Think of everyday items—what’s one way you might group them (e.g., by color, size, purpose)?; ../students.json::
:student-select:Have you ever noticed natural “groups” in something you care about (music, sports, hobbies)? Describe one.; ../students.json::
# Classification

```r file=cartoon_regression.R
# logistic_label3_simple.R
# Load labelled.csv, rename time columns t1..tN for convenience,
# drop cluster if present, fit logistic regression for label==3,
# plot coefficients vs time.

library(tidyverse)

# S1: Load
df <- read_csv("labelled_traces.csv", show_col_types = FALSE)

# S2: Outcome
if (!"cluster" %in% names(df)) stop("Expected a 'cluster' column in clusterled.csv.")
y_bin <- as.integer(df$cluster == 3)

# S3: Identify time columns (exclude cluster, trial, index, cluster)
time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "cluster", "index", "cluster")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  (\(x) x[order(as.numeric(x))])()

# S4: Rename time columns to t1..tN
n_time <- length(time_cols)
new_names <- paste0("t", seq_len(n_time))

df_clean <- df |>
  select(cluster, all_of(time_cols)) |>
  rename_with(~ new_names, all_of(time_cols)) |>
  mutate(y_bin = y_bin)

# S5: Logistic regression on standardized predictors
X_scaled <- df_clean |>
  select(all_of(new_names)) |>
  scale(center = TRUE, scale = TRUE) |>
  as.data.frame()

dat <- cbind(y_bin = df_clean$y_bin, X_scaled) %>% as_tibble() %>%
  select(where(~ !any(is.na(.x))));

form <- formula(sprintf("y_bin ~ %s", paste(names(dat)[!(names(dat) %in% c("y_bin","cluster"))], collapse = " + ")))
fit <- glm(form, data = dat %>% as_tibble(), family = binomial(), na.action = na.omit)

# S6: Extract coefficients (omit intercept) and align with time axis
coefs <- coef(fit)
coefs <- coefs[setdiff(names(coefs), "(Intercept)")]
coef_tbl <- tibble(
  time = as.numeric(time_cols[2:250]),
  beta = as.numeric(coefs)
)

# S7: Plot coefficients over time
ggmd(ggplot(coef_tbl, aes(x = time, y = beta)) +
  geom_hline(yintercept = 0, linewidth = 0.3) +
  geom_line() +
  geom_point(size = 0.7) +
  labs(
    title = "Logistic Regression Coefficients for cluster==3",
    x = "Time",
    y = "Coefficient (standardized features)"
  ) +
  theme_minimal())

```
In ::../chapter3/start:chapter 3:: we will bang all this into the shape of a 
small project.

:student-select:Name a simple yes/no decision you make often (e.g., bring umbrella?). What info do you use?; ../students.json::
:student-select:Pick two categories from daily life (e.g., ripe/unripe fruit). What clues separate them?; ../students.json::
