import re
import itertools
import functools
import collections

pattern = re.compile(r"""\[.*:(?P<minute>\d\d)\] (?P<note>.*)""")
begin_shift_pattern = re.compile(r"""Guard #(?P<guard>\d+) .*""")
falls_asleep_pattern = re.compile(r"""falls asleep""")
wakes_up_pattern = re.compile(r"""wakes up""")

def parse_note(note):
  m = pattern.match(note)

  minute = int(m.group("minute"))
  note = m.group("note")
  return (minute, note)

sleep_notes = [x for x in open("input.txt")]
sorted_notes = sorted(sleep_notes)
parsed_notes = [parse_note(x) for x in sorted_notes]






def build_schedule(notes):
  current_guard = 0
  
  schedule = []
  asleep = 0

  for x in parsed_notes:
    m = begin_shift_pattern.match(x[1])
    if m:
      if len(schedule) > 0:
        yield (current_guard, schedule)
      schedule = []
      current_guard = int(m.group("guard"))

    elif falls_asleep_pattern.match(x[1]):
      asleep = x[0]
    elif wakes_up_pattern.match(x[1]):
      schedule.append(range(asleep, x[0]))
    else:
      print("no match")


individual_schedules = [x for x in build_schedule(parsed_notes)]

def compile_schedule(schedule):
  sleep_minutes = []
  for i in schedule:
    for x in i:
      sleep_minutes.append(x)
  return sleep_minutes



def add_schedule(a,b):
  a[b[0]].append(compile_schedule(b[1]))
  return a

schedules_by_guard = functools.reduce(add_schedule, individual_schedules, collections.defaultdict(list)),
#compiled_schedule = {key: compile_schedule(s) for key,s in guard_schedules.items()}
#print(compiled_schedule)

def asleep_minutes(schedule):
  asleep_minutes = 0
  for s in schedule:
    for minutes in s:
      asleep_minutes += 1
  return asleep_minutes

def most_asleep_guard(schedule):
  most_asleep_guard = None
  most_asleep_mintutes = 0

  for g,s in schedule[0].items():
    minutes_asleep = asleep_minutes(s)
    if minutes_asleep > most_asleep_mintutes:
      most_asleep_guard = g
      most_asleep_mintutes = minutes_asleep

  return most_asleep_guard

def most_asleep_minutes(schedule):
  minutes = collections.defaultdict(int)
  for s in schedule:
    for m in s:
      minutes[m] += 1

  print(minutes)

  most_frequent_minute = None
  most_minutes = 0
  for m,count in minutes.items():
    if count > most_minutes:
      most_frequent_minute = m
      most_minutes = count
  return most_frequent_minute


g = most_asleep_guard(schedules_by_guard)
m = most_asleep_minutes(schedules_by_guard[0][g])

print(g)
print(m)
print(g*m)
