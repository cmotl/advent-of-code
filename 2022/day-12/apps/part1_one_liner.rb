require 'set'

$elevations = ('a'..'z').to_a + ['E']

rows = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map(&:chars)
 .to_a

start_location = rows
  .each_with_index
  .filter{|row, i| row.include? 'S' }
  .map{|row, i| [i, row.find_index('S') ] }
  .first

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
$min_found_so_far = 10000000
$max_found_so_far = 0
$already_found_nodes = {}
def explore_nodes(elevation_map, node, visited_nodes = Set.new, rejected_nodes = Set.new)
#  puts ("exploring #{node[:location]}")
#  puts ("visited_nodes #{visited_nodes.length}")

#  if $already_found_nodes.key? node[:location]
#    puts "reusing set value #{$already_found_nodes[node[:location]]}"
#    return  $already_found_nodes[node[:location]]
#  end

  if node[:height] == 'E'
#    puts "found the end with #{visited_nodes.length} nodes visited"
    if visited_nodes.length < $min_found_so_far
      $min_found_so_far = visited_nodes.length
      puts "Found new minimum at #{$min_found_so_far}"
    end
    return 0
  end

#  if node[:height] == 'k'
#    puts "found k"
#  end

  visited_nodes+=[node[:location]]

  min_path = [:up, :down, :left, :right]
    .filter{|d| node[:neighbors][d] }
    .map{|d| node_in_direction(elevation_map, node, d) }
    .filter{|n| can_explore?(node, n) }
    .reject{|n| visited_nodes.include? n[:location] }
    .reject{|n| rejected_nodes.include? n[:location] }
    .sort{|n| n[:elevation] }
    .map{|n| explore_nodes(elevation_map, n, visited_nodes) }
    .reject(&:nil?)
    .sort
    .min 

#  if min_path
#    puts "setting min found #{min_path}"
#    $already_found_nodes[node[:location]] = min_path + 1
#  end
#  if min_path.nil?
#    rejected_nodes.merge( [node[:location]])
#    puts "rejecting #{rejected_nodes.length}"
#  end

  return min_path ? min_path + 1 : nil
end


p rows
p start_location
p end_location

elevation_map = make_elevation_map(rows)
start_node = elevation_map[start_location[0]][start_location[1]]
start_node[:elevation] = 0

p explore_nodes(elevation_map, start_node)
