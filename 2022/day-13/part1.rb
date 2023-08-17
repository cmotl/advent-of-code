

def compare(a,b)
  return nil if a.empty? and b.empty?
  return true if a.empty?
  return false if b.empty?
  head_a, *tail_a = a
  head_b, *tail_b = b

#  p "comparing '#{head_a}' and '#{head_b}'"

#  case [head_a, head_b]
#  when [Integer, Integer]
#    return true if head_a < head_b

  if (head_a.kind_of?(Array) and head_b.kind_of?(Array))
    result = compare(head_a, head_b)
  elsif (head_a.kind_of?(Array) and (not head_b.kind_of?(Array)))
    result = (compare(head_a, [head_b]))
  elsif ((not head_a.kind_of?(Array)) and head_b.kind_of?(Array))
    result =  (compare([head_a], head_b))
  elsif head_a < head_b
    return true
  elsif head_a > head_b
    return false
  end

  result.nil? ? compare(tail_a, tail_b) : result
end


raise "Failure" unless compare([1,1,3,1,1], [1,1,5,1,1]) == true
raise "Failure" unless compare([[1],[2,3,4]], [[1],4]) == true
raise "Failure" unless compare([9], [[8,7,6]]) == false
raise "Failure" unless compare([[4,4],4,4], [[4,4],4,4,4]) == true
raise "Failure" unless compare([7,7,7,7], [7,7,7]) == false
raise "Failure" unless compare([], [3]) == true
raise "Failure" unless compare([[[]]], [[]]) == false
raise "Failure" unless compare([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9]) == false


p File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .filter{|x| x != ""}
 .each_slice(2)
 .map{|x| x.map{|y| eval(y) } }
 .with_index
 .filter{|(a,b),i| compare(a,b) }
 .map{|_,i| i + 1 }
 .sum
