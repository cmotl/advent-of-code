result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.split(',').map{|y| y.split('-') }.map{|a, b| (a..b) } } 
 .reject{|x| x.map(&:to_a).reduce(:&).empty? }
 .count

puts(result)
