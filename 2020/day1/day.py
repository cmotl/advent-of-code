import itertools


input = open("input.txt", "r").readlines()
numbers = map(lambda x: int(x), input)

combinations = list(itertools.product(numbers, numbers[1:], numbers[2:]))

add_to_20 = filter(lambda x: x[0] + x[1] + x[2] == 2020, combinations)

print(add_to_20)

