from collections import defaultdict
total = 0

with open("input.txt") as input:
    two_count = 0
    three_count = 0
    for line in input:
      counts = defaultdict(lambda: 0)
      for letter in line:
        counts[letter] += 1

      count_two = False
      count_three = False
      for _,c in counts.items():
        if c == 2:
          count_two = True
        if c == 3:
          count_three = True
        
      if count_two:
        two_count += 1
      if count_three:
        three_count += 1

print(two_count)
print(three_count)
print(two_count*three_count)
