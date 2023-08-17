
blueprints = File.open("sample_input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.match(/Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./).to_a.drop(1).to_a.map(&:to_i) }
 .to_a

print blueprints; puts
