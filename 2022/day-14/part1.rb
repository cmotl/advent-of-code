require 'set'

walls = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .flat_map{|x| 
   x.split(/->/)
     .map{|y| y.strip.split(/,/).map(&:to_i) }
     .each_cons(2)
     .to_a
 }
 .flat_map{|(x1,y1),(x2, y2)| 
    if y1 == y2
      x1, x2 = [x1,x2].sort
      (x1..x2).map{|x| [x,y1] }
    elsif x1 == x2
      y1, y2 = [y1,y2].sort
      (y1..y2).map{|y| [x1,y] }
    end
 }
 .reduce(Set.new, &:<<)

def can_drop(location, walls, sands)
  return ( (not walls.include? location) and (not sands.include? location))
end

def floor_bottom(walls)
  walls.to_a.map{|a,b| b }.sort.max 
end

def next_location(sand, walls, sands)
  a,b = sand

  if b > floor_bottom(walls) 
    return :endless_void
  end

  if can_drop([a, b+1], walls, sands)
    return next_location([a, b+1], walls, sands)
  end

  if can_drop([a-1, b+1], walls, sands)
    return next_location([a-1, b+1], walls, sands)
  end

  if can_drop([a+1, b+1], walls, sands)
    return next_location([a+1, b+1], walls, sands)
  end

  return sand
end

def drop_sand(walls, sands = Set.new)
  loop do
    landing_location = next_location([500,0], walls, sands)  
    break if landing_location == :endless_void 
    sands << landing_location
  end
  return sands
end

sands = drop_sand(walls)

puts(sands.length)
