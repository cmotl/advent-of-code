require 'set'

input = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.match(/Valve (\w+) has flow rate=(\d+); tunnel(?:s)? lead(?:s)? to valve(?:s)? (.*)$/).to_a.drop(1) }
 .map{|x| {:valve => x[0], :flow_rate => x[1].to_i, :tunnels => x[2].split(/,/).map(&:strip)} }
 .to_a

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

def single_relieved_pressure(valve, depths, flow_rates, minutes_remaining)

  if minutes_remaining <=0
    return [[:out_of_time, minutes_remaining], 0]
  end

  if flow_rates.filter{|_,b|b > 0}.count == 0
    return [[:end, minutes_remaining], 0]
  end

#  depths = depth_map_from_valve(valve, tunnels) 
  unopened_valves = flow_rates.filter{|_,v| v > 0}.map{|k,_| k}

#  print(unopened_valves); puts
  
  potential_relief = depths
    .filter{|k,_| unopened_valves.include? k }
    .reject{|k,v| minutes_remaining - v <= 0 }
    .map{|k,v|
      self_relief = (minutes_remaining-v-1) * flow_rates[k] 
      new_flow_rates = flow_rates.clone
      new_flow_rates[k] = 0
      chosen_valves, additional_relief = single_relieved_pressure(k,depths, new_flow_rates, minutes_remaining-v-1)

      [[[k,minutes_remaining-v]].append(chosen_valves) , self_relief + additional_relief]
    }
    .max{|a,b| a[1] <=> b[1] } 

#  print(potential_relief); puts

  potential_relief or [[:no_reachable_nodes, minutes_remaining], 0]
end

def relieved_pressure(self_valve, elephant_valve, depths, flow_rates, self_minutes_remaining, elephant_minutes_remaining)

  if self_minutes_remaining <=0 and elephant_minutes_remaining <=0
    return [[:out_of_time, self_minutes_remaining], 0]
  end

  if self_minutes_remaining <= 0
    return single_relieved_pressure(elephant_valve,depths[elephant_valve], flow_rates, elephant_minutes_remaining) 
  end
  if elephant_minutes_remaining <= 0
    return single_relieved_pressure(self_valve,depths[self_valve], flow_rates, self_minutes_remaining) 
  end

  if flow_rates.filter{|_,b|b > 0}.count == 0
    return [[[:end, self_minutes_remaining]], 0]
  end
  if flow_rates.filter{|_,b|b > 0}.count == 1
      self_relieved_pressure = single_relieved_pressure(self_valve,depths[self_valve], flow_rates, self_minutes_remaining) 
      elephant_relieved_pressure = single_relieved_pressure(elephant_valve,depths[elephant_valve], flow_rates, elephant_minutes_remaining) 
    
      return [self_relieved_pressure, elephant_relieved_pressure].max{|a,b| a[1] <=> b[1]}
  end

  unopened_valves = flow_rates.filter{|_,v| v > 0}.map{|k,_| k}

#  print(unopened_valves); puts

  self_potential_relief = unopened_valves
    .permutation(2)
    .reject{|k1,k2|
      v1 = depths[self_valve][k1]
      v2 = depths[elephant_valve][k2]

      (((self_minutes_remaining-v1-1) <= 0) and ((elephant_minutes_remaining-v2-1) <= 0))
    }
    .map{|k1,k2|

      v1 = depths[self_valve][k1]
      v2 = depths[elephant_valve][k2]

#      if (self_minutes_remaining-v1-1 <= 0) or (elephant_minutes_remaining-v2-1 <= 0)
#        return [[:out_of_time, self_minutes_remaining], 0]
#      end

      self_relief = (self_minutes_remaining-v1-1) * flow_rates[k1] 
      elephant_relief = (elephant_minutes_remaining-v2-1) * flow_rates[k2] 
      self_relief = [self_relief,0].max
      elephant_relief = [elephant_relief,0].max

      new_flow_rates = flow_rates.clone
      new_flow_rates[k1] = 0
      new_flow_rates[k2] = 0
      chosen_valves, additional_relief = relieved_pressure(k1, k2,depths, new_flow_rates, self_minutes_remaining-v1-1, elephant_minutes_remaining-v2-1)

      [[[k1,self_minutes_remaining-v1], [k2,elephant_minutes_remaining-v2]] + chosen_valves, self_relief + additional_relief + elephant_relief]
    }
    .max{|a,b| a[1] <=> b[1] } 
#  print(self_potential_relief); puts

  self_potential_relief or [[:no_reachable_nodes, self_minutes_remaining], 0]
end

valves, flow_rates, tunnels = build_tunnel_system(input)
depth_map = valves.reduce({}){|agg, x| agg[x] = depth_map_from_valve(x, tunnels); agg }

node_traversal, relief = relieved_pressure("AA", "AA", depth_map, flow_rates, 26, 26)
print "nodes traversed #{node_traversal}";puts
puts "pressure relieved #{relief}"

