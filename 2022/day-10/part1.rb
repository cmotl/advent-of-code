total = 1
cycles = 0

result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.split(' ') }
 .map{|command, value| value.to_i }
 .flat_map{|x| x==0 ? [[0,1]]: [[0,1],[0,1],[x,0]]}
 .map{|x,c| total += x; cycles += c; [total, cycles]}
 .filter{|x,c| (c-20)%40 == 0  }
 .uniq{|x, c| c }
 .take(6)
 .map{|x, c| x*c}
 .sum

print(result)
