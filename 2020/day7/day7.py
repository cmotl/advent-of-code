import re

sample_rules = """light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."""
sample_rules_lines = sample_rules.split('\n')

def bags_inside_bag(rules, target_bag):
  bags = rules[target_bag]

  count = 0
  for c,bag in bags:
    count += c + c * bags_inside_bag(rules, bag)

  return count

def contains_shiny_gold_bag(rules, target_bag):
  possible_bags = rules[target_bag]

  if 'shiny gold' in possible_bags:
    return True

  for bag in possible_bags:
    if contains_shiny_gold_bag(rules, bag):
      return True

  return False

def extract_rule_with_count(r):
  c1, c2, _, _, rest = re.split(' ', r, 4)
  bag_color = f'{c1} {c2}'
  containing_colors = []

  rest = re.split(' ', rest, 4)
  while len(rest) > 3:
    n, c1, c2, _ = rest[0], rest[1], rest[2], rest[3]
    containing_colors.append((int(n),f'{c1} {c2}'))
    if len(rest) > 4:
      rest = re.split(' ', rest[4], 4)
    else:
      break

  return {bag_color: containing_colors}
def extract_rule(r):
  c1, c2, _, _, rest = re.split(' ', r, 4)
  bag_color = f'{c1} {c2}'
  containing_colors = []

  rest = re.split(' ', rest, 4)
  while len(rest) > 3:
    n, c1, c2, _ = rest[0], rest[1], rest[2], rest[3]
    containing_colors.append(f'{c1} {c2}')
    if len(rest) > 4:
      rest = re.split(' ', rest[4], 4)
    else:
      break

  return {bag_color: containing_colors}


def test_can_not_find_depth_when_gold_bag_when_bag_contains_multiple_levels_bags():
  rules = { 'faded blue': [],
            'bright white': [],
            'muted yellow': [],
            'light red': ['bright white', 'muted yellow'] }

  assert(False == contains_shiny_gold_bag(rules, 'faded blue'))
  assert(False == contains_shiny_gold_bag(rules, 'light red'))

def test_can_find_gold_bag_when_single_bag_directly_contains_gold_bag():
  rules = { 'bright white': ['shiny gold'],
            'light red': ['bright white', 'muted_yellow'],
            'muted yellow': ['shiny gold', 'faded blue'] }

  assert(True == contains_shiny_gold_bag(rules, 'bright white'))
  assert(True == contains_shiny_gold_bag(rules, 'light red'))

def test_can_extract_rule():
  expected = {'faded blue':[]}
  raw_rule = 'faded blue bags contain no other bags'
  assert(expected == extract_rule(raw_rule))

  expected = {'light red':['bright white']}
  raw_rule = 'light red bags contain 1 bright white bag'
  assert(expected == extract_rule(raw_rule))

  expected = {'light red':['bright white', 'muted yellow']}
  raw_rule = 'light red bags contain 1 bright white bag, 2 muted yellow bags.'
  assert(expected == extract_rule(raw_rule))

def test_can_extract_rule_with_count():
  expected = {'faded blue':[]}
  raw_rule = 'faded blue bags contain no other bags'
  assert(expected == extract_rule_with_count(raw_rule))

  expected = {'light red':[(1,'bright white')]}
  raw_rule = 'light red bags contain 1 bright white bag'
  assert(expected == extract_rule_with_count(raw_rule))

  expected = {'light red':[(1,'bright white'), (2, 'muted yellow')]}
  raw_rule = 'light red bags contain 1 bright white bag, 2 muted yellow bags.'
  assert(expected == extract_rule_with_count(raw_rule))

def bags_that_can_contain_shiny_gold(all_rules):
  unique_bag_colors = list(all_rules.keys())
  return [x for x in unique_bag_colors if contains_shiny_gold_bag(all_rules, x)]

def bags_inside_shiny_gold(all_rules):
  return bags_inside_bag(all_rules, 'shiny gold')

def sample_input_test():
  rules =  [extract_rule(x.strip()) for x in sample_rules_lines]
  all_rules = {k: v for d in rules for k, v in d.items()}

  assert(4 == len(bags_that_can_contain_shiny_gold(all_rules)))

def sample_input_counts_test():
  s = """shiny gold bags contain 2 dark red bags.
  dark red bags contain 2 dark orange bags.
  dark orange bags contain 2 dark yellow bags.
  dark yellow bags contain 2 dark green bags.
  dark green bags contain 2 dark blue bags.
  dark blue bags contain 2 dark violet bags.
  dark violet bags contain no other bags.""".split('\n')

  rules =  [extract_rule_with_count(x.strip()) for x in s]
  all_rules = {k: v for d in rules for k, v in d.items()}

  assert(126 == bags_inside_shiny_gold(all_rules))
#test_can_not_find_depth_when_gold_bag_when_bag_contains_no_other_bags()
test_can_not_find_depth_when_gold_bag_when_bag_contains_multiple_levels_bags()
test_can_find_gold_bag_when_single_bag_directly_contains_gold_bag()
test_can_extract_rule()
sample_input_test()
sample_input_counts_test()

test_can_extract_rule_with_count()
  
input = open("input.txt", "r").readlines()
rules =  [extract_rule(x.strip()) for x in input]
all_rules = {k: v for d in rules for k, v in d.items()}
print(len(bags_that_can_contain_shiny_gold(all_rules)))

input = open("input.txt", "r").readlines()
count_rules =  [extract_rule_with_count(x.strip()) for x in input]
all_count_rules = {k: v for d in count_rules for k, v in d.items()}
print(bags_inside_shiny_gold(all_count_rules))
