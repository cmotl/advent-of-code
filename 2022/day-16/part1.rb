require 'set'

input = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.match(/Valve (\w+) has flow rate=(\d+); tunnel(?:s)? lead(?:s)? to valve(?:s)? (.*)$/).to_a.drop(1) }
 .map{|x| {:valve => x[0], :flow_rate => x[1].to_i, :tunnels => x[2].split(/,/).map(&:strip)} }
 .to_a

puts(input)



def build_tunnel_system(input)
  valves = input.map{|x|x[:valve]}.to_set
  flow_rates = input.reduce({}){|agg, x| agg[x[:valve]] = x[:flow_rate]; agg }
  tunnels = input.reduce({}) {|agg, x| agg[x[:valve]] = x[:tunnels]; agg }

  return valves, flow_rates, tunnels
end


def depth_map_from_valve(valve, tunnels)

  valves_to_visit = [valve]
  depths = {valve => 0}
  visited_valves = Set.new

  while not valves_to_visit.empty?
    next_valve = valves_to_visit.shift
    
    visited_valves << next_valve

    next_valves = tunnels[next_valve]
      .reject{|x| visited_valves.include? x }
      .reject{|x| valves_to_visit.include? x }

    next_valves.each{|x| depths[x] = depths[next_valve] + 1 }

    valves_to_visit += next_valves
  end

  depths
end

def next_best_valve(valve, depth_map, flow_rates)

  max_depth = depth_map.map{|_,v| v }.max + 2

  possible_depths = depth_map.map{|k,v| [k,(max_depth - v)*flow_rates[k]] }.sort{|x,y| x[1] <=> y[1] }
  print(possible_depths); puts
  next_best = possible_depths.max{|x,y| x[1] <=> y[1]}[0]

  [next_best, depth_map[next_best] + 1,  depth_map[next_best] * flow_rates[next_best]]
end

def relieved_pressure(valve, tunnels, depths, flow_rates, minutes_remaining)

  if minutes_remaining <=0
    return [[:out_of_time, minutes_remaining], 0]
  end

  if flow_rates.filter{|_,b|b > 0}.count == 0
    return [[:end, minutes_remaining], 0]
  end

#  depths = depth_map_from_valve(valve, tunnels) 
  unopened_valves = flow_rates.filter{|_,v| v > 0}.map{|k,_| k}

#  print(unopened_valves); puts
  
  potential_relief = depths[valve]
    .filter{|k,_| unopened_valves.include? k }
    .reject{|k,v| minutes_remaining - v <= 0 }
    .map{|k,v|
      self_relief = (minutes_remaining-v-1) * flow_rates[k] 
      new_flow_rates = flow_rates.clone
      new_flow_rates[k] = 0
      chosen_valves, additional_relief = relieved_pressure(k,tunnels,depths, new_flow_rates, minutes_remaining-v-1)

      [[[k,minutes_remaining-v]].append(chosen_valves) , self_relief + additional_relief]
    }
    .max{|a,b| a[1] <=> b[1] } 

#  print(potential_relief); puts

  potential_relief or [[:no_reachable_nodes, minutes_remaining], 0]
end
valves, flow_rates, tunnels = build_tunnel_system(input)

puts(valves)
puts(flow_rates)
puts(tunnels)
puts

depths = depth_map_from_valve("AA", tunnels)
p(depths)

depth_map = valves.reduce({}){|agg, x| agg[x] = depth_map_from_valve(x, tunnels); agg }
p depth_map


puts

node_traversal, relief = relieved_pressure("AA", tunnels, depth_map, flow_rates, 30)
print "nodes traversed #{node_traversal}";puts
puts "pressure releived #{relief}"

