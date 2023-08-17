require 'part1'

input = File.open("input.txt")
 .each_line
 .lazy
 .map(&:to_i)


p "Part 1 max calories: ", Part1::max_calories(input)
