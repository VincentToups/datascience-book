A simple web server
===================

For various reasons not worth getting into  here (having to do with security) our browser will
be much more accomodating to us if we start a web server (from which we can load csvs, html, js, etc). 

Luckily, with the right library, this is a one liner:

``` R
servr::httd(".", port=8000, browser=FALSE)
```
[http://localhost:8000](http://localhost:8000)
We can host our very first HTML page:

``` html file=hello_world.html openable

```
[http://localhost:8000/hello_world.html](http://localhost:8000/hello_world.html)

If you are running the book software you can just open the page up by clicking the button.

Now that we have the ability to load a page, let's ::07_d3:start working on it::.