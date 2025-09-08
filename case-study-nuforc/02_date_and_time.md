Dates and Time
==============

Dates and times are abstract encodings of calendar and clock information. They combine at least three layers:  
1. **Calendar date** (year, month, day) drawn from some convention such as the Gregorian calendar.  
2. **Clock time** (hours, minutes, seconds) representing position within a day.  
3. **Time zone or offset** giving context relative to a global reference (usually UTC).  

In **R**, these abstractions are handled by distinct classes:  
- `Date`: represents calendar dates without times, stored internally as the number of days since 1970-01-01.  
- `POSIXct`: represents date-times as seconds since 1970-01-01 00:00:00 UTC, a linear numeric scale.  
- `POSIXlt`: represents date-times as a list of calendar fields (year, month, day, etc.), more verbose but convenient for extraction.  

Formatting and parsing are controlled with `strftime`/`strptime`-style patterns, and time zones can be set explicitly or assumed from the system default.

If you want to drive yourself insane try to think about how these formats deal with timezone,
daylight savings time, leap years and seconds, etc.

:student-select:What do you expect the distribution of sightings as a function of hour to look like?;../students.json::
:student-select:What do you expect the distribution of sightings as a function of month to look like?;../students.json::

I knew someone who wrote software for running information systems on airplanes where the plane could take off in one timezone and land in another, which might even make the day go backwards.

https://en.wikipedia.org/wiki/The_Island_of_the_Day_Before

All the confusion over date and time derives from the fact that time is a purely local concept. 

```R file=basic_exploration.R start="^nth" end="^log"
```

Some notes about this result:

![](figures/time_diagnostics.png)

This looks like we'd expect it to look - days are distributed like we expect and we even see 
approximation banding in both day and minute. Hour is distributed as we expect. 

Now let's deal ::other_columns:with the other columns::.

