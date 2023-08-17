require 'set'

def manhattan_distance((x1,y1),(x2,y2))
  return (x1 - x2).abs + (y1-y2).abs
end

#target_line = 10
min_bound = 0
max_bound = 4000000

sensors_and_beacons = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.match(/Sensor at x=([-]+\d+|\d+), y=([-]+\d+|\d+): closest beacon is at x=([-]+\d+|\d+), y=([-]+\d+|\d+)/).to_a.drop(1).to_a.map(&:to_i) }
 .map{|x| {:sensor => [x[0], x[1]], :beacon => [x[2], x[3]]} }
 .map{|x| x[:distance] = manhattan_distance(x[:sensor], x[:beacon]); x}
 .to_a

covered_locations = Array.new(max_bound+1){Array.new(max_bound+1,'.')}

(min_bound..max_bound).flat_map{|target_line|
#  puts("processing line #{target_line}")
   sensors_and_beacons
   .filter{|x| (x[:sensor][1]-x[:distance]..x[:sensor][1]+x[:distance]).include? target_line }
   .flat_map{|x| 
     distance_to_target = (x[:sensor][1] - target_line).abs 
     width = (x[:distance] - distance_to_target)

     ((x[:sensor][0]-width)..(x[:sensor][0]+width))
      .filter{|x| x >= min_bound and x <= max_bound }
      .map{|y| [y,target_line] }
   }
 }
 .each{|x|
#   print(x);puts
   covered_locations[x[0]][x[1]] = '#'}

sensors_and_beacons
 .map{|x| x[:beacon] }
 .reject{|x| 
   x[0] < min_bound or
   x[0] > max_bound or
   x[1] < min_bound or
   x[1] > max_bound
 }
 .filter{|x| x[0] >= min_bound and x[0] <= max_bound }
 .each{|x| covered_locations[x[0]][x[1]] = '#'}

(min_bound..max_bound).each{|x| 
  (min_bound..max_bound).each{|y|
    if covered_locations[x][y] == "."
      p (x*4000000 + y)
      break
    end
  }
}

