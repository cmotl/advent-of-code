require 'set'

directions = {'R' => :right, 'L' => :left, 'U' => :up, 'D' => :down }

def move_head(direction, location)
  x,y = location
  case direction
  when :right
    [x+1, y]
  when :left
    [x-1, y]
  when :up
    [x, y+1]
  when :down
    [x, y-1]
  end
end

def move_tail(head, tail)
  head_x, head_y = head
  tail_x, tail_y = tail

  if head_x - tail_x > 1
    return [head_x-1, head_y]
  elsif tail_x - head_x > 1
    return [head_x+1, head_y]
  elsif head_y - tail_y > 1
    return [head_x, tail_y+1]
  elsif tail_y - head_y > 1
    return [head_x, tail_y-1]
  end
  tail
end

def move_head_and_tail(rope, direction, magnitude)
  head, tail = rope
#  print(head, tail)
#  puts()
  tail_positions = Set.new
  magnitude.times {
    head = move_head(direction, head)
    tail = move_tail(head, tail) 
    tail_positions.add(tail)
  }
  [[head, tail], tail_positions]
end

rope = [[1,1], [1,1]]

#print(rope)
#puts()

#all_positions = Set.new
#rope, positions = move_head_and_tail(rope, :right, 4)
#all_positions.merge(positions)

#rope, positions = move_head_and_tail(rope, :up, 4)
#all_positions.merge(positions)
#print(rope)
#puts()

#print(all_positions)
#puts()

result = File.open("input.txt")
 .each_line
 .lazy
 .map(&:strip)
 .map{|x| x.split(' ') }
 .map{|d, m| [directions[d], m.to_i] }
 .reduce([rope, Set.new]) {|(rope, positions), (direction, magnitude)| 
      rope, new_positions = move_head_and_tail(rope, direction, magnitude)
      [rope, positions | new_positions]
     }

print(result[0])
puts()
puts(result[1].length)
#print(result[1])
