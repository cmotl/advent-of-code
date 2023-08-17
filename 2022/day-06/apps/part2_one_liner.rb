p File.read("input.txt").chars
   .each_cons(14)
   .with_index
   .filter{|x, i| x.uniq.length == 14 }
   .map{|x, i| i + 14}
   .first
