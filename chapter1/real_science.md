<svg id="data-scientist"></svg>

```javascript browser
import {renderArcDiagram} from "/js/d3util.js"
import * as pf from "/js/puff.js"

const stages = "Design Experiment Data Analysis Claims".split(" ");

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

const connections = pf.initArray(50,
	i => {
		const first = stages[randomInt(0,stages.length-1)];
		const second = pf.filter(x => x != first, stages)[randomInt(0,stages.length-2)];
		return [first, second]
	})

console.log(connections);

console.log("Exec block.")
console.log(document.getElementById("data-scientist"))

renderArcDiagram("data-scientist",stages,
	connections,
 	{"width":0.99999, "height":240})

```

It usually looks more like the above. There are many problems with the above
from a methodological point of view. In fact, there is a real sense in which 
the above structure for scientific research undermines the epistemological
power of any claims made:

https://en.wikipedia.org/wiki/Forking_paths_problem

Basically, every time we make a decision about our analysis predicated on some
previous analysis we did, we introduce an opportunity for us to bias the result
and even if we are diligent, we can find that with enough such choices we end up
with a positive result _by chance_. 

e.g.: the Jelly Bean problem:

![](https://imgs.xkcd.com/comics/significant.png)
We will get into this when we talk about data science ethics! But for now
suffice it to say that, especially for exploratory work, we want to _at least_
carefully document our garden of forking paths so that we can evaluate, even
subjectively, whether we've been trying too hard to get a positive result.

So we actually want to turn the above into this:

<svg id="animated-data-scientist"></svg>
```javascript browser
import * as d3 from 'https://cdn.skypack.dev/d3';
import {renderAnimatedArcDiagram} from "/js/d3util.js"
import * as pf from "/js/puff.js"

const stages = "Design Experiment Data Analysis Claims".split(" ");

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

const connections = pf.initArray(50,
	i => {
		const first = stages[randomInt(0,stages.length-1)];
		const second = pf.filter(x => x != first, stages)[randomInt(0,stages.length-2)];
		return [first, second]
	})

console.log(connections);

console.log("Exec block.")
console.log(document.getElementById("data-scientist"))

renderAnimatedArcDiagram("animated-data-scientist",stages,
	connections,
 	{"width":0.99999, "height":240})

```

Which is just to say:

We want to know WHAT we did, WHEN we did it and WHY for all time, able to visit
the past and reproduce the results before and after any given change.

We will learn to do this in this class.

https://en.wikipedia.org/wiki/Git

But there is also the issue of :next:running_code:running the code at any one of
those historical moments.::
