require 'set'

input = File.open("sample_input.txt")
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


def depth_map_from_valve(valve, valves, tunnels)

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


valves, flow_rates, tunnels = build_tunnel_system(input)

puts(valves)
puts(flow_rates)
puts(tunnels)
puts

depths = depth_map_from_valve("AA", valves, tunnels)
p(depths)


puts

next_best = next_best_valve("AA", depths, flow_rates)
p "next best from AA"
p(next_best)

flow_rates[next_best[0]] = 0
depths = depth_map_from_valve(next_best[0], valves, tunnels)

puts
p "next best from #{next_best[0]}"
p(depths)
next_best = next_best_valve(next_best[0], depths, flow_rates)
p(next_best)

flow_rates[next_best[0]] = 0
depths = depth_map_from_valve(next_best[0], valves, tunnels)

puts
p "next best from #{next_best[0]}"
p(depths)
next_best = next_best_valve(next_best[0], depths, flow_rates)
p(next_best)

flow_rates[next_best[0]] = 0
depths = depth_map_from_valve(next_best[0], valves, tunnels)

puts
p "next best from #{next_best[0]}"
p(depths)
next_best = next_best_valve(next_best[0], depths, flow_rates)
p(next_best)

flow_rates[next_best[0]] = 0
depths = depth_map_from_valve(next_best[0], valves, tunnels)

puts
p "next best from #{next_best[0]}"
p(depths)
next_best = next_best_valve(next_best[0], depths, flow_rates)
p(next_best)

flow_rates[next_best[0]] = 0
depths = depth_map_from_valve(next_best[0], valves, tunnels)

puts
p "next best from #{next_best[0]}"
p(depths)
next_best = next_best_valve(next_best[0], depths, flow_rates)
p(next_best)

flow_rates[next_best[0]] = 0
depths = depth_map_from_valve(next_best[0], valves, tunnels)

puts
p "next best from #{next_best[0]}"
p(depths)
next_best = next_best_valve(next_best[0], depths, flow_rates)
p(next_best)
