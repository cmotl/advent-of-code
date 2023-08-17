total = 1
cycles = 0

File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.split(' ') }
 .map{|command, value| value.to_i }
 .flat_map{|x| x==0 ? [[0,1]]: [[0,1],[0,1],[x,0]]}
 .map{|x,c| total += x; cycles += c; [total, cycles]}
 .uniq{|x, c| c }
 .reduce([]){|crt, (x,c)|
    crt[c-1] = (x-1..x+1).member?((c-1)%40) ? '#' : '.' 
    crt
 }
 .each_slice(40)
 .each{|x| x.each{|y| print(y) }; puts }
