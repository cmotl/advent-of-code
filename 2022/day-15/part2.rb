require 'set'
require 'parallel'

def manhattan_distance((x1,y1),(x2,y2))
  return (x1 - x2).abs + (y1-y2).abs
end

#target_line = 10
min_bound = 0
max_bound = 20


sensors_and_beacons = File.open("sample_input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.match(/Sensor at x=([-]+\d+|\d+), y=([-]+\d+|\d+): closest beacon is at x=([-]+\d+|\d+), y=([-]+\d+|\d+)/).to_a.drop(1).to_a.map(&:to_i) }
 .map{|x| {:sensor => [x[0], x[1]], :beacon => [x[2], x[3]]} }
 .map{|x| x[:distance] = manhattan_distance(x[:sensor], x[:beacon]); x}
 .to_a

x=0

#sensors_and_beacons.each{|x| print("{#{x[:sensor][0]}, #{x[:sensor][1]}, #{x[:distance]}},"); puts }
#puts
#exit

def in_manhatten_distance(point, sensor, distance)
end

until x == max_bound do
  y=0
  puts("processing line #{x}")
  until y == max_bound do
#  puts("processing line #{x},#{y}")
    size = sensors_and_beacons.filter{|snb|
#      puts(snb);
#      print(snb);puts
#      print(manhattan_distance(snb[:sensor],[x,y]));puts
      manhattan_distance(snb[:sensor],[x,y]) > snb[:distance]
    }.size
#    p size
    if size == 14
      p "found #{x},#{y}"
      break
    end
    
    y=y+1
  end
  x = x+1
end

p "done"
exit

(min_bound..max_bound).lazy.each{|target_line|
  puts("processing line #{target_line}")
   covered_locations = sensors_and_beacons
   .filter{|x| (x[:sensor][1]-x[:distance]..x[:sensor][1]+x[:distance]).include? target_line }
   .flat_map{|x| 
     distance_to_target = (x[:sensor][1] - target_line).abs 
     width = (x[:distance] - distance_to_target)

     ([(x[:sensor][0]-width), min_bound].max)..([(x[:sensor][0]+width),max_bound].min)
   }
   .reduce(Set.new){|agg, x|
     agg.merge(x)

#      .filter{|x| x >= min_bound and x <= max_bound }
   }

   p covered_locations.size
#  (min_bound..max_bound).each{|y|
#    if covered_locations[y] == "."
#      p (y*4000000 + target_line)
#      break
#    end
#  }
 }

#sensors_and_beacons
# .map{|x| x[:beacon] }
# .reject{|x| 
#   x[0] < min_bound or
#   x[0] > max_bound or
#   x[1] < min_bound or
#   x[1] > max_bound
# }
# .filter{|x| x[0] >= min_bound and x[0] <= max_bound }
# .each{|x| covered_locations[x[0]][x[1]] = '#'}

#(min_bound..max_bound).each{|x| 
#  (min_bound..max_bound).each{|y|
#    if covered_locations[x][y] == "."
#      p (x*4000000 + y)
#      break
#    end
#  }
#}

