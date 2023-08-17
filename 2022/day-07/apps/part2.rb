require 'part2'

input = File.open("input.txt")
 .each_line
 .lazy
 .map(&:to_i)


p "Part 2 max calories from top 3 elves: ", Part2::max_calories(input)
