total = 0

with open("input.txt") as input:
    for line in input:
      value = int(line)
      total += value

print(total)
