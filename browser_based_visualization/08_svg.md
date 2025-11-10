A Simple 2D Scatter Plot
========================

Let's start with a simple 2d scatter plot.

``` html openable
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>D3 Scatter</title>
</head>
<body>
  <svg width="500" height="500"></svg>

  <script type="module">
    import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";

    const width = 500, height = 500;
    const svg = d3.select("svg");

    const numerical_columns = ["intelligence","strength","speed","durability","energy projection","fighting skills"];
    const convert_to_number = (d,key) => d[key] = +d[key];

    d3.csv("source_data/tidy_wide_characters.csv", row => {
      numerical_columns.forEach(k => convert_to_number(row, k));
      return row;
    }).then(data => {
      const x = d3.scaleLinear()
                  .domain(d3.extent(data, d => d.intelligence))
                  .range([20, width - 20]);
      const y = d3.scaleLinear()
                  .domain(d3.extent(data, d => d.strength))
                  .range([height - 20, 20]);

      svg.selectAll("circle")
         .data(data)
         .join("circle")
         .attr("cx", d => x(d.intelligence))
         .attr("cy", d => y(d.strength))
         .attr("r", 3)
         .attr("fill", "black");
    }).catch(console.error);
  </script>
</body>
</html>

```
If you look at that you will see it stinks. We could do the thing where we randomize the points, but let's instead do something else. Let's make rectangles and make a heatmap.

``` html openable
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>D3 Scatter 0–6 Viewport</title>
</head>
<body>
  <svg width="500" height="500" viewBox="0 0 6 6" preserveAspectRatio="xMidYMid meet"></svg>

  <script type="module">
    import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";

    const svg = d3.select("svg");

    const cols = ["intelligence","strength","speed","durability","energy projection","fighting skills"];
    const toNum = (d,k) => d[k] = +d[k];

    d3.csv("source_data/tidy_wide_characters.csv", row => {
      cols.forEach(k => toNum(row, k));
      return row;
    }).then(data => {
      svg.selectAll("circle")
         .data(data)
         .join("circle")
         .attr("cx", d => d.intelligence - Math.random())
         .attr("cy", d => 6 - (d.strength - Math.random()))  // flip y-axis visually
         .attr("r", 0.05)
         .attr("fill", "black");
    }).catch(console.error);
  </script>
</body>
</html>

```
``` html openable
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>D3 Scatter with Jitter & Axes</title>
</head>
<body>
  <svg width="500" height="500" viewBox="-1 -1 8 8" preserveAspectRatio="xMidYMid meet"></svg>

  <script type="module">
    import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";

    const svg = d3.select("svg");

    const cols = ["intelligence","strength","speed","durability","energy projection","fighting skills"];
    const toNum = (d, k) => d[k] = +d[k];

    // Helper: jitter value in [0,6] by up to ±0.5, clamped
    const jitter = v => v - Math.random()

    d3.csv("source_data/tidy_wide_characters.csv", row => {
      cols.forEach(k => toNum(row, k));
      return row;
    }).then(data => {
      // Points (intelligence vs strength), jittered
      svg.selectAll("circle")
         .data(data)
         .join("circle")
         .attr("cx", d => (jitter(d.intelligence)))
         .attr("cy", d => (jitter(d.strength)))
         .attr("r", 0.08)
         .attr("fill", "black");

      // Labels
      svg.append("text")
         .attr("x", 3)
         .attr("y", -0.7)
         .attr("text-anchor", "middle")
         .attr("font-size", 0.25)
         .text("Intelligence");

      svg.append("text")
         .attr("x", -0.7)
         .attr("y", 3)
         .attr("text-anchor", "middle")
         .attr("font-size", 0.25)
         .attr("transform", "rotate(-90,-0.7,3)")
         .text("Strength");
    }).catch(console.error);
  </script>
</body>
</html>

```
Now we can do something that makes d3 really shine - lets show ::09_transitions:transitions::.
