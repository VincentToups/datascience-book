Class Participation
===================

Class participation will be facilitated by this little widget. 

<div id="student_chooser"></div>

But what does this enigmatic widget mean?

Here is how this works:

1. if you answer the question you get your participation point, regardless of
how you answer the question. So basically if you are here and you utter
something you get your point.
2. Answers will be given a number of stars or an emoji. One star is the default
for any answer and meets your basic participation requirements. But any number
of stars in addition to that can negate a missed day of class or a failure to
answer. But emoji negate stars.

The basic idea is thus: if I call on you, do your best to answer the question
or provide a strategy for how you would answer the question if you weren't on 
the spot. This will be enough. Glib answers will force me to assign a pejorative 
emoji. You still get your participation grade, however.

Students are chosen randomly via this system in a weighted way, so if you get
unlucky and are chosen a few times in order your chances of getting chosen go 
down. 

You might be interested in how this code works. 

1. students are sorted in order of how many times they've been called on.
2. 85% of the time we select the student least recently called upon
3. 10% of the time we select a student randomly from the 50% least recently
called upon
4. 5% of the time we sample uniformly.

Here is a python simulation of the process. Assuming we ask a question every
three minutes, the thing we are interested in the is the distribution of 
the smallest interval between questions. We want this to have a high variance 
so that you have to stay on your toes!
```js browser
import {setupStudentChooser} from "/fs/book/js/student_selector.js"
setupStudentChooser("student_chooser","Why did you decided to talk this class in particular?");

```

```python 
import random
from statistics import mean

NUM_STUDENTS = 40
TOTAL_MINUTES = 60 * 60  # 6 hours
QUESTION_RATE = 3

class Student:
    def __init__(self, name):
        self.name = name
        self.chosen_times = []

    def update(self, current_time):
        self.chosen_times.append(current_time)

    def count(self):
        return len(self.chosen_times)

def choose_student(students):
    all_students = list(students.values())
    ranked = sorted(all_students, key=lambda s: s.count())
    r = random.random()

    if r < 0.85:
        return ranked[0].name  # least chosen
    elif r < 0.95:
        half = ranked[:len(ranked) // 2]  # least chosen half
        return random.choice(half).name
    else:
        return random.choice(all_students).name

# Initialize students
students = {f"Student {i+1}": Student(f"Student {i+1}") for i in range(NUM_STUDENTS)}

# Simulate class period
for minute in range(0, TOTAL_MINUTES, QUESTION_RATE):
    chosen_name = choose_student(students)
    students[chosen_name].update(minute)

# Analyze results
results = []
for student in students.values():
    times = student.chosen_times
    intervals = [t2 - t1 for t1, t2 in zip(times, times[1:])]
    count = student.count()
    if intervals:
        min_dt = min(intervals)
        max_dt = max(intervals)
        avg_dt = round(mean(intervals), 2)
    else:
        min_dt = max_dt = avg_dt = "-"
    results.append((student.name, count, min_dt, max_dt, avg_dt))

# Tabular output
print(f"{'Student':<12} {'Chosen':<6} {'Min Δt':<6} {'Max Δt':<6} {'Avg Δt':<6}")
print("-" * 42)
for row in sorted(results, key=lambda r: r[1]):
    name, count, min_dt, max_dt, avg_dt = row
    print(f"{name:<12} {count:<6} {min_dt:<6} {max_dt:<6} {avg_dt:<6}")

```
This is a good chance for us to review ::how_book:how this "book" works::.