import re


def extract_policy_and_password(x):
  a,b,c,_,d = re.split("[-,:, ]", x)
  return (int(a), int(b), c, d)

def contains_at_least(minimum_occurances, instance, passcode):
  instances = len([x for x in passcode if x == instance])
  return instances >= minimum_occurances

def contains_no_more_than(maximum_occurances, instance, passcode):
  instances = len([x for x in passcode if x == instance])
  return instances <= maximum_occurances

def contains_instance_within_limits(minimum_occurances, maximum_occurances, instance, passcode):
  return contains_at_least(minimum_occurances, instance, passcode) and \
         contains_no_more_than(maximum_occurances, instance, passcode)

def part_1(policy_and_passwords):
  in_tolerance = [x for x in policy_and_passwords if contains_instance_within_limits(*x)]
  return len(in_tolerance)

def contains_instance_at_position(position, instance, passcode):
  return passcode[position-1] == instance 

def contains_instance_at_one_position(position_1, position_2, instance, passcode):
  at_position_1 = contains_instance_at_position(position_1, instance, passcode)
  at_position_2 = contains_instance_at_position(position_2, instance, passcode)

  return (at_position_1 and not at_position_2) or \
         (at_position_2 and not at_position_1)

def part_2(policy_and_passwords):
  in_tolerance = [x for x in policy_and_passwords if contains_instance_at_one_position(*x)]
  return len(in_tolerance)

input = open("input.txt", "r").readlines()
policy_and_passwords = map(lambda x: extract_policy_and_password(x), input)

print(part_1(policy_and_passwords))
print(part_2(policy_and_passwords))

def test_extarct_policy_and_password():
  assert((11, 12, 'n', 'nnndnnnnnnnn') == extract_policy_and_password('11-12 n: nnndnnnnnnnn'))

def test_contains_at_least_required_number_of_instances():
  assert(True == contains_at_least(1, 'a', 'abcde'))
  assert(True == contains_at_least(1, 'a', 'abcdea'))
  assert(False == contains_at_least(1, 'a', 'bcde'))

def test_contains_no_more_than_the_required_number_of_instances():
  assert(True == contains_no_more_than(1, 'a', 'abcde'))
  assert(True == contains_no_more_than(1, 'a', 'bcde'))
  assert(False == contains_no_more_than(1, 'a', 'abcdea'))

def test_contains_instance_within_limits():
  assert(True == contains_instance_within_limits(1, 3, 'a', 'abcde'))
  assert(False == contains_instance_within_limits(1, 3, 'b', 'cdefg'))
  assert(True == contains_instance_within_limits(2, 9, 'c', 'ccccccccc'))

def test_contains_instance_at_position():
  assert(True == contains_instance_at_position(1, 'a', 'abcde'))
  assert(False == contains_instance_at_position(2, 'a', 'abcde'))

def test_contains_instance_at_one_position():
  assert(True == contains_instance_at_one_position(1, 3, 'a', 'abcde'))
  assert(False == contains_instance_at_one_position(1, 3, 'a', 'abade'))
  assert(False == contains_instance_at_one_position(1, 3, 'a', 'bcde'))

test_extarct_policy_and_password()
test_contains_at_least_required_number_of_instances()
test_contains_no_more_than_the_required_number_of_instances()
test_contains_instance_within_limits()
test_contains_instance_at_position()
test_contains_instance_at_one_position()
