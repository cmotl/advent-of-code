from functools import reduce

def parse_direction(direction):
  d = direction[0]
  m = int(direction[1:])
  return (d,m)

sample_input_lines = """F10
N3
F7
R90
F11""".split('\n')
sample_directions = [parse_direction(x.strip()) for x in sample_input_lines]


def rotate(heading, direction, degrees):
  if degrees == 0:
    return heading

  if heading == 'E':
    if direction == 'R':
      return rotate('S', direction, degrees-90)
    else:
      return rotate('N', direction, degrees-90)

  if heading == 'N':
    if direction == 'R':
      return rotate('E', direction, degrees-90)
    else:
      return rotate('W', direction, degrees-90)

  if heading == 'W':
    if direction == 'R':
      return rotate('N', direction, degrees-90)
    else:
      return rotate('S', direction, degrees-90)

  if heading == 'S':
    if direction == 'R':
      return rotate('W', direction, degrees-90)
    else:
      return rotate('E', direction, degrees-90)

def move(location,action):
  x,y,heading = location
  d,m = action

  if d == 'N':
    y+=m
  elif d == 'S':
    y-=m
  elif d == 'E':
    x+=m
  elif d == 'W':
    x-=m
  elif d == 'F':
    return move(location, (heading,m))
  elif d == 'R' or d == 'L':
    heading = rotate(heading, d, m) 

  return (x,y,heading)

def rotate_waypoint(direction, degrees, wx, wy):
  if degrees == 0:
    return wx, wy

  if direction == 'R':
    return rotate_waypoint(direction, degrees-90, wy, -1*wx)
  else:
    return rotate_waypoint(direction, degrees-90, -1*wy, wx)


def move_with_waypoint(location,action):
  wx,wy, x,y = location
  d,m = action

  if d == 'N':
    wy+=m
  elif d == 'S':
    wy-=m
  elif d == 'E':
    wx+=m
  elif d == 'W':
    wx-=m
  elif d == 'F':
    return (wx, wy, x+(m*wx), y+(m*wy))
  elif d == 'R' or d == 'L':
    wx, wy = rotate_waypoint(d, m, wx, wy) 

  return (wx,wy, x,y)

def move_all(directions):
  origin = (0,0,'E')
  return reduce(move, directions, origin)

def move_all_waypoint(directions):
  origin = (10,1, 0,0)
  return reduce(move_with_waypoint, directions, origin)

def test_can_move_single_direction():
  assert((0,10,'E') == move((0,0,'E'), ('N', 10)))
  assert((0,-10,'E') == move((0,0,'E'), ('S', 10)))
  assert((10,0,'E') == move((0,0,'E'), ('E', 10)))
  assert((-10,0,'E') == move((0,0,'E'), ('W', 10)))
  assert((10,0,'E') == move((0,0,'E'), ('F', 10)))
  assert((0,0,'S') == move((0,0,'E'), ('R', 90)))
  assert((0,0,'W') == move((0,0,'E'), ('R', 180)))
  assert((0,0,'N') == move((0,0,'E'), ('R', 270)))
  assert((0,0,'N') == move((0,0,'E'), ('L', 90)))
  assert((0,0,'W') == move((0,0,'E'), ('L', 180)))
  assert((0,0,'S') == move((0,0,'E'), ('L', 270)))

def test_integration():
  print(move_all(sample_directions))
  assert((17, -8, 'S') == move_all(sample_directions))

def test_waypoint_integration():
  print(move_all_waypoint(sample_directions))
  assert((4,-10, 214,-72) == move_all_waypoint(sample_directions))

test_can_move_single_direction()
test_integration()
test_waypoint_integration()

input = open("input.txt", "r").readlines()
directions =  [parse_direction(x.strip()) for x in input]

def part1():
  x,y,_ = move_all(directions)
  return abs(x) + abs(y) 

def part2():
  _,_,x,y = move_all_waypoint(directions)
  return abs(x) + abs(y) 


print(part1())
print(part2())
