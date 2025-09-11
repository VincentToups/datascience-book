:student-select:Pick a student.; ../students.json::

For an overview, see ::table_of_contents:Table of Contents::

# Foreground and Background Processes

It is possible to launch a command in "the background". Let's look at a
silly example.

The command "sleep" just waits for a specified number of seconds before
completing:

```bash 
sleep 10 # sleep for ten seconds
```

If you want to access the console again you have two choices: if you
press CTRL-c (the control key and "c" at the same time) you will send
the process the "kill" signal. Sometimes this will fail however, if the
process has gone really rogue.

Another possibility is to press CTRL-z, which *stops* the process and
gives you control. The process isn't dead, though, just frozen. When you
stop a process like this the terminal prints out an ID:

```bash 
> sleep 10 # sleep for ten seconds
CTRL-z
[1]+  Stopped                 sleep 100
> 
```

You can now either re-foreground the process via

```bash 
> fg 1
```

OR you can "background" the process:

```bash 
> bg 1
```

Note that backgrounding a process won't stop it from printing to your
terminal, which can be very disruptive. These process management
functions were designed for the old days when you'd interface with a
mainframe via a single "dumb" terminal (imagine a green glowing screen).

Nowadays you can start as many terminals as you want and, indeed, most
terminal programs allow you to keep many tabs open. Don't be afraid to
use them.

Next, we’ll look at process IDs and killing processes: ::process_ids_and_killing:Process IDs and Killing::
