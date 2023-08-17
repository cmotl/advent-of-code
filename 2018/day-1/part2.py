frequencies = []
frequency = 0
iterations = 0

while True:
  with open("input.txt") as input:
      for line in input:
        value = int(line)
        frequency += value
        if frequency in frequencies:
          print("got it!")
          print(frequency)
          break
        frequencies.append(frequency)
  iterations+=1
  print(f'frequency: {frequency}, iterations: {iterations}')

print("didn't find")
