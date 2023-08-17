require 'set'

$elevations = ('a'..'z').to_a + ['E']

rows = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map(&:chars)
 .to_a

start_locations = rows
  .each_with_index
  .filter{|row, i| row.include? 'a' }
  .flat_map{|row, i| row.each_with_index.filter{|x,j| x == 'a'}.map{|_,j| [i,j] } }

end_location = rows
  .each_with_index
  .filter{|row, i| row.include? 'E' }
  .map{|row, i| [i, row.find_index('E') ] }
  .first

def elevation(elevation_map, i, j)
  if i >= 0 and i < elevation_map.length
    if j >= 0 and j < elevation_map[i].length
      $elevations.include?(elevation_map[i][j])
    end
  end
end

def location_with_surrounding_heights(height, i, j, elevation_map)
  {
    :location => [i,j],
    :height => height,
    :elevation => $elevations.find_index(height),
    :neighbors => {
      :up => elevation(elevation_map,i-1,j),
      :down => elevation(elevation_map,i+1,j),
      :left => elevation(elevation_map,i,j-1),
      :right => elevation(elevation_map,i,j+1)
    }
  }
end

def make_elevation_map(rows)

  elevation_map = []

  (0..rows.length-1).each{|i|
    elevation_map << []
    (0..rows[i].length-1).each{|j| 
      elevation_map[i] << location_with_surrounding_heights(rows[i][j],i,j, rows)
    }
  }

  elevation_map
end

def node_in_direction(elevation_map, node, direction)
  i,j = node[:location]
  case direction
  when :up
    return elevation_map[i-1][j]
  when :down
    return elevation_map[i+1][j]
  when :left
    return elevation_map[i][j-1]
  when :right
    return elevation_map[i][j+1]
  end
end

def can_explore?(current, neighbor)

#  return neighbor[:elevation] <= current[:elevation]+1 

      if current[:height] == 'k'
        return (neighbor[:elevation] <= current[:elevation]+1 and neighbor[:elevation] >= current[:elevation]-2)
      else
        return (neighbor[:elevation] == current[:elevation]+1 or neighbor[:elevation] == current[:elevation])
      end
end

def explore_nodes(elevation_map, distances, nodes_to_visit, visited_nodes = Set.new, rejected_nodes = Set.new)

  while nodes_to_visit.length > 0
    node = nodes_to_visit.shift(1).first
#    puts "evaluating #{node}"
    if node[:height] == 'E'
      puts "found the end with #{distances[node[:location]]} nodes visited"
      return distances[node[:location]]
    end

    visited_nodes.merge([node[:location]])

    nodes_to_explore = [:up, :down, :left, :right]
      .filter{|d| node[:neighbors][d] }
      .map{|d| node_in_direction(elevation_map, node, d) }
      .filter{|n| can_explore?(node, n) }
      .reject{|n| visited_nodes.include? n[:location] }
      .reject{|n| nodes_to_visit.include? n }

    nodes_to_explore.each{|n| distances[n[:location]] = distances[node[:location]] + 1 }

    nodes_to_visit += nodes_to_explore
  end
end


p rows
#p start_location
p end_location

elevation_map = make_elevation_map(rows)
#start_node = elevation_map[start_location[0]][start_location[1]]
#start_node[:elevation] = 0

p start_locations.map{|s|
  start_node = elevation_map[s[0]][s[1]]
  explore_nodes(elevation_map, {start_node[:location] => 0}, [start_node])
}.reject(&:nil?).sort.min
