# Principles of Effective Data Visualization

Author: Stephen R Midway (Department of Oceanography and Coastal Sciences, Louisiana State University, Baton Rouge, LA 70803, USA).
Citation: Patterns; 2020 Nov 11; 1(9); 100141.
Journal Links: NLM Catalog: https://www.ncbi.nlm.nih.gov/nlmcatalog?term=%22Patterns%20(N%20Y)%22%5BTitle%20Abbreviation%5D | Publisher site: https://www.cell.com/patterns/home.
DOI: https://doi.org/10.1016/j.patter.2020.100141; PMID: 33336199; PMCID: PMC7733875.
Links: Full text: https://pmc.ncbi.nlm.nih.gov/articles/PMC7733875/ | PDF: https://pmc.ncbi.nlm.nih.gov/articles/PMC7733875/pdf/main.pdf.
Correspondence: smidway@lsu.edu.
License: CC BY-NC-ND 4.0 (http://creativecommons.org/licenses/by-nc-nd/4.0/).

## Summary

We live in a contemporary society surrounded by visuals, which, along
with software options and electronic distribution, has created an
increased importance on effective scientific visuals. Unfortunately,
across scientific disciplines, many figures incorrectly present
information or, when not incorrect, still use suboptimal data
visualization practices. Presented here are ten principles that serve as
guidance for authors who seek to improve their visual message. Some
principles are less technical, such as determining the message before
starting the visual, while other principles are more technical, such as
how different color combinations imply different information. Because
figure making is often not formally taught and figure standards are not
readily enforced in science, it is incumbent upon scientists to be aware
of best practices in order to most effectively tell the story of their
data.

## The Bigger Picture

Visuals are an increasingly important form of science communication, yet
many scientists are not well trained in design principles for effective
messaging. Despite challenges, many visuals can be improved by taking
some simple steps before, during, and after their creation. This article
presents some sequential principles that are designed to improve visual
messages created by scientists.

------------------------------------------------------------------------

Many scientific visuals are not as effective as they could be because
scientists often lack basic design principles. This article reviews the
importance of effective data visualization and presents ten principles
that scientists can use as guidance in developing effective visual
messages.

## Introduction

Visual learning is one of the primary forms of interpreting information,
which has historically combined images such as charts and graphs (see
[Box 1](#tbox1)) with reading text.[^1^](#bib1) However, developments on learning styles have
suggested splitting up the visual learning modality in order to
recognize the distinction between text and images.[^2^](#bib2) Technology has also enhanced visual
presentation, in terms of the ability to quickly create complex visual
information while also cheaply distributing it via digital means
(compared with paper, ink, and physical distribution). Visual
information has also increased in scientific literature. In addition to
the fact that figures are commonplace in scientific publications, many
journals now require graphical abstracts[^3^](#bib3) or might tweet figures to advertise an article.
Dating back to the 1970s when computer-generated graphics
began,[^4^](#bib4) papers represented
by an image on the journal cover have been cited more frequently than
papers without a cover image.[^5^](#bib5)

### Box 1.

Regarding terminology, the terms *graph*, *plot*, *chart*, *image*,
*figure*, and *data visual(ization)* are often used interchangeably,
although they may have different meanings in different instances.
*Graph*, *plot*, and *chart* often refer to the display of data, data
summaries, and models, while *image* suggests a picture. *Figure* is a
general term but is commonly used to refer to visual elements, such as
plots, in a scientific work. A *visual*, or *data visualization*, is a
newer and ostensibly more inclusive term to describe everything from
figures to infographics. Here, I adopt common terminology, such as bar
plot, while also attempting to use the terms figure and data
visualization for general reference.

There are numerous advantages to quickly and effectively conveying
scientific information; however, scientists often lack the design
principles or technical skills to generate effective visuals. Going back
several decades, Cleveland[^6^](#bib6) found that 30% of graphs in the journal
*Science* had at least one type of error. Several other studies have
documented widespread errors or inefficiencies in scientific
figures.[7](#bib7),
[8](#bib8), [9](#bib9) In fact, the increasing menu of visualization
options can sometimes lead to poor fits between information and its
presentation. These poor fits can even have the unintended consequence
of confusing the readers and setting them back in their understanding of
the material. While objective errors in graphs are hopefully in the
minority of scientific works, what might be more common is suboptimal
figure design, which takes place when a design element may not be
objectively wrong but is ineffective to the point of limiting
information transfer.

Effective figures suggest an understanding and interpretation of data;
ineffective figures suggest the opposite. Although the field of data
visualization has grown in recent years, the process of displaying
information cannot---and perhaps should not---be fully mechanized. Much
like statistical analyses often require expert opinions on top of best
practices, figures also require choice despite well-documented
recommendations. In other words, there may not be a singular best
version of a given figure. Rather, there may be multiple effective
versions of displaying a single piece of information, and it is the
figure maker\'s job to weigh the advantages and disadvantages of each.
Fortunately, there are numerous principles from which decisions can be
made, and ultimately design is choice.[^7^](#bib7)

The data visualization literature includes many great resources. While
several resources are targeted at developing design proficiency, such as
the series of columns run by *Nature
Communications*,[^10^](#bib10)
Wilkinson\'s *The Grammar of Graphics*[^11^](#bib11) presents a unique technical interpretation of
the structure of graphics. Wilkinson breaks down the notion of a graphic
into its constituent parts---e.g., the data, scales, coordinates,
geometries, aesthetics---much like conventional grammar breaks down a
sentence into nouns, verbs, punctuation, and other elements of writing.
The popularity and utility of this approach has been implemented in a
number of software packages, including the popular ggplot2
package[^12^](#bib12) currently
available in R.[^13^](#bib13)
(Although the grammar of graphics approach is not explicitly adopted
here, the term *geometry* is used consistently with Wilkinson to refer
to different geometrical representations, whereas the term *aesthetics*
is not used consistently with the grammar of graphics and is used simply
to describe something that is visually appealing and effective.) By
understanding basic visual design principles and their implementation,
many figure authors may find new ways to emphasize and convey their
information.

## The Ten Principles

### Principle #1 Diagram First

The first principle is perhaps the least technical but very important:
before you make a visual, prioritize the information you want to share,
envision it, and design it. Although this seems obvious, the larger
point here is to focus on the information and message first, before you
engage with software that in some way starts to limit or bias your
visual tools. In other words, don\'t necessarily think of the geometries
(dots, lines) you will eventually use, but think about the core
information that needs to be conveyed and what about that information is
going to make your point(s). Is your visual objective to show a
comparison? A ranking? A composition? This step can be done mentally, or
with a pen and paper for maximum freedom of thought. In parallel to this
approach, it can be a good idea to save figures you come across in
scientific literature that you identify as particularly effective. These
are not just inspiration and evidence of what is possible, but will help
you develop an eye for detail and technical skills that can be applied
to your own figures.

### Principle #2 Use the Right Software

Effective visuals typically require good command of one or more
software. In other words, it might be unrealistic to expect complex,
technical, and effective figures if you are using a simple spreadsheet
program or some other software that is not designed to make complex,
technical, and effective figures. Recognize that you might need to learn
a new software---or expand your knowledge of a software you already
know. While highly effective and aesthetically pleasing figures can be
made quickly and simply, this may still represent a challenge to some.
However, figure making is a method like anything else, and in order to
do it, new methodologies may need to be learned. You would not expect to
improve a field or lab method without changing something or learning
something new. Data visualization is the same, with the added benefit
that most software is readily available, inexpensive, or free, and many
come with large online help resources. This article does not promote any
specific software, and readers are encouraged to reference other
work[^14^](#bib14) for an overview
of software resources.

### Principle #3 Use an Effective Geometry and Show Data

Geometries are the shapes and features that are often synonymous with a
type of figure; for example, the bar geometry creates a bar plot. While
geometries might be the defining visual element of a figure, it can be
tempting to jump directly from a dataset to pairing it with one of a
small number of well-known geometries. Some of this thinking is likely
to naturally happen. However, geometries are representations of the data
in different forms, and often there may be more than one geometry to
consider. Underlying all your decisions about geometries should be the
data-ink ratio,[^7^](#bib7) which is
the ratio of ink used on data compared with overall ink used in a
figure. High data-ink ratios are the best, and you might be surprised to
find how much non-data-ink you use and how much of that can be removed.

Most geometries fall into categories: *amounts* (or comparisons),
*compositions* (or proportions), *distributions*, or *relationships*.
Although seemingly straightforward, one geometry may work in more than
one category, in addition to the fact that one dataset may be visualized
with more than one geometry (sometimes even in the same figure).
Excellent resources exist on detailed approaches to selecting your
geometry,[^15^](#bib15) and this
article only highlights some of the more common geometries and their
applications.

Amounts or comparisons are often displayed with a bar plot
([Figure 1](#fig1)A), although numerous other options exist,
including Cleveland dot plots and even heatmaps
([Figure 1](#fig1)F). Bar plots are among the most common
geometry, along with lines,[^9^](#bib9) although bar plots are noted for their very low
data density[^16^](#bib16) (i.e.,
low data-ink ratio). Geometries for amounts should only be used when the
data do not have distributional information or uncertainty associated
with them. A good use of a bar plot might be to show counts of
something, while poor use of a bar plot might be to show group means.
Numerous studies have discussed inappropriate uses of bar
plots,[^9^](#bib9)^,^[^17^](#bib17) noting that "because the bars always start at
zero, they can be misleading: for example, part of the range covered by
the bar might have never been observed in the
sample."[^17^](#bib17) Despite the
numerous reports on incorrect usage, bar plots remain one of the most
common problems in data visualization.

**Figure 1.**
![Figure 1](https://cdn.ncbi.nlm.nih.gov/pmc/blobs/ad64/7733875/62865948aa17/gr1.jpg)

(A) Clustered bar plots are effective at showing units within a group
(A–C) when the data are amounts.
(B) Histograms are effective at showing the distribution of data,
which in this case is a random draw of values from a Poisson
distribution and which use a sequential color scheme that emphasizes the
mean as red and values farther from the mean as yellow.
(C) Scatterplot where the black circles represent the data.
(D) Logistic regression where the blue line represents the fitted
model, the gray shaded region represents the confidence interval for the
fitted model, and the dark-gray dots represent the jittered data.
(E) Box plot showing (simulated) ages of respondents grouped by their
answer to a question, with gray dots representing the raw data used in
the box plot. The divergent colors emphasize the differences in values.
For each box plot, the box represents the interquartile range (IQR), the
thick black line represents the median value, and the whiskers extend to
1.5 times the IQR. Outliers are represented by the data.
(F) Heatmap of simulated visibility readings in four lakes over
5 months. The green colors represent lower visibility and the blue
colors represent greater visibility. The white numbers in the cells are
the average visibility measures (in meters).
(G) Density plot of simulated temperatures by season, where each
season is presented as a small multiple within the larger figure.
For all figures the data were simulated, and any examples are

Compositions or proportions may take a wide range of geometries.
Although the traditional pie chart is one option, the pie geometry has
fallen out of favor among some[^18^](#bib18) due to the inherent difficulties in making
visual comparisons. Although there may be some applications for a pie
chart, stacked or clustered bar plots ([Figure 1](#fig1)A),
stacked density plots, mosaic plots, and treemaps offer alternatives.

Geometries for distributions are an often underused class of visuals
that demonstrate high data density. The most common geometry for
distributional information is the box plot[^19^](#bib19) ([Figure 1](#fig1)E), which shows
five types of information in one object. Although more common in
exploratory analyses than in final reports, the histogram
([Figure 1](#fig1)B) is another robust geometry that can
reveal information about data. Violin plots and density plots
([Figure 1](#fig1)G) are other common distributional
geometries, although many less-common options exist.

Relationships are the final category of visuals covered here, and they
are often the workhorse of geometries because they include the popular
scatterplot ([Figures 1](#fig1)C and 1D) and other
presentations of *x*- and *y*-coordinate data. The basic scatterplot
remains very effective, and layering information by modifying point
symbols, size, and color are good ways to highlight additional messages
without taking away from the scatterplot. It is worth mentioning here
that scatterplots often develop into line geometries
([Figure 1](#fig1)D), and while this can be a good thing,
presenting raw data and inferential statistical models are two different
messages that need to be distinguished (see [Data and Models Are
Different Things](#sec2.7)).

Finally, it is almost always recommended to show the
data.[^7^](#bib7) Even if a geometry
might be the focus of the figure, data can usually be added and
displayed in a way that does not detract from the geometry but instead
provides the context for the geometry (e.g., [Figures
1](#fig1)D and 1E). The data are often at the core of the
message, yet in figures the data are often ignored on account of their
simplicity.

### Principle #4 Colors *Always* Mean Something

The use of color in visualization can be incredibly powerful, and there
is rarely a reason not to use color. Even if authors do not wish to pay
for color figures in print, most journals still permit free color
figures in digital formats. In a large study[^20^](#bib20) of what makes visualizations memorable,
colorful visualizations were reported as having a higher memorability
score, and that seven or more colors are best. Although some of the
visuals in this study were photographs, other
studies[^21^](#bib21) also document
the effectiveness of colors.

In today\'s digital environment, color is cheap. This is overwhelmingly
a good thing, but also comes with the risk of colors being applied
without intention. Black-and-white visuals were more accepted decades
ago when hard copies of papers were more common and color printing
represented a large cost. Now, however, the vast majority of readers
view scientific papers on an electronic screen where color is free. For
those who still print documents, color printing can be done relatively
cheaply in comparison with some years ago.

Color represents information, whether in a direct and obvious way, or in
an indirect and subtle way. A direct example of using color may be in
maps where water is blue and land is green or brown. However, the vast
majority of (non-mapping) visualizations use color in one of three
schemes: *sequential*, *diverging*, or *qualitative*. Sequential color
schemes are those that range from light to dark typically in one or two
(related) hues and are often applied to convey increasing values for
increasing darkness ([Figures 1](#fig1)B and 1F). Diverging
color schemes are those that have two sequential schemes that represent
two extremes, often with a white or neutral color in the middle
([Figure 1](#fig1)E). A classic example of a diverging color
scheme is the red to blue hues applied to jurisdictions in order to show
voting preference in a two-party political system. Finally, qualitative
color schemes are found when the intensity of the color is not of
primary importance, but rather the objective is to use different and
otherwise unrelated colors to convey qualitative group differences
([Figures 1](#fig1)A and 1G).

While it is recommended to use color and capture the power that colors
convey, there exist some technical recommendations. First, it is always
recommended to design color figures that work effectively in both color
and black-and-white formats ([Figures 1](#fig1)B and 1F). In
other words, whenever possible, use color that can be converted to an
effective grayscale such that no information is lost in the conversion.
Along with this approach, colors can be combined with symbols, line
types, and other design elements to share the same information that the
color was sharing. It is also good practice to use color schemes that
are effective for colorblind readers ([Figures 1](#fig1)A and
1E). Excellent resources, such as ColorBrewer,[^22^](#bib22) exist to help in selecting color schemes based
on colorblind criteria. Finally, color transparency is another powerful
tool, much like a volume knob for color ([Figures 1](#fig1)D
and 1E). Not all colors have to be used at full value, and when not part
of a sequential or diverging color scheme---and especially when a figure
has more than one colored geometry---it can be very effective to
increase the transparency such that the information of the color is
retained but it is not visually overwhelming or outcompeting other
design elements. Color will often be the first visual information a
reader gets, and with this knowledge color should be strategically used
to amplify your visual message.

### Principle #5 Include Uncertainty

Not only is uncertainty an inherent part of understanding most systems,
failure to include uncertainty in a visual can be misleading. There
exist two primary challenges with including uncertainty in visuals:
failure to include uncertainty and misrepresentation (or
misinterpretation) of uncertainty.

Uncertainty is often not included in figures and, therefore, part of the
statistical message is left out---possibly calling into question other
parts of the statistical message, such as inference on the mean.
Including uncertainty is typically easy in most software programs, and
can take the form of common geometries such as error bars and shaded
intervals (polygons), among other features.[^15^](#bib15) Another way to approach visualizing
uncertainty is whether it is included implicitly into the existing
geometries, such as in a box plot ([Figure 1](#fig1)E) or
distribution ([Figures 1](#fig1)B and 1G), or whether it is
included explicitly as an additional geometry, such as an error bar or
shaded region ([Figure 1](#fig1)D).

Representing uncertainty is often a challenge.[^23^](#bib23) Standard deviation, standard error, confidence
intervals, and credible intervals are all common metrics of uncertainty,
but each represents a different measure. Expressing uncertainty requires
that readers be familiar with metrics of uncertainty and their
interpretation; however, it is also the responsibility of the figure
author to adopt the most appropriate measure of uncertainty. For
instance, standard deviation is based on the spread of the data and
therefore shares information about the entire population, including the
range in which we might expect new values. On the other hand, standard
error is a measure of the uncertainty in the mean (or some other
estimate) and is strongly influenced by sample size---namely, standard
error decreases with increasing sample size. Confidence intervals are
primarily for displaying the reliability of a measurement. Credible
intervals, almost exclusively associated with Bayesian methods, are
typically built off distributions and have probabilistic
interpretations.

Expressing uncertainty is important, but it is also important to
interpret the correct message. Krzywinski and
Altman[^23^](#bib23) directly
address a common misconception: "a gap between (error) bars does not
ensure significance, nor does overlap rule it out---it depends on the
type of bar." This is a good reminder to be very clear not only in
stating what type of uncertainty you are sharing, but what the
interpretation is. Others[^16^](#bib16) even go so far as to recommend that standard
error not be used because it does not provide clear information about
standard errors of differences among means. One recommendation to go
along with expressing uncertainty is, if possible, to show the data (see
[Use an Effective Geometry and Show Data](#sec2.3)).
Particularly when the sample size is low, showing a reader where the
data occur can help avoid misinterpretations of uncertainty.

### Principle #6 Panel, when Possible (Small Multiples)

A particularly effective visual approach is to repeat a figure to
highlight differences. This approach is often called *small
multiples*,[^7^](#bib7) and the
technique may be referred to as paneling or faceting
([Figure 1](#fig1)G). The strategy behind small multiples is
that because many of the design elements are the same---for example, the
axes, axes scales, and geometry are often the same---the differences in
the data are easier to show. In other words, each panel represents a
change in one variable, which is commonly a time step, a group, or some
other factor. The objective of small multiples is to make the data
inevitably comparable,[^7^](#bib7)
and effective small multiples always accomplish these comparisons.

### Principle #7 Data and Models Are Different Things

Plotted information typically takes the form of raw data (e.g.,
scatterplot), summarized data (e.g., box plot), or an inferential
statistic (e.g., fitted regression line; [Figure 1](#fig1)D).
Raw data and summarized data are often relatively straightforward;
however, a plotted model may require more explanation for a reader to be
able to fully reproduce the work. Certainly any model in a study should
be reported in a complete way that ensures reproducibility. However, any
visual of a model should be explained in the figure caption or
referenced elsewhere in the document so that a reader can find the
complete details on what the model visual is representing. Although it
happens, it is not acceptable practice to show a fitted model or other
model results in a figure if the reader cannot backtrack the model
details. Simply because a model geometry can be added to a figure does
not mean that it should be.

### Principle #8 Simple Visuals, Detailed Captions

As important as it is to use high data-ink ratios, it is equally
important to have detailed captions that fully explain everything in the
figure. A study of figures in the *Journal of American
Medicine*[^8^](#bib8) found that more
than one-third of graphs were not self-explanatory. Captions should be
standalone, which means that if the figure and caption were looked at
independent from the rest of the study, the major point(s) could still
be understood. Obviously not all figures can be completely standalone,
as some statistical models and other procedures require more than a
caption as explanation. However, the principle remains that captions
should do all they can to explain the visualization and representations
used. Captions should explain any geometries used; for instance, even in
a simple scatterplot it should be stated that the black dots represent
the data ([Figures 1](#fig1)C--1E). Box plots also require
descriptions of their geometry---it might be assumed what the features
of a box plot are, yet not all box plot symbols are universal.

### Principle #9 Consider an Infographic

It is unclear where a figure ends and an infographic begins; however, it
is fair to say that figures tend to be focused on representing data and
models, whereas infographics typically incorporate text, images, and
other diagrammatic elements. Although it is not recommended to convert
all figures to infographics, infographics were
found[^20^](#bib20) to have the
highest memorability score and that diagrams outperformed points, bars,
lines, and tables in terms of memorability. Scientists might improve
their overall information transfer if they consider an infographic where
blending different pieces of information could be effective. Also, an
infographic of a study might be more effective outside of a
peer-reviewed publication and in an oral or poster presentation where a
visual needs to include more elements of the study but with less
technical information.

Even if infographics are not adopted in most cases, technical visuals
often still benefit from some text or other
annotations.[^16^](#bib16) Tufte\'s
works[^7^](#bib7)^,^[^24^](#bib24) provide great examples of bringing together
textual, visual, and quantitative information into effective
visualizations. However, as figures move in the direction of
infographics, it remains important to keep chart junk and other
non-essential visual elements out of the design.

### Principle #10 Get an Opinion

Although there may be principles and theories about effective data
visualization, the reality is that the most effective visuals are the
ones with which readers connect. Therefore, figure authors are
encouraged to seek external reviews of their figures. So often when
writing a study, the figures are quickly made, and even if thoughtfully
made they are not subject to objective, outside review. Having one or
more colleagues or people external to the study review figures will
often provide useful feedback on what readers perceive, and therefore
what is effective or ineffective in a visual. It is also recommended to
have outside colleagues review only the figures. Not only might this
please your colleague reviewers (because figure reviews require
substantially less time than full document reviews), but it also allows
them to provide feedback purely on the figures as they will not have the
document text to fill in any uncertainties left by the visuals.

## What About Tables?

Although often not included as data visualization, tables can be a
powerful and effective way to show data. Like other visuals, tables are
a type of hybrid visual---they typically only include alphanumeric
information and no geometries (or other visual elements), so they are
not classically a visual. However, tables are also not text in the same
way a paragraph or description is text. Rather, tables are often
summarized values or information, and are effective if the goal is to
reference exact numbers. However, the interest in numerical results in
the form of a study typically lies in comparisons and not absolute
numbers. Gelman et al.[^25^](#bib25)
suggested that well-designed graphs were superior to tables. Similarly,
Spence and Lewandowsky[^26^](#bib26)
compared pie charts, bar graphs, and tables and found a clear advantage
for graphical displays over tabulations. Because tables are best suited
for looking up specific information while graphs are better for
perceiving trends and making comparisons and predictions, it is
recommended that visuals are used before tables. Despite the reluctance
to recommend tables, tables may benefit from digital formats. In other
words, while tables may be less effective than figures in many cases,
this does not mean tables are ineffective or do not share specific
information that cannot always be displayed in a visual. Therefore, it
is recommended to consider creating tables as supplementary or appendix
information that does not go into the main document (alongside the
figures), but which is still very easily accessed electronically for
those interested in numerical specifics.

## Conclusions

While many of the elements of peer-reviewed literature have remained
constant over time, some elements are changing. For example, most
articles now have more authors than in previous decades, and a much
larger menu of journals creates a diversity of article lengths and other
requirements. Despite these changes, the demand for visual
representations of data and results remains high, as exemplified by
graphical abstracts, overview figures, and infographics. Similarly, we
now operate with more software than ever before, creating many choices
and opportunities to customize scientific visualizations. However, as
the demand for, and software to create, visualizations have both
increased, there is not always adequate training among scientists and
authors in terms of optimizing the visual for the message.

Figures are not just a scientific side dish but can be a critical point
along the scientific process---a point at which the figure maker
demonstrates their knowledge and communication of the data and results,
and often one of the first stopping points for new readers of the
information. The reality for the vast majority of figures is that you
need to make your point in a few seconds. The longer someone looks at a
figure and doesn\'t understand the message, the more likely they are to
gain nothing from the figure and possibly even lose some understanding
of your larger work. Following a set of guidelines and
recommendations---summarized here and building on others---can help to
build robust visuals that avoid many common pitfalls of ineffective
figures ([Figure 2](#fig2)).

**Figure 2.**
![Figure 2](https://cdn.ncbi.nlm.nih.gov/pmc/blobs/ad64/7733875/8501590eabf1/gr2.jpg)

The two principles in yellow (bottom) are those that occur first,
during the figure design phase. The six principles in green (middle) are
generally considerations and decisions while making a figure. The two
principles in blue (top) are final steps often considered after a figure
has been drafted. While the general flow of the principles follows from
bottom to top, there is no specific or required order, and the
development of individual figures may require more or less consideration

All scientists seek to share their message as effectively as possible,
and a better understanding of figure design and representation is
undoubtedly a step toward better information dissemination and fewer
errors in interpretation. Right now, much of the responsibility for
effective figures lies with the authors, and learning best practices
from literature, workshops, and other resources should be undertaken.
Along with authors, journals play a gatekeeper role in figure quality.
Journal editorial teams are in a position to adopt recommendations for
more effective figures (and reject ineffective figures) and then
translate those recommendations into submission requirements. However,
due to the qualitative nature of design elements, it is difficult to
imagine strict visual guidelines being enforced across scientific
sectors. In the absence of such guidelines and with seemingly endless
design choices available to figure authors, it remains important that a
set of aesthetic criteria emerge to guide the efficient conveyance of
visual information.

## Acknowledgments

Thanks go to the numerous students with whom I have had fun, creative,
and productive conversations about displaying information. Danielle
DiIullo was extremely helpful in technical advice on software. Finally,
Ron McKernan provided guidance on several principles.

### Author Contributions

S.R.M. conceived the review topic, conducted the review, developed the
principles, and wrote the manuscript.

## Biography

**Steve Midway** is an assistant professor in the Department of
Oceanography and Coastal Sciences at Louisiana State University. His
work broadly lies in fisheries ecology and how sound science can be
applied to management and conservation issues. He teaches a number of
quantitative courses in ecology, all of which include data
visualization.

## References

-   [[1.]Stirling P. Power lines. NZ Listener. 1987:13--15.
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=NZ%20Listener&title=Power%20lines&author=P.%20Stirling&publication_year=1987&pages=13-15&)\]]
-   [[2.]Fleming N.D., Mills C. Not another inventory, rather a
    catalyst for reflection. To Improve the Academy. 1992;11:137--155.
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=To%20Improve%20the%20Academy&title=Not%20another%20inventory,%20rather%20a%20catalyst%20for%20reflection&author=N.D.%20Fleming&author=C.%20Mills&volume=11&publication_year=1992&pages=137-155&)\]]
-   [[3.]Lane S., Karatsolis A., Bui L. Graphical abstracts: a
    taxonomy and critique of an emerging genre. In: Gossett K., editor.
    Proceedings of the 33rd Annual International Conference on the
    Design of Communication. 2015.
    \[[DOI](https://doi.org/10.1145/2775441.2775465)\] \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?title=Proceedings%20of%20the%2033rd%20Annual%20International%20Conference%20on%20the%20Design%20of%20Communication&author=S.%20Lane&author=A.%20Karatsolis&author=L.%20Bui&publication_year=2015&)\]]
-   [[4.]Csuri C. Computer graphics and art. Proc. IEEE.
    1974;62:503--515. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Proc.%20IEEE&title=Computer%20graphics%20and%20art&author=C.%20Csuri&volume=62&publication_year=1974&pages=503-515&)\]]
-   [[5.]Wang G., Gregory J., Cheng X., Yao Y. Cover stories: an
    emerging aesthetic of prestige science. Public Underst. Sci.
    2017;26:925--936. doi: 10.1177/0963662517706607.
    \[[DOI](https://doi.org/10.1177/0963662517706607)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/28478707/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Public%20Underst.%20Sci.&title=Cover%20stories:%20an%20emerging%20aesthetic%20of%20prestige%20science&author=G.%20Wang&author=J.%20Gregory&author=X.%20Cheng&author=Y.%20Yao&volume=26&publication_year=2017&pages=925-936&pmid=28478707&doi=10.1177/0963662517706607&)\]]
-   [[6.]Cleveland W.S. Graphs in scientific publications. Am.
    Stat. 1984;38:261--269. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Am.%20Stat.&title=Graphs%20in%20scientific%20publications&author=W.S.%20Cleveland&volume=38&publication_year=1984&pages=261-269&)\]]
-   [[7.]Tufte E.R. vol. 2. Graphics Press; 2001. (The Visual
    Display of Quantitative Information). \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Tufte%20E.R.%20vol.%202.%20Graphics%20Press;%202001.%20(The%20Visual%20Display%20of%20Quantitative%20Information).)\]]
-   [[8.]Cooper R.J., Schriger D.L., Close R.J. Graphical
    literacy: the quality of graphs in a large-circulation journal. Ann.
    Emerg. Med. 2002;40:317--322. doi: 10.1067/mem.2002.127327.
    \[[DOI](https://doi.org/10.1067/mem.2002.127327)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/12192357/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Ann.%20Emerg.%20Med.&title=Graphical%20literacy:%20the%20quality%20of%20graphs%20in%20a%20large-circulation%20journal&author=R.J.%20Cooper&author=D.L.%20Schriger&author=R.J.%20Close&volume=40&publication_year=2002&pages=317-322&pmid=12192357&doi=10.1067/mem.2002.127327&)\]]
-   [[9.]Weissgerber T.L., Milic N.M., Winham S.J., Garovic V.D.
    Beyond bar and line graphs: time for a new data presentation
    paradigm. PLoS Biol. 2015;13:e1002128. doi:
    10.1371/journal.pbio.1002128.
    \[[DOI](https://doi.org/10.1371/journal.pbio.1002128)\] \[[PMC free
    article](/articles/PMC4406565/)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/25901488/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=PLoS%20Biol.&title=Beyond%20bar%20and%20line%20graphs:%20time%20for%20a%20new%20data%20presentation%20paradigm&author=T.L.%20Weissgerber&author=N.M.%20Milic&author=S.J.%20Winham&author=V.D.%20Garovic&volume=13&publication_year=2015&pages=e1002128&pmid=25901488&doi=10.1371/journal.pbio.1002128&)\]]
-   [[10.]Nature Communications . Macmillan Publishers
    Ltd.; 2015. Nature Collections: Visual Strategies for Biological
    Data, the Collected Points of View (2010--2015) \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Nature%20Communications%20.%20Macmillan%20Publishers%20Ltd.;%202015.%20Nature%20Collections:%20Visual%20Strategies%20for%20Biological%20Data,%20the%20Collected%20Points%20of%20View%20(2010%E2%80%932015))\]]
-   [[11.]Wilkinson L. Springer Science & Business Media; 2013.
    The Grammar of Graphics. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Wilkinson%20L.%20Springer%20Science%20&%20Business%20Media;%202013.%20The%20Grammar%20of%20Graphics.)\]]
-   [[12.]Wickham H. Springer; 2016. ggplot2: Elegant Graphics
    for Data Analysis. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Wickham%20H.%20Springer;%202016.%20ggplot2:%20Elegant%20Graphics%20for%20Data%20Analysis.)\]]
-   [[13.]R Core Team . R Foundation for Statistical
    Computing; 2020. R: A Language and Environment for Statistical
    Computing. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?R%20Core%20Team%20.%20R%20Foundation%20for%20Statistical%20Computing;%202020.%20R:%20A%20Language%20and%20Environment%20for%20Statistical%20Computing.)\]]
-   [[14.]O'Donoghue S.I., Baldi B.F., Clark S.J., Darling A.E.,
    Hogan J.M., Kaur S., Maier-Hein L., McCarthy D.J., Moore W.J.,
    Stenau E. Visualization of biomedical data. Annu. Rev. Biomed. Data
    Sci. 2018;1:275--304. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Annu.%20Rev.%20Biomed.%20Data%20Sci.&title=Visualization%20of%20biomedical%20data&author=S.I.%20O%E2%80%99Donoghue&author=B.F.%20Baldi&author=S.J.%20Clark&author=A.E.%20Darling&author=J.M.%20Hogan&volume=1&publication_year=2018&pages=275-304&)\]]
-   [[15.]Wilke C.O. O'Reilly Media; 2019. Fundamentals of Data
    Visualization: A Primer on Making Informative and Compelling
    Figures. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Wilke%20C.O.%20O%E2%80%99Reilly%20Media;%202019.%20Fundamentals%20of%20Data%20Visualization:%20A%20Primer%20on%20Making%20Informative%20and%20Compelling%20Figures.)\]]
-   [[16.]Lane D.M., Sándor A. Designing better graphs by
    including distributional information and integrating words, numbers,
    and images. Psychol. Methods. 2009;14:239--257. doi:
    10.1037/a0016620.
    \[[DOI](https://doi.org/10.1037/a0016620)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/19719360/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Psychol.%20Methods&title=Designing%20better%20graphs%20by%20including%20distributional%20information%20and%20integrating%20words,%20numbers,%20and%20images&author=D.M.%20Lane&author=A.%20S%C3%A1ndor&volume=14&publication_year=2009&pages=239-257&pmid=19719360&doi=10.1037/a0016620&)\]]
-   [[17.]Streit M., Gehlenborg N. Bar charts and box plots.
    Nat. Methods. 2014;11:117. doi: 10.1038/nmeth.2807.
    \[[DOI](https://doi.org/10.1038/nmeth.2807)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/24645191/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Nat.%20Methods&title=Bar%20charts%20and%20box%20plots&author=M.%20Streit&author=N.%20Gehlenborg&volume=11&publication_year=2014&pages=117&pmid=24645191&doi=10.1038/nmeth.2807&)\]]
-   [[18.]Annesley T.M. Bars and pies make better desserts than
    figures. Clin. Chem. 2010;56:1394--1400. doi:
    10.1373/clinchem.2010.152298.
    \[[DOI](https://doi.org/10.1373/clinchem.2010.152298)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/20663963/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Clin.%20Chem.&title=Bars%20and%20pies%20make%20better%20desserts%20than%20figures&author=T.M.%20Annesley&volume=56&publication_year=2010&pages=1394-1400&pmid=20663963&doi=10.1373/clinchem.2010.152298&)\]]
-   [[19.]Tukey J.W. vol. 2. Addison-Wesley; 1977. (Exploratory
    Data Analysis). \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Tukey%20J.W.%20vol.%202.%20Addison-Wesley;%201977.%20(Exploratory%20Data%20Analysis).)\]]
-   [[20.]Borkin M.A., Vo A.A., Bylinskii Z., Isola P.,
    Sunkavalli S., Oliva A., Pfister H. What makes a visualization
    memorable? IEEE Trans. Vis. Comput. Graph. 2013;19:2306--2315. doi:
    10.1109/TVCG.2013.234.
    \[[DOI](https://doi.org/10.1109/TVCG.2013.234)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/24051797/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=IEEE%20Trans.%20Vis.%20Comput.%20Graph.&title=What%20makes%20a%20visualization%20memorable?&author=M.A.%20Borkin&author=A.A.%20Vo&author=Z.%20Bylinskii&author=P.%20Isola&author=S.%20Sunkavalli&volume=19&publication_year=2013&pages=2306-2315&pmid=24051797&doi=10.1109/TVCG.2013.234&)\]]
-   [[21.]Spence I., Kutlesa N., Rose D.L. Using color to code
    quantity in spatial displays. J. Exp. Psychol. Appl.
    1999;5:393--412. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=J.%C2%A0Exp.%20Psychol.%20Appl.&title=Using%20color%20to%20code%20quantity%20in%20spatial%20displays&author=I.%20Spence&author=N.%20Kutlesa&author=D.L.%20Rose&volume=5&publication_year=1999&pages=393-412&)\]]
-   [[22.]Harrower M., Brewer C.A. Colorbrewer.org: an online
    tool for selecting colour schemes for maps. Cartogr. J.
    2003;40:27--37. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Cartogr.%20J.&title=Colorbrewer.org:%20an%20online%20tool%20for%20selecting%20colour%20schemes%20for%20maps&author=M.%20Harrower&author=C.A.%20Brewer&volume=40&publication_year=2003&pages=27-37&)\]]
-   [[23.]Krzywinski M., Altman N.S. Points of significance:
    error bars. Nat. Methods. 2013;10:921--922. doi: 10.1038/nmeth.2659.
    \[[DOI](https://doi.org/10.1038/nmeth.2659)\]
    \[[PubMed](https://pubmed.ncbi.nlm.nih.gov/24161969/)\]
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Nat.%20Methods&title=Points%20of%20significance:%20error%20bars&author=M.%20Krzywinski&author=N.S.%20Altman&volume=10&publication_year=2013&pages=921-922&pmid=24161969&doi=10.1038/nmeth.2659&)\]]
-   [[24.]Tufte E.R. Graphics Press; 2006. Beautiful Evidence.
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?Tufte%20E.R.%20Graphics%20Press;%202006.%20Beautiful%20Evidence.)\]]
-   [[25.]Gelman A., Pasarica C., Dodhia R. Let's practice what
    we preach: turning tables into graphs. Am. Stat. 2002;56:121--130.
    \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Am.%20Stat.&title=Let%E2%80%99s%20practice%20what%20we%20preach:%20turning%20tables%20into%20graphs&author=A.%20Gelman&author=C.%20Pasarica&author=R.%20Dodhia&volume=56&publication_year=2002&pages=121-130&)\]]
-   [[26.]Spence I., Lewandowsky S. Displaying proportions and
    percentages. Appl. Cogn. Psychol. 1991;5:61--77. \[[Google
    Scholar](https://scholar.google.com/scholar_lookup?journal=Appl.%20Cogn.%20Psychol.&title=Displaying%20proportions%20and%20percentages&author=I.%20Spence&author=S.%20Lewandowsky&volume=5&publication_year=1991&pages=61-77&)\]]

------------------------------------------------------------------------

Articles from Patterns are provided here courtesy of **Elsevier**

![Close](/static/img/usa-icons/close.svg)

## ACTIONS

    .width-3 .height-3} [View on publisher site]](https://doi.org/10.1016/j.patter.2020.100141)
    .width-3 .height-3} [PDF (940.4 KB)]](pdf/main.pdf)
    .width-3 .height-3} [Cite]
    .width-3 .height-3 .usa-icon--bookmark-full}
    .width-3 .height-3 .usa-icon--bookmark-empty}
    [Collections]
    .width-3 .height-3} [Permalink]

    ## PERMALINK

    [Copy]

## RESOURCES

### Similar articles

### Cited by other articles

### Links to NCBI Databases

## Cite

.width-3 .height-3}

    .width-3 .height-3} Copy

    .width-3 .height-3} [Download .nbib] [.nbib]](# "Download a file for external citation management software")

-   :::
    Format: AMA APA MLA NLM

## Add to Collections

Create a new collection

Add to an existing collection

Name your collection \*

Choose a collection

Unable to load your collection due to an error\
[Please try again](#)

Add

Cancel

Follow NCBI

[NCBI on X (formerly known as
Twitter)]](https://twitter.com/ncbi)
[NCBI on
Facebook]](https://www.facebook.com/ncbi.nlm)
[NCBI on
LinkedIn]](https://www.linkedin.com/company/ncbinlm)
[NCBI on
GitHub]](https://github.com/ncbi)
[NCBI RSS
feed]](https://ncbiinsights.ncbi.nlm.nih.gov/)

Connect with NLM

[NLM on X (formerly known as
Twitter)]](https://twitter.com/nlm_nih)
[NLM on
Facebook]](https://www.facebook.com/nationallibraryofmedicine)
[NLM on
YouTube]](https://www.youtube.com/user/NLMNIH)

[National Library of Medicine\
8600 Rockville Pike\
Bethesda, MD
20894](https://www.google.com/maps/place/8600+Rockville+Pike,+Bethesda,+MD+20894/%4038.9959508,%0A%20%20%20%20%20%20%20%20%20%20%20%20-77.101021,17z/data%3D!3m1!4b1!4m5!3m4!1s0x89b7c95e25765ddb%3A0x19156f88b27635b8!8m2!3d38.9959508!%0A%20%20%20%20%20%20%20%20%20%20%20%204d-77.0988323)

-   [Web Policies](https://www.nlm.nih.gov/web_policies.html)
-   [FOIA](https://www.nih.gov/institutes-nih/nih-office-director/office-communications-public-liaison/freedom-information-act-office)
-   [HHS Vulnerability
    Disclosure](https://www.hhs.gov/vulnerability-disclosure-policy/index.html)

```
<!-- -->
```
-   [Help](https://support.nlm.nih.gov/)
-   [Accessibility](https://www.nlm.nih.gov/accessibility.html)
-   [Careers](https://www.nlm.nih.gov/careers/careers.html)

-   [NLM](https://www.nlm.nih.gov/)
-   [NIH](https://www.nih.gov/)
-   [HHS](https://www.hhs.gov/)
-   [USA.gov](https://www.usa.gov/)

Back to Top
.order-0}
