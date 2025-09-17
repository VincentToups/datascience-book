Git In Depth
============

Git is a tool which rewards deep understanding. The good news is that
it's not too hard to understand if we allow ourselves the time to think
about it.

Some vocabulary:

1. git - a version control system. It allows us to do all sorts of
   things with the history of our project: track it, modify it, time
   travel, branch along different lines. Git is given to us as a
   binary executable on our system somewhere and uses the sub-command
   pattern, so we invoke different functionality with different
   sub-commands.
2. sub-command - many Unix tools have a `command subcommand` style
   where functionality is grouped under various categories accessed by
   naming a sub-command. The sub-commands themselves act like their own 
   commands with their own help, command line switches, etc.
3. commit - a snapshot of our project at a specific state. We create
   commits manually. It might seem easier to imagine a system which snapshots
   automatically, but this would capture a lot of noise.
4. branch - a linear series of commits. We are almost always "on a
   branch" which just means that git automatically tracks which commit
   is the head of the branch when we make commits. 
   
   A branch is fundamentally just a pointer to a commit with a name
   that is updated each time we make a commit. Branches are thus
   cheap - we may make as many as we want and we can even delete them
   freely, since a branch just _points to_ a commit. Deleting a branch
   doesn't delete commits, generally. 
5. diff - diff is a command-line utility which encodes differences
   between files in a way that is both human-readable and machine
   usable. It also refers to the file or text that diff produces. When
   we work with git we are dealing with diffs in this sense.
6. patch - the more proper term for the text produced by the tool
   diff.  Key idea: each commit is a "patch" describing how we
   transformed the code from the previous state to the next state.
7. working copy/the tree - strictly speaking, the files we are
   actually looking at and editing are the working copy or tree. The
   git repository itself, the history, etc., is stored in the .git
   directory.
8. the staging area: the place where we use git to construct the patch
   that will become the next commit.
   
Fundamentally, the patch is the key idea in git. We do not even really
need git to ::02_diff_patch:understand the idea::.


:student-select:Q; ../students.json::
