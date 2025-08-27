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
