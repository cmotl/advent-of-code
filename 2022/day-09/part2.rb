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

  if head_x - tail_x == 2 and head_y - tail_y == 2
    return [head_x-1, head_y-1]
  elsif head_x - tail_x == 2 and tail_y - head_y == 2
    return [head_x-1, tail_y-1]
  elsif tail_x - head_x == 2 and head_y - tail_y == 2
    return [head_x+1, head_y-1]
  elsif tail_x - head_x == 2 and tail_y - head_y == 2
    return [head_x+1, tail_y-1]
  elsif head_x - tail_x > 1
    return [head_x-1, head_y]
  elsif tail_x - head_x > 1
    return [head_x+1, head_y]
  elsif head_y - tail_y > 1
    return [head_x, head_y-1]
  elsif tail_y - head_y > 1
    return [head_x, head_y+1]
  elsif tail_y == head_y
    if tail_x == head_x
      return [tail_x, tail_y]
    else
      if head_x > tail_x
        return [head_x-1, tail_y]
      else
        return [head_x+1, tail_y]
      end
    end
  elsif tail_x == head_x 
    if head_y > tail_y
      return [tail_x, head_y-1]
    else
      return [tail_x, head_y+1]
    end
  end
  tail
end

#def move_tail(head, tail)
#  head_x, head_y = head
#  tail_x, tail_y = tail

#  new_x = tail_x
#  new_y = tail_y

#  diff_x = (head_x - tail_x).abs
#  diff_y = (head_y - tail_y).abs

#  if tail_x == head_x and tail_y == head_y
#    return [tail_x, tail_y]
#  end

#  if tail_y == head_y
#    new_y = tail_y
#    if head_x - tail_x > 1
#      new_x = head_x-1
#    elsif tail_x - head_x > 1
#      new_x = head_x+1
#    end
#    return [new_x, new_y]
#  end

#  if tail_x == head_x
#    new_x = tail_x
#    if head_y - tail_y > 1
#      new_y = head_y-1
#    elsif tail_y - head_y > 1
#      new_y = head_y+1
#    end
#    return [new_x, new_y]
#  end


#  if head_x - tail_x > 1
#    new_x = head_x-1
#    new_y = head_y
#    return [new_x, new_y]
#  elsif tail_x - head_x > 1
#    new_x = head_x+1
#    new_y = head_y
#    return [new_x, new_y]
#  end

#  if head_y - tail_y > 1
#    new_y = head_y-1
#    new_x = head_x
#    return [new_x, new_y]
#  elsif tail_y - head_y > 1
#    new_y = head_y+1
#    new_x = head_x
#    return [new_x, new_y]
#  end
#  [new_x, new_y]
#end

def move_head_and_tail(rope, direction, magnitude)
  head, tail1, tail2, tail3, tail4, tail5, tail6, tail7, tail8, tail9 = rope
#  print(head, tail)
#  puts()
  tail_positions = Set.new
  magnitude.times {
    head = move_head(direction, head)
    tail1 = move_tail(head, tail1) 
    tail2 = move_tail(tail1, tail2) 
    tail3 = move_tail(tail2, tail3) 
    tail4 = move_tail(tail3, tail4) 
    tail5 = move_tail(tail4, tail5) 
    tail6 = move_tail(tail5, tail6) 
    tail7 = move_tail(tail6, tail7) 
    tail8 = move_tail(tail7, tail8) 
    tail9 = move_tail(tail8, tail9) 
    tail_positions.add(tail9)
    print([head, tail1, tail2, tail3, tail4, tail5, tail6, tail7, tail8, tail9])
    puts
  }
  puts
  [[head, tail1, tail2, tail3, tail4, tail5, tail6, tail7, tail8, tail9], tail_positions]
end

rope = [[1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1], [1,1]]

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

#print(move_tail([3,3],[1,1]))
#puts
#print(move_tail([3,1],[1,3]))
#puts
#print(move_tail([1,1],[3,3]))
#puts
#print(move_tail([1,3],[3,1]))
#puts
#print(move_tail([5,2],[3,1]))
