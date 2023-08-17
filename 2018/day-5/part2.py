import re

def input():
  line = None
  with open("input.txt") as input:
    line = input.readlines()[0]
  return line

original_polymer_chain = input()

def polymers_react(a,b):
  return abs(ord(a) - ord(b)) == 32

def single_reduction_pass(polymer_chain):
  last_polymer = None
  for polymer in polymer_chain:
    if not last_polymer:
      last_polymer = polymer
    elif polymers_react(last_polymer, polymer):
      last_polymer = None
    else:
      yield last_polymer
      last_polymer = polymer

  if last_polymer:
    yield last_polymer

def reduce_polymers(polymer_chain):
  while True:
    new_polymer_chain = "".join([x for x in single_reduction_pass(polymer_chain)])
    if len(new_polymer_chain) == len(polymer_chain):
      return new_polymer_chain
    polymer_chain = new_polymer_chain

def aggressive_reduce_polymers(polymer_chain, pairs):
  smallest_polymer = None
  smallest_size = len(polymer_chain)
  for p in pairs:
    print(f'removing "{p}"')
    stripped_polymer = re.sub(p, "", polymer_chain)
    reduced_polymer = reduce_polymers(stripped_polymer)
    print(len(reduced_polymer))
    if len(reduced_polymer) < smallest_size:
      smallest_size = len(reduced_polymer)
      smallest_polymer = reduced_polymer

  return smallest_polymer


assert(polymers_react("a", "A") == True)
assert(polymers_react("a", "a") == False)
assert(polymers_react("R", "s") == False)

assert(reduce_polymers("aA") == "")
assert(reduce_polymers("abAB") == "abAB")
assert(reduce_polymers("aabAAB") == "aabAAB")


assert(reduce_polymers("abBA") == "")
assert(reduce_polymers("dabAcCaCBAcCcaDA") == "dabCBAcaDA")

pairs = ["A|a", "B|b", "C|c", "D|d", "E|e", "F|f", "G|g", "H|h", "I|i", "J|j", "K|k", "L|l", "M|m", "N|n", "O|o", "P|p", "Q|q", "R|r", "S|s", "T|t", "U|u", "V|v", "W|w", "X|x", "Y|y", "Z|z"]
assert(aggressive_reduce_polymers("dabAcCaCBAcCcaDA", pairs) == "daDA")

reduced_original_polymer = aggressive_reduce_polymers(original_polymer_chain, pairs)

print(reduced_original_polymer)
print(len(reduced_original_polymer))

