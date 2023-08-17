p File.open("input.txt")
 .each_line
 .lazy
 .map(&:to_i)
 .chunk_while{|x,y| x != 0 }
 .map(&:sum)
 .max
