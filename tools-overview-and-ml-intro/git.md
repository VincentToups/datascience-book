Git
===

Version control is much, much more than just a backup of your repository.

The fundamental technology beneath version control is the patch/diff utility.

For one thing, it can give us a very detailed history of a project:

```bash 
git log -n 10 --stat | cat
```
All that can be intimidating when you first look at it, but consider this:

```text file=version1.txt
To be, or not to be, that is the question:
Whether 'tis nobler in the mind to suffer
The slings and arrows of outrageous fortune,
Or to take arms against a sea of troubles
And by opposing end them. To die—to sleep,
No more; and by a sleep to say we end
The heart-ache and the thousand natural shocks
That flesh is heir to: 'tis a consummation
Devoutly to be wish'd. To die, to sleep—
To sleep—perchance to dream: ay, there's the rub,
For in that sleep of death what dreams may come,
When we have shuffled off this mortal coil,
Must give us pause—there's the respect
That makes calamity of so long life.
For who would bear the whips and scorns of time,
Th'oppressor's wrong, the proud man's contumely,
The pangs of dispriz'd love, the law's delay,
The insolence of office, and the spurns
That patient merit of th'unworthy takes,
When he himself might his quietus make
With a bare bodkin? Who would fardels bear,
To grunt and sweat under a weary life,
But that the dread of something after death,
The undiscovere'd country, from whose bourn
No traveller returns, puzzles the will,
And makes us rather bear those ills we have,
Than fly to others that we know not of?
Thus conscience does make cowards of us all,
And thus the native hue of resolution
Is sicklied o'er with the pale cast of thought,
And enterprises of great pitch and moment
With this regard their currents turn awry
And lose the name of action.
```
```text file=version2.txt
To be, or not to be, that is the question:
Whether 'tis nobler in the heart to suffer
The slings and arrows of outrageous fortune,
Or to take up arms against a sea of troubles
And by opposing end them. To die—to sleep—
No more; and by a sleep to say we end
The heart-ache and the thousand natural shocks
That flesh is heir to: 'tis a consummation
Devoutly to be wish'd. To die, to sleep—
To sleep—perchance to dream: ay, there's the rub,
For in that sleep of death what dreams may come,
When we have shuffled off this mortal coil,
Must give us pause—there's the respect
That makes calamity of so long life.
For who would bear the whips and scorns of time,
Th'oppressor's wrong, the proud man's contumely,
The pangs of dispriz'd love, the law's delay,
The insolence of office, and the spurns
That patient merit of th'unworthy takes,
When he himself might his quietus make
With a bare bodkin? Who would fardels bear,
To grunt and sweat under a weary life,
But that the dread of something after death,
The undiscover'd country, from whose bourn
No traveller returns, puzzles the will,
And makes us rather bear those ills we have,
Than fly to others that we know not of?
Thus conscience does make cowards of us all,
And thus the native hue of resolution
Is sicklied o'er with the pale cast of thought,
And enterprises of great pith and moment
With this regard their current turn awry
And lose the name of action.

```
```bash file=showdiff.sh
diff -u version2.txt version1.txt
```
If you use git, you eventually have this level of granular understanding of what
your code has done over time. Extremely valuable for both understanding a new
codebase and maintaining an old one.

Knowing how to use your version control can be the difference between hours
or days of debugging and minutes.

Now let's talk about ::makefiles:Makefiles::.

:student-select:Have you ever saved multiple versions of a file (e.g., report_v1, report_v2)? How did you keep track?; ../students.json::
:student-select:Have you used any version control tool before (yes/no/unsure)?; ../students.json::
