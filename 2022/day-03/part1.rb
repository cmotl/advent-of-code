priorities = ['_'] + ('a'..'z').to_a + ('A'..'Z').to_a

result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.chars.each_slice(x.length / 2).reduce(:&).first }
 .map{|x| priorities.find_index(x) }
 .sum

puts(result)
