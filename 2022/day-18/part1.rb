require 'set'

voxels = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.split(/,/).map(&:to_i)}
 .map{|x,y,z| {:x => x, :y => y, :z => z}}
 .to_set

def left_voxel(v) 
  {
   :x => v[:x]-1,
   :y => v[:y],
   :z => v[:z]
  }
end

def right_voxel(v) 
  {
   :x => v[:x]+1,
   :y => v[:y],
   :z => v[:z]
  }
end

def up_voxel(v) 
  {
   :x => v[:x],
   :y => v[:y]+1,
   :z => v[:z]
  }
end

def down_voxel(v) 
  {
   :x => v[:x],
   :y => v[:y]-1,
   :z => v[:z]
  }
end

def in_voxel(v) 
  {
   :x => v[:x],
   :y => v[:y],
   :z => v[:z]-1
  }
end

def out_voxel(v) 
  {
   :x => v[:x],
   :y => v[:y],
   :z => v[:z]+1
  }
end

def exposed_sides(voxel, voxels)
  sides = 0
  sides += 1 if not(voxels.include? left_voxel(voxel) )
  sides += 1 if not(voxels.include? right_voxel(voxel) )
  sides += 1 if not(voxels.include? up_voxel(voxel) )
  sides += 1 if not(voxels.include? down_voxel(voxel) )
  sides += 1 if not(voxels.include? in_voxel(voxel) )
  sides += 1 if not(voxels.include? out_voxel(voxel) )
  sides
end

p voxels.map{|v|
  exposed_sides(v, voxels)
}
.sum
