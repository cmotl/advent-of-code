#state = [
#['Z', 'N'],
#['M', 'C', 'D'],
#['P']
#]

state = [
['W','D','G','B','H','R','V'],
['J','N','G','C','R','F' ],
['L','S','F','H','D','N','J'],
['J','D','S','V'],
['S','H','D','R','Q','W','N','V'],
['P','G','H','C','M'],
['F','J','B','G','L','Z','H','C'],
['S','J','R'],
['L','G','S','R','B','N','V','M']
]

result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.split(' ').each_slice(2).map{|a,b| b.to_i  } }
 .map{|count, from, to| [count, from-1, to-1] } 
 .reduce(state){|agg, (count, from, to)| count.times { agg[to] << agg[from].pop }; agg }
 .map(&:last)
 .join("")

puts(result)
