require 'set'

def manhattan_distance((x1,y1),(x2,y2))
  return (x1 - x2).abs + (y1-y2).abs
end

target_line = 2000000

sensors_and_beacons = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.match(/Sensor at x=([-]+\d+|\d+), y=([-]+\d+|\d+): closest beacon is at x=([-]+\d+|\d+), y=([-]+\d+|\d+)/).to_a.drop(1).to_a.map(&:to_i) }
 .map{|x| {:sensor => [x[0], x[1]], :beacon => [x[2], x[3]]} }
 .map{|x| x[:distance] = manhattan_distance(x[:sensor], x[:beacon]); x}
 .to_a

sensors_covering_target_line = 
 sensors_and_beacons
 .filter{|x| (x[:sensor][1]-x[:distance]..x[:sensor][1]+x[:distance]).include? target_line }
 .flat_map{|x| 
   distance_to_target = (x[:sensor][1] - target_line).abs 
   width = (x[:distance] - distance_to_target)
   ((x[:sensor][0]-width)..(x[:sensor][0]+width)).map{|y| [y,target_line] }
 }
 .reduce(Set.new, :<<).sort

beacons_covering_target_line = 
 sensors_and_beacons
 .filter{|x| x[:beacon][1] == target_line }
 .map{|x| x[:beacon] }
 .reduce(Set.new, :<<).sort

p (sensors_covering_target_line - beacons_covering_target_line).size
