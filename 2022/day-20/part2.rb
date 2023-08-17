encryption_list = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map(&:to_i)
 .with_index
 .map{|x,i| [x*811589153, i]}
 .to_a

10.times {
  (0..(encryption_list.length - 1)).each{|x|
  
  shift_amount = encryption_list.find_index{|v,i| i == x}
  encryption_list = encryption_list.rotate( shift_amount )
  value = encryption_list.shift
  encryption_list = encryption_list.rotate(value[0]).unshift(value)

  }
#  print encryption_list.rotate(encryption_list.map{|x,i| x}.index(0)).map{|x,i| x}; puts;
}

encryption_list = encryption_list.map{|x,i| x}
encryption_list = encryption_list.rotate(encryption_list.index(0))

p encryption_list[1000 % encryption_list.length]
p encryption_list[2000 % encryption_list.length]
p encryption_list[3000 % encryption_list.length]
p [1000, 2000, 3000].map{|x|
  encryption_list[x % encryption_list.length]
}.sum
