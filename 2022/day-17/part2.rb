require 'set'

jets_raw = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .flat_map(&:chars)
 .map{|x| x=='<' ? :left : :right }
 .to_a

puts("jest length: #{jets_raw.length}")
jets = jets_raw.cycle
rocks = (1..5).cycle

#p(jets.next)
#p(rocks.next)


def make_rock_1((x,y))
  Set[ [x  , y], [x+1, y], [x+2, y], [x+3, y] ]
end

def make_rock_2((x,y))
  Set[ [x+1, y  ], [x  , y+1], [x+1, y+1], [x+2, y+1], [x+1, y+2] ]
end

def make_rock_3((x,y))
  Set[ [x  , y  ], [x+1, y  ], [x+2, y  ], [x+2, y+1], [x+2, y+2] ]
end

def make_rock_4((x,y))
  Set[ [x, y  ], [x, y+1], [x, y+2], [x, y+3] ]
end

def make_rock_5((x,y))
  Set[ [x  , y  ], [x  , y+1], [x+1, y  ], [x+1, y+1] ]
end

def make_rock(type, location)

  case type
  when 1
    make_rock_1(location)
  when 2
    make_rock_2(location)
  when 3
    make_rock_3(location)
  when 4
    make_rock_4(location)
  when 5
    make_rock_5(location)
  end
end

def chamber_height(chamber)
  if chamber.empty?
    return 3
  end

  chamber.to_a.map{|x,y| y}.max + 4
end

def can_drop(chamber, rock)

  potential_position = drop(rock)

  bottom = potential_position.map{|x,y| y}.min
  
  if bottom < 0
    return false
  end

  return ((chamber & potential_position).size == 0)

end

def drop(rock)
  rock.map{|x,y| [x, y-1]}.to_set
end

def can_move_left(rock, chamber)
  if rock.map{|x,y| x }.min == 0
    return false
  end


  potential_position = move_left(rock)

  return ((chamber & potential_position).size == 0)
end

def can_move_right(rock, chamber)
  if rock.map{|x,y| x }.max == 6
    return false
  end

  potential_position = move_right(rock)

  return ((chamber & potential_position).size == 0)
end

def move_left(rock)
  rock.map{|x,y| [x-1, y]}.to_set
end

def move_right(rock)
  rock.map{|x,y| [x+1, y]}.to_set
end

def move(rock, jet, chamber)
  case jet
  when :left
    return move_left(rock) if can_move_left(rock, chamber)
  when :right
    return move_right(rock) if can_move_right(rock, chamber)
  end
  rock
end

def draw_chamber(chamber, falling_rock = Set.new)

  ceiling = [chamber_height(chamber), (falling_rock.map{|x,y| y}.max or 0)].max

  (0..ceiling).reverse_each{|y|
    print '|'
    (0..6).each{|x|
      if chamber.include? [x,y] 
        print '#'
      elsif falling_rock.include? [x,y]
        print '@'
      else
        print '.'
      end
    }
    print '| '
    if ((y % 5) == 0)
      print y
    end
    puts
  }
  print '+-------+'
  puts
end

chamber = Set.new
p chamber_height(chamber)


last_height = chamber_height(chamber) - 3
occurence =  [2,3,3,4,5,10091,7].reduce(:lcm)

(1..50000).each{|x|

  rock = make_rock(rocks.next,[2,chamber_height(chamber)])
#  draw_chamber(chamber, rock)

  rock = move(rock, jets.next, chamber)

  while can_drop(chamber, rock)
    rock = drop(rock)
    rock = move(rock, jets.next, chamber)
#    draw_chamber(chamber, rock)
  end
  chamber.merge(rock)

  if (x % 120 == 0)
    new_chamber_height = chamber_height(chamber) - 3
    puts(new_chamber_height - last_height)
    last_height = new_chamber_height
  end
#  if (x % 840 == 0)
#    new_chamber_height = chamber_height(chamber) - 3
#    puts(new_chamber_height - last_height)
#    last_height = new_chamber_height
#  end
  if x == 4 
    puts chamber_height(chamber) - 3
  end

#  draw_chamber(chamber)
#  puts
}

#draw_chamber(chamber)
highest_rock = chamber.map{|x,y| y}.max + 1
p "Highest rock: #{highest_rock}"
