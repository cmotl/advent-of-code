monkey0 = {
  :items => [84, 66, 62, 69, 88, 91, 91],
  :operation => lambda {|worry_level| worry_level * 11},
  :test => lambda {|value| value%2 == 0 ? 4 : 7 },
  :divisor => 2,
  :total_inspections => 0
}

monkey1 = {
  :items => [98, 50, 76, 99],
  :operation => lambda {|worry_level| worry_level * worry_level},
  :test => lambda {|value| value%7 == 0 ? 3 : 6 },
  :divisor => 7,
  :total_inspections => 0
}

monkey2 = {
  :items => [72, 56, 94],
  :operation => lambda {|worry_level| worry_level + 1},
  :test => lambda {|value| value%13 == 0 ? 4 : 0 },
  :divisor => 13,
  :total_inspections => 0
}

monkey3 = {
  :items => [55, 88, 90, 77, 60, 67],
  :operation => lambda {|worry_level| worry_level + 2},
  :test => lambda {|value| value%3 == 0 ? 6 : 5 },
  :divisor => 3,
  :total_inspections => 0
}

monkey4 = {
  :items => [69, 72, 63, 60, 72, 52, 63, 78],
  :operation => lambda {|worry_level| worry_level * 13},
  :test => lambda {|value| value%19 == 0 ? 1 : 7 },
  :divisor => 19,
  :total_inspections => 0
}

monkey5 = {
  :items => [89, 73],
  :operation => lambda {|worry_level| worry_level + 5},
  :test => lambda {|value| value%17 == 0 ? 2 : 0 },
  :divisor => 17,
  :total_inspections => 0
}

monkey6 = {
  :items => [78, 68, 98, 88, 66],
  :operation => lambda {|worry_level| worry_level + 6},
  :test => lambda {|value| value%11 == 0 ? 2 : 5 },
  :divisor => 11,
  :total_inspections => 0
}

monkey7 = {
  :items => [70],
  :operation => lambda {|worry_level| worry_level + 7},
  :test => lambda {|value| value%5 == 0 ? 1 : 3 },
  :divisor => 5,
  :total_inspections => 0
}

def inspect_item(monkeys, monkey, item) 
  new_worry_level = ((monkey[:operation]).call(item) / 3).to_i
  toss_to_monkey = monkey[:test].call(new_worry_level)
  monkeys[toss_to_monkey][:items] << new_worry_level
end

def monkey_inspection(monkeys, monkey) 
  monkey[:total_inspections] += monkey[:items].length
  monkey[:items].each{|item| inspect_item(monkeys, monkey, item) }
  monkey[:items].clear
end

monkeys = [monkey0, monkey1, monkey2, monkey3, monkey4, monkey5, monkey6, monkey7]
p 20.times
 .reduce(monkeys) {|monkeys, _| monkeys.each{|m| monkey_inspection(monkeys, m) } }
 .map{|m| m[:total_inspections] }
 .sort
 .max(2)
 .reduce(&:*)

