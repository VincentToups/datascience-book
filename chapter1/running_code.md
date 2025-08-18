Being Nice
==========

The previous stuff was a matter of scientific ethics and practice. If you can't
explain how your results looked 5 months ago when you published a paper, you are
just don't bad science.

But just keeping a version history of our repository isn't enough. We also need
to be able to actually _run_ the code when we pick out a specific time.

In this class we will solve this problem with a build system, which works like 
this:

<svg id="mf-graph" style="width: 100%; height: 400px;"></svg>

Why do this?

The main idea is to reduce the cognitive load of a person trying to understand
what the heck is happening in your codebase. 

That person might be you or it might be someone else, but in any case
the goal is to know what the heck your code does, why, and make it easy to
get to that understanding _while also_ making your work much more reproducible.

:next:goofus_gallant:A story makes this more clear.::

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

  makefileGraph("mf-graph", makefileDeps);
```