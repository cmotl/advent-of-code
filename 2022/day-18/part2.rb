require 'set'

voxels = File.open("input.txt")
 .each_line
 .lazy
 .map(&:chomp)
 .map{|x| x.split(/,/).map(&:to_i)}
 .to_set

def left_voxel(v) 
  [
   v[0]-1,
   v[1],
   v[2]
  ]
end

def right_voxel(v) 
  [
   v[0]+1,
   v[1],
   v[2]
  ]
end

def up_voxel(v) 
  [
   v[0],
   v[1]+1,
   v[2]
  ]
end

def down_voxel(v) 
  [
   v[0],
   v[1]-1,
   v[2]
  ]
end

def in_voxel(v) 
  [
   v[0],
   v[1],
   v[2]-1
  ]
end

def out_voxel(v) 
  [
   v[0],
   v[1],
   v[2]+1
  ]
end

def enclosed_sides(voxel, voxels)
  sides = 0
  sides += 1 if voxels.include? left_voxel(voxel)
  sides += 1 if voxels.include? right_voxel(voxel)
  sides += 1 if voxels.include? up_voxel(voxel)
  sides += 1 if voxels.include? down_voxel(voxel)
  sides += 1 if voxels.include? in_voxel(voxel)
  sides += 1 if voxels.include? out_voxel(voxel)
  sides
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

def contains_surrounding_voxel(group, v)
  return (
     (group.include? left_voxel(v)) or
     (group.include? right_voxel(v)) or
     (group.include? up_voxel(v)) or
     (group.include? down_voxel(v)) or
     (group.include? in_voxel(v)) or
     (group.include? out_voxel(v)) 
   )
end

def min_and_max_z_values(voxels)
  voxels.map{|x,y,z| z}.minmax
end

#def missing_voxels(voxels)
#  
#  x_values = voxels.map{|x,y| x }.to_set
#  print x_values; puts
#  x_values.flat_map{|x|
#    voxels.filter{|_x,y| _x == x }
#    .each_cons(2)
#    .filter{|(_,a),(_,b)| b - a != 1 }
#    .map{|(_,a),(_,b)| print(a);puts; print(b);puts; ((a+1)..(b-1))}
#    .flat_map{|r| r.map{|y| [x,y] } }
#  }

#end

def can_find_path_to_outside(x,y,slice)
  
end

def missing_voxels(voxels)
  

  y_values = voxels.map{|x,y| y }.to_set
  
  y_values.flat_map{|y|
    x_values = voxels.filter{|x,_y| _y == y}.map{|x,_y| x }.to_set
    print x_values; puts
    x_values.sort.flat_map{|x|
      voxels.sort.filter{|_x,_y| _x == x }
      .each_cons(2)
      .filter{|(_,a),(_,b)| b - a != 1 }
      .map{|(_,a),(_,b)| print(a);puts; print(b);puts; ((a+1)..(b-1))}
      .flat_map{|r| r.map{|y| [x,y] } }
    }
  }
end

def draw_slice(slice, missing)

  min_x, max_x = slice.map{|x,y| x}.minmax
  min_y, max_y = slice.map{|x,y| y}.minmax


  (min_y..max_y).each{|y|
    (min_x..max_x).each{|x|
      if slice.include? [x,y]
        print '#'
      elsif missing.include? [x,y]
        print '*'
      else
        print '.'
      end
    }
    print '  '

    (min_x..max_x).each{|x|
      if slice.include? [x,y]
        print '#'
      else
        print '.'
      end
    }
    puts
  }
  puts

end

def group_voxels(voxels)

  min, max = min_and_max_z_values(voxels)
  (min..max).flat_map{|z|
#    slice = voxels
#     .filter{|v| v[2] == z }
#     .map{|x,y,z| [x,y] }
#     .sort
    slice = voxels
     .filter{|v| v[2] == z }
     .map{|x,y,z| [x,y] }
     .sort

    missing = missing_voxels(slice)
    .sort
#    missing = missing_voxels(slice)
#    .map{|x,y| [x,y,z] }
#    .sort
    puts "slice"
    print(slice); puts
    puts "missing"
    print(missing); puts
    
    draw_slice(slice, missing)
    missing
  }

end

p min_and_max_z_values(voxels)
internal_voxels = group_voxels(voxels); puts;

internal_sides = internal_voxels.map{|v| exposed_sides(v, internal_voxels) }.sum
p(internal_sides)

external_sides = voxels.map{|v| exposed_sides(v,voxels) }.sum
p(external_sides)

p external_sides - internal_sides
