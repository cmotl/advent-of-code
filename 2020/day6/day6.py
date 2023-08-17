import re

sample_input = """abc

a
b
c

ab
ac

a
a
a
a

b"""

sample_input_lines = sample_input.split('\n')

def extract_declarations(input):
  fields = []

  for x in input:
    if x == "":
      yield fields
      fields = []
    else:
      fields.append(x)

  if len(fields) is not 0:
    yield fields

input = open("input.txt", "r").readlines()
raw_declaration_data = map(lambda x: x.strip(), input)
declarations = list(extract_declarations(raw_declaration_data))

def unique_declarations_for_group(declarations):
  decs = set()
  for x in declarations:
    for d in x:
      decs.add(d)
  return decs

def unique_all_declarations_for_group(declarations):
  decs = [set(x) for x in declarations]
  return set.intersection(*decs)

def part1(declarations):
  unique_decalrations = [len(unique_declarations_for_group(x)) for x in declarations]
  return sum(unique_decalrations)

print(part1(declarations))

def part2(declarations):
  unique_decalrations = [len(unique_all_declarations_for_group(x)) for x in declarations]
  return sum(unique_decalrations)

print(part2(declarations))

def test_extract_declarations():
  assert(5 == len(list(extract_declarations(sample_input_lines))))

def test_part1():
  assert(11 == part1(list(extract_declarations(sample_input_lines))))

def test_part2():
  assert(6 == part2(list(extract_declarations(sample_input_lines))))

test_extract_declarations()
test_part1()
test_part2()
