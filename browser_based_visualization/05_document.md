The Document
============

The browser began as a document display engine. You wrote by hand HTML and the
document was rendered by the browser and you can still do this.

An HTML document is a (nested) collection of HTML elements, each of which belongs
to a finite set of types, called tags.

Here at some common ones:

1. html: the tag denoting an html document
2. header: a tag enclosing meta-data and other miscellania
3. body: the tag indicating the main displayed content of the document
4. span: a tag indicating a subset of a document that doesn't change the way the text flows
5. div: a tag indicating a "block" of the document, rendered as block rather than inline.
6. hN (h1, h2, h3, ...) : a header of a given level. Larger numbers mean smaller headers.
7. p: a paragraph
8. em: <em>emphasis</em>
9. i: <i>italics</i>
10. b: bold <b>bold</b>
11. table: a tag denoting that its contents are a table
12. th: table header
13. tr: table row
14. td: table data (one cell)
15. svg: a "scalable vector graphics" element: a special sub-document for showing images made up of shapes! Useful for visualization!
16. canvas: an element for drawing pixels: useful for very high performance visualization. Harder to work with. 
17. script: tags which either container or point to javascript code to run

There are quite a lot of other HTML elements, but as HTML evolved over time usage gravitated towards almost
exclusively using <div> and <span> tags as using stylesheets to appropriately style them.

Javascript can access and modify the document by accessing the document object in code.

Since we often will use svg:

1. **svg** — the root tag of an SVG document or fragment; defines the coordinate system and viewport.  
2. **g** — a grouping element; lets you transform or style multiple child shapes together.  
3. **rect** — a rectangle, defined by `x`, `y`, `width`, and `height` attributes.  
4. **circle** — a circle, defined by `cx`, `cy`, and `r` (radius).  
5. **ellipse** — an ellipse, defined by `cx`, `cy`, `rx`, and `ry`.  
6. **line** — a straight line from (`x1`, `y1`) to (`x2`, `y2`).  
7. **polyline** — a series of connected straight lines, defined by a list of points.  
8. **polygon** — like `polyline`, but automatically closed and filled.  
9. **path** — a general-purpose shape defined by a compact *path data string* (`d="M10 10 L50 50 Z"`) that can draw lines, curves, and arcs.  
10. **text** — a text element; supports positioning, styling, and even path-based layout.  
11. **tspan** — a sub-span within a `text` element, for finer control of positioning or style.  
12. **image** — embeds a raster image (e.g., PNG, JPEG) within SVG coordinates.  
13. **use** — references and reuses an element defined elsewhere (via `href="#id"`).  
14. **defs** — a container for reusable definitions (gradients, symbols, patterns).  
15. **symbol** — defines a reusable graphic template, often used with `<use>`.  
16. **clipPath** — defines a clipping region that hides parts of elements outside a specified shape.  
17. **mask** — defines a mask using alpha or luminance, for complex transparency effects.  
18. **pattern** — defines a tiled fill pattern (e.g., stripes, dots) usable via `fill="url(#patternId)"`.  
19. **linearGradient** — defines a gradient fill that transitions along a line.  
20. **radialGradient** — defines a gradient fill radiating from a center point.  
21. **stop** — a color stop used inside a gradient definition.  
22. **filter** — defines visual effects (blur, shadow, color shift, etc.) applied to elements.  
23. **foreignObject** — allows embedding non-SVG content (like HTML) inside an SVG document.  
24. **title** — provides an accessibility title for an SVG element (e.g., for screen readers).  
25. **desc** — adds a longer description of an element’s meaning or purpose.

If you fully digested the lessons about ggplot and the grammar of graphics your brain might be revving up! These are almost all
plausibly *geometries*. Can we implement ggplot-style visualizations in Javascript with the canvas?

We *could* but we don't need to: we have "d3".

https://d3js.org/

Getting started with d3 is surprisingly simple, but for reasons which are very boring 
and sad we need to have a ::06_server:simple web server first::.
