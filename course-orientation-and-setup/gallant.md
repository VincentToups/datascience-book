Gallant
=======

In contrast, Gallant presents at Comic Book Data Science 2025 a
similar result: that whether a character is good, evil, or neutral,
can be predicted based on a distribution of powers. Swept up in the
furor created by Goofus's shitty research practices, Gallant is
called upon to explain discrepancies in his results published in 2025
and 2026.

:genimg:a suave, cool, organized woman scientist::

Unlike Goofus, Gallant has his project in a Git repository and is able
to detect the exact commit when his results changed between 2025 and 2026. Not
only that, but using `git blame` he can identify exactly the line of
code responsible, and the commit message in the repository explains
what he was thinking when he made the change.

He is able to do this because his entire project is automated, so to
reproduce a result is a matter only of checking out his repository at
a given commit and running `make report.pdf`.

<svg id="makefile"></svg>
```javascript browser
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


In fact, he can do something called `git bisect` to automate this
process with a little extra work.

Having determined the reason for the change (having to do with a step
where incorrect data was removed from the input data set), he is able
to send a link to the repository itself to a colleague in Cologne, and
they develop a successful collaboration.

:next:homework:Homework!::
