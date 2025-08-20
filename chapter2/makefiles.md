Makefiles
=========

Nothing beats looking at a Makefile to get a sense for why they are valuable.

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
