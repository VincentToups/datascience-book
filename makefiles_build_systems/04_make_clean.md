make clean
=========

Because artifacts don’t belong in your repo, you should regularly clear them and rebuild from scratch to verify your pipeline. A simple clean target helps you do that repeatably.

Here’s a minimal Makefile with a clean task and a generic rule to deduplicate any CSV in `source_data/`:

``` Makefile file=project/Makefile ref=6c754

```
Note that we might want to create .PHONY targets for other purposes. With a
web scraper we might maintain an on-disk cache of web pages we have visited before
so that we don't make too many requests when we don't need to. We might want to
clean everything but that cache regularly, but keep the cache for the sake of
rapidly being able to re-run the scrape while developing. 

```sidebar
Note that we probably should always `rm -rf <location>` where the `-rf` stands for
"recursively" and "force", respectively. A bit non-intuitively, we need that force
to successfully delete directories even if they don't exist so that our clean tasks
are "idempotent," which just means the effect of running them more than once is
the same.
```

Our makefile might look like this then:

``` Makefile
.PHONY: clean
.PHONY: clear_http_cache

clean:
	rm -rf derived_data/*
	rm -rf logs/*
	
clear_http_cache:
    rm -rf .http_cache
    
```


Next: ::05_multiple_targets:Handle multiple outputs in a recipe::.
