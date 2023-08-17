priorities = ['_'] + ('a'..'z').to_a + ('A'..'Z').to_a

result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .each_slice(3)
 .map{|x| x.map(&:chars).reduce(:&).first }
 .map{|x| priorities.find_index(x) }
 .sum

puts(result)
