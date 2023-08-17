result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.split(',').map{|y| y.split('-') }.map{|a, b| (a..b).to_a } } 
 .filter{|x,y| (x - y).empty? or (y - x).empty? }
 .count

puts(result)
