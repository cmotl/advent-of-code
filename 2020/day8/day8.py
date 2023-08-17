import re

def extract_instruction(x):
  i,v = re.split(" ", x)
  return (i, int(v))

def create_state(a,i,c=False):
  return {
    'accumulator': a,
    'instruction_counter': i,
    'completed': c
  }

def execute_instruction(state, instruction):
  accumulator = state['accumulator']
  instruction_counter = state['instruction_counter'] + 1

  operand, value = instruction
  if operand == 'acc':
    accumulator += value
  if operand == 'jmp':
    instruction_counter = state['instruction_counter'] + value

  return create_state(accumulator, instruction_counter)

def termiate_at_second_instruction(instruction_cache, state):
  executed_instructions = set()
  
  while(True):
    next_instruction = state['instruction_counter']
    if next_instruction in executed_instructions:
      return state

    if next_instruction == len(instruction_cache):
      state['completed'] = True
      print(state)
      return state

    state = execute_instruction(state, instruction_cache[next_instruction])
    executed_instructions.add(next_instruction)

  return state

def swap_instruction(i):
  op, val = i

  op_swap = {
    'acc': 'acc',
    'jmp':'nop',
    'nop':'jmp'
  }

  return (op_swap[op], val)

def mutated_caches(cache):
  for i in range(0,len(cache)):
    a = cache[:i]
    b = swap_instruction(cache[i])
    c= cache[i+1:]
    yield a + [b] + c

def find_terminating_instruction_mutation(instuction_cache, initial_state):
  for cache in mutated_caches(instuction_cache):
    final_state = termiate_at_second_instruction(cache, initial_state)
    if final_state['completed']:
      return final_state

sample_input_lines = """nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6""".split('\n')
sample_instruction_cache =[extract_instruction(x.strip()) for x in sample_input_lines]

def test_extract_instruction():
  assert(("jmp",4) == extract_instruction("jmp +4"))
  assert(("acc",-99) == extract_instruction("acc -99"))

def test_nop_instruction():
  initial_state = create_state(0, 0)
  expected = create_state(0, 1)
  assert(expected == execute_instruction(initial_state, ("nop", 0)))

def test_acc_instruction():
  initial_state = create_state(0, 0)
  expected = create_state(10, 1)
  assert(expected == execute_instruction(initial_state, ("acc", 10)))

def test_jmp_instruction():
  initial_state = create_state(10, 5)
  expected = create_state(10, 10)
  assert(expected == execute_instruction(initial_state, ("jmp", 5)))

def test_terminate_at_second_execution():
  initial_state = create_state(0, 0)
  expected_state = create_state(5, 1)
  assert(expected_state == termiate_at_second_instruction(sample_instruction_cache, initial_state))

def test_can_complete_execution():
  modified_instruction_cache = sample_instruction_cache[:7] + [ swap_instruction(sample_instruction_cache[7]) ] + sample_instruction_cache[8:]
  initial_state = create_state(0, 0)
  expected_state = create_state(8, 9, True)
  assert(expected_state == termiate_at_second_instruction(modified_instruction_cache, initial_state))

def test_swap_instruction():
  assert(("acc", 10) == swap_instruction(("acc",10)))
  assert(("nop", 10) == swap_instruction(("jmp",10)))
  assert(("jmp", 10) == swap_instruction(("nop",10)))

def test_mutated_instructions():
  cache = [ ("acc",10), ("jmp",10), ("nop",10) ]
  
  mutated_cache = mutated_caches(cache)
  assert([ ("acc",10), ("jmp",10), ("nop",10) ] == next(mutated_cache))
  assert([ ("acc",10), ("nop",10), ("nop",10) ] == next(mutated_cache))
  assert([ ("acc",10), ("jmp",10), ("jmp",10) ] == next(mutated_cache))

test_extract_instruction()
test_nop_instruction()
test_acc_instruction()
test_jmp_instruction()
test_terminate_at_second_execution()
test_swap_instruction()
test_mutated_instructions()
test_can_complete_execution()


input = open("input.txt", "r").readlines()
instruction_cache =  [extract_instruction(x.strip()) for x in input]

def part1():
  return termiate_at_second_instruction(instruction_cache, create_state(0,0))['accumulator']

def part2():
  return find_terminating_instruction_mutation(instruction_cache, create_state(0,0))['accumulator']

print(part1())
print(part2())
