sample_input_lines = """35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576""".split('\n')
sample_code = [int(x.strip()) for x in sample_input_lines]

def any_two_can_sum(l, target):
  combos = [(x,y) for x in l for y in l if x != y] 
  for c1,c2 in combos:
    if c1+c2 == target:
      return True

  return False

def first_that_does_not_fit(l, preamble_size):
  r = range(0,len(l)-preamble_size)

  for x in r:
    n = l[x:x+preamble_size]
    v = l[x+preamble_size]
    if not any_two_can_sum(n,v):
      return v

  return None

def generate_subsets(s):
  for x in range(0, len(s)):
    yield s[0:x]

def subset_sum_that_adds_up_to_value(l, value):
  max_sublist = l[0:l.index(value)]

  for x in range(0,len(max_sublist)):
    for r in generate_subsets(max_sublist[x:]):
      s = sum(r)
      if s == value:
        r.sort()
        return r[0] + r[-1]
      elif s > value:
        break

  return None

def test_any_two_can_sum():
  l = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
  assert(True == any_two_can_sum(l, 26))
  assert(True == any_two_can_sum(l, 49))
  assert(False == any_two_can_sum(l, 100))
  assert(False == any_two_can_sum(l, 50))


def test_first_that_does_not_fit_preamble():
  assert(127 == first_that_does_not_fit(sample_code, 5))

def test_subet_sum_that_adds_up_to_value():
  x = subset_sum_that_adds_up_to_value(sample_code, 127)
  print(x)
  assert(62 == subset_sum_that_adds_up_to_value(sample_code, 127))

test_any_two_can_sum()
test_first_that_does_not_fit_preamble()
test_subet_sum_that_adds_up_to_value()

input = open("input.txt", "r").readlines()
codes =  [int(x.strip()) for x in input]

def part1():
  return first_that_does_not_fit(codes, 25)

def part2():
  return subset_sum_that_adds_up_to_value(codes, 23278925)

print(part1())
print(part2())
