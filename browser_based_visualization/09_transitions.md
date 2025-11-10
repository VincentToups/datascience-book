The great power of d3 is that we can smoothly transition things. Here is what I mean.

But this means interactivity. Its worth noting that base HTML supports a good set of input elements:

- **text** – single-line text input  
- **password** – masked text for passwords  
- **email** – validates email addresses  
- **number** – numeric input with step controls  
- **range** – slider for numeric range  
- **date**, **time**, **datetime-local**, **month**, **week** – date/time selectors  
- **checkbox** – on/off toggle  
- **radio** – mutually exclusive options  
- **file** – file picker dialog  
- **color** – color picker input  
- **url** – validates URL input  
- **tel** – telephone number field  
- **search** – optimized text field for search  
- **hidden** – invisible field for metadata  
- **submit**, **reset**, **button** – form control buttons

Here we will just use two select boxes. 

``` html openable file=transition_example.html

```

Let's walk through this bit by bit.

``` html file=transition_example.html start=8 end=11 openable

```
Ok - so here we are creating two extra select drop down inputs. These are little widgets that we can use to select stuff.

``` html openable file=transition_example.html start=23 end=35

```
And we fill them up with the attributes from the data set. 

``` html openable file=transition_example.html start=82 end=86

```

Here is the real juice: we just add `points.transition()` isntead of just updating the attributes. The rest 
of our code is just the same as if we wanted to instantaneously update the points.

``` html openable file=transition_example.html start=92 end=103

```

And here, we use "events" attached to the select boxes to trigger the update and redraw transitions.
