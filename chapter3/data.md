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
