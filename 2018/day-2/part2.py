from collections import defaultdict
total = 0

lines = [line for line in open("input.txt").readlines()]

with open("input.txt") as input:
    for line in input:
      for word in lines:
        differences = 0
       
        for i in range(0, len(line)):
          if word[i] != line[i]:
            differences += 1

        if differences == 1:
          print(line)
          print(word)
        

