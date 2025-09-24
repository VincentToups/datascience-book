Principles of Effective Visualization
=====================================

You will all be delighted that we will work, sort of, from a text today:

```
Principles of Effective Data Visualization,
Patterns (N Y)
. 2020 Nov 11;1(9):100141. doi: 10.1016/j.patter.2020.100141
Stephen R Midway 1,∗

PMCID: PMC7733875  PMID: 33336199

```
[Principles of Effective Data Visualization](https://pmc.ncbi.nlm.nih.gov/articles/PMC7733875/)

- Principle #1: Diagram First
- Principle #2: Use the Right Software
- Principle #3: Use an Effective Geometry and Show Data
- Principle #4: Colors Always Mean Something
- Principle #5: Include Uncertainty
- Principle #6: Panel When Possible (Small Multiples)
- Principle #7: Data and Models Are Different Things
- Principle #8: Simple Visuals, Detailed Captions
- Principle #9: Consider an Infographic
- Principle #10: Get an Opinion

We will try to go through them in order, but YOU will provide opinions
throughout.

Our data set:

:table:source_data/tng.csv::


I've already cleaned this dataset and also added a dataset so we can join gender information.

:student-select: Q: Diagram something for this dataset.; ../students.json::
Next: ::02_software:Use the right software.::
Use the Right Software
======================

> Effective visuals typically require good command of one or more
> software. In other words, it might be unrealistic to expect complex,
> technical, and effective figures if you are using a simple spreadsheet
> program or some other software that is not designed to make complex,
> technical, and effective figures. Recognize that you might need to learn
> a new software---or expand your knowledge of a software you already
> know. While highly effective and aesthetically pleasing figures can be
> made quickly and simply, this may still represent a challenge to some.
> However, figure making is a method like anything else, and in order to
> do it, new methodologies may need to be learned. You would not expect to
> improve a field or lab method without changing something or learning
> something new. Data visualization is the same, with the added benefit
> that most software is readily available, inexpensive, or free, and many
> come with large online help resources.
- Principles of Effective Data Visualization, Stephen R Midway

I would add to this only the following notes:

1. In this class, the right software is almost always "ggplot."
2. In general, there is no such thing as the right software—you should be intrepid in your pursuit of whatever
technical solutions are useful to your ends.
3. The "right" software is usually something that conceptualizes the domain in a way that is simple enough
but no simpler. ggplot knows that, fundamentally, we connect data and geometry together when we make plots. It knows that the standard plot types are expressions of that idea, but not the boundaries of it.

::03_geom_data:Use an Effective Geometry and Show Data::
Use an Effective Geometry
=========================

Consider:

``` R file=bad_geometry.R

```

:student-select:Is this an effective geometry?;../students.json::
:student-select:Why isn't it an effective geometry?;../students.json::
:student-select:When might it be an effective geometry?;../students.json::





``` R file=good_geometry.R

```
The advice "Show Data" is a little obscure. What does it mean?

> Even if a geometry
> might be the focus of the figure, data can usually be added and
> displayed in a way that does not detract from the geometry but instead
> provides the context for the geometry... The data are often at the core of the
> message, yet in figures the data are often ignored on account of their
> simplicity.

This is good advice, but sometimes we have to think carefully about how to represent the data.
The primary idea in "show data" is that geometries tend to capture *means* or *medians* or some other summary
statistic. We want to add as much information about the texture of the data as we can.

Note that this also captures his advice: "Show variance."

:student-select:How might we do that here?;../students.json::

::04_show:Showing more::
Showing More
============

Sometimes we have to change our perspective on a dataset.

What if we calculated the amount of dialog *per episode* instead of over the entire
dataset—that would show a lot more interesting information.

``` R file=better_geom.R

```
We can pack even more into the plot with a violin plot:

``` R file=geom_violin.R

```
Can we do even better?

Arguably: we have more than just dialog counts; we also have the length of each 
section of dialog. That is probably more informative.


Let's move on to ::05_color:Color.::
Color Always Means Something
============================

Be mindful of colorblind readers—otherwise it can be confusing.

> In today's digital environment, color is cheap. This is overwhelmingly
> a good thing, but also comes with the risk of colors being applied
> without intention. Black-and-white visuals were more accepted decades
> ago when hard copies of papers were more common and color printing
> represented a large cost. Now, however, the vast majority of readers
> view scientific papers on an electronic screen where color is free. For
> those who still print documents, color printing can be done relatively
> cheaply in comparison with some years ago.

``` R file=color.R

```

``` R file=bw.R

```

``` R file=colorblind.R

```

OK. 

The main idea is that we want the message of the plot to be processed pre-attentively. Color is processed pre-attentively as long as we have contrast. Too many colors become unreadable.
I feel ambivalent about the following bits of advice. ::06_faceting:Facets::
Facets
======

I think faceting can often be a sign that you've got too much data.
When we facet, we move comparisons far away from one another. If you find you
are reaching for faceting, maybe make a new plot?

``` R file=facets.R

```
Other advice:

::07_data_vs_models:Data and Models Are Different Things::
Data and Models
===============

> Plotted information typically takes the form of raw data (e.g.,
> scatterplot), summarized data (e.g., box plot), or an inferential
> statistic (e.g., fitted regression line; [Figure 1](#fig1)D).
> Raw data and summarized data are often relatively straightforward;
> however, a plotted model may require more explanation for a reader to be
> able to fully reproduce the work. Certainly any model in a study should
> be reported in a complete way that ensures reproducibility. However, any
> visual of a model should be explained in the figure caption or
> referenced elsewhere in the document so that a reader can find the
> complete details on what the model visual is representing. Although it
> happens, it is not acceptable practice to show a fitted model or other
> model results in a figure if the reader cannot backtrack the model
> details. Simply because a model geometry can be added to a figure does
> not mean that it should be.

He also suggests detailed captions. But I would caution you: if your captions are getting long
it might be a sign that you need to reconsider your plot.

I feel similarly about "infographics" (his principle 9). In general, I
think "infographics" are bad unless your purpose is to dazzle or bamboozle.

Or if you are trying to show a domain expert something in a form they
can digest completely.

My advice is that if you think you need an infographic it might be
because you aren't willing to push your tools a bit and think outside
of the box.

His final advice is "get an opinion."

This doesn't hurt. Ask me, ask someone, but never just throw a figure at your
audience without testing it ahead of time.

:student-select: Any ideas from this about your dataset?; ../students.json::
