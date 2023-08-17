
monkey0 = {
  :items => [79, 98],
  :operation => lambda {|worry_level| worry_level * 19},
  :test => lambda {|value| value%23 == 0 ? 2 : 3 },
  :total_inspections => 0
}

monkey1 = {
  :items => [54, 65, 75, 74],
  :operation => lambda {|worry_level| worry_level + 6},
  :test => lambda {|value| value%19 == 0 ? 2 : 0 },
  :total_inspections => 0
}

monkey2 = {
  :items => [79, 60, 97],
  :operation => lambda {|worry_level| worry_level * worry_level},
  :test => lambda {|value| value%13 == 0 ? 1 : 3 },
  :total_inspections => 0
}

monkey3 = {
  :items => [74],
  :operation => lambda {|worry_level| worry_level + 3},
  :test => lambda {|value| value%17 == 0 ? 0 : 1 },
  :total_inspections => 0
}

$monkeys = [monkey0, monkey1, monkey2, monkey3]

def inspect_item(monkey, item) 
  new_worry_level = ((monkey[:operation]).call(item) / 3).to_i
  toss_to_monkey = monkey[:test].call(new_worry_level)
  $monkeys[toss_to_monkey][:items] << new_worry_level
end

def monkey_inspection(monkey) 
  monkey[:total_inspections] += monkey[:items].length
  monkey[:items].each{|item| inspect_item(monkey, item) }
  monkey[:items].clear
end

print(monkey0); puts
print(monkey1); puts
print(monkey2); puts
print(monkey3); puts
puts

20.times {
  $monkeys.each{|m| monkey_inspection(m) }
}

print(monkey0); puts
print(monkey1); puts
print(monkey2); puts
print(monkey3); puts

puts($monkeys.map{|m| m[:total_inspections] }.sort.max(2).reduce(&:*))

