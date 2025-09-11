:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

# Why Learn Unix

Unix, generally in the form of Linux, but also commonly encountered as
the underlying idiom of OSX and other important systems, powers the
world.

```csv file=./data.csv

| Source  | Month | Year | Unix | Windows |
|---------|-------|------|------|---------|
| W3Techs | May   | 2021 | 75.3 | 24.8    |
| W3Techs | Jan   | 2020 | 71.0 | 29.0    |
| W3Techs | Jan   | 2018 | 66.8 | 33.2    |
| W3Techs | Jan   | 2016 | 67.7 | 32.3    |
| W3Techs | Jan   | 2014 | 66.8 | 33.2    |
| W3Techs | Jan   | 2012 | 63.5 | 36.5    |

```

```r 
library(tidyverse);
read_md_table <- function(path) {
  read_delim(
    path,
    delim = "|",
    trim_ws = TRUE,
    skip = 1,          # skip the separator row of dashes
    show_col_types = FALSE
  ) %>%
    select(-1, -last_col()) %>%   # drop empty columns from leading/trailing pipes
    rename_with(str_trim) %>%
    filter(row_number() != 1) 
}

data <- read_md_table("./data.csv") %>%
  mutate(Year=Year %>% as.numeric(),
         Unix= Unix %>% as.numeric(),
         Windows = Windows %>% as.numeric())
print(data)
p <- ggplot(data, aes(Year, Unix)) + geom_line()
ggmd(p)
```

Some very popular data science software (RStudio Server, Jupyter/Labs)
runs on Linux (even if you access them via a web browser on any
platform).

This means that if you become a working data scientist or want to
support yourself working with many data scientific tools as a
researcher, some knowledge of Unix will be useful to you.

If that weren't enough, the true key to portable data science is Docker.
It is true that you can run Docker in Windows but the configuration of
docker containers requires a good working knowledge of the Unix idiom,
since most containers are Linux-based.

```sidebar
Docker vs Podman
----------------

Docker and Podman are containerization systems and podman intentionally 
implements a docker compatible interface. The main difference is that podman
is _serverless_ and runs without root privileges, which makes it both somewhat
safer and lighter, but also makes certain natural patterns in docker not work
in podman.
```

For this book, Linux-based Docker Containers will be the norm. For
Windows users I highly recommend using the instructions located
[here](https://docs.docker.com/docker-for-windows/wsl/):

    https://docs.docker.com/docker-for-windows/wsl/

to set up both Windows Subsystem for Linux (which will allow you to run
a Linux environment natively on Windows) and setting up the appropriate
Docker install on top of it.

Mac users can use the standard Docker install. Linux users will
typically know what they want to do, but the short version is install
Docker via the instructions appropriate to your distribution and make
sure you are in the docker group.

NB: Users of Apple Silicon Macs might find using the rocker/verse images
upon which we base most of the course problematic (they are not compiled
for ARM processors). Someone has hacked together a version for Apple
Silicon Macs:

<https://github.com/elbamos/rstudio-m1>

And you might be able to get the Rocker images running by enabling
Rosetta. See this thread:

<https://github.com/rocker-org/rocker-versioned2/issues/144>

We will discuss Docker in greater detail in later chapters.

Next, we look at how computers are structured: ::introduction_to_computers:Introduction to Computers::
