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
