sample_input_lines = """L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL""".split('\n')
sample_floor_layout = [x.strip() for x in sample_input_lines]

sample_intermediate_lines_1 = """#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##LL.LL.L#
L.LL.LL.L#
#.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLL#.L
#.L#LL#.L#""".split('\n')
sample_intermediate_layout_1 = [x.strip() for x in sample_intermediate_lines_1]

sample_intermediate_lines_2 = """#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.#L.L#
#.L####.LL
..#.#.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#""".split('\n')
sample_intermediate_layout_2 = [x.strip() for x in sample_intermediate_lines_2]

sample_seats_in_all_directions_lines = """.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....""".split('\n')
sample_seats_in_all_directions = [x.strip() for x in sample_seats_in_all_directions_lines]

floor = '.'
unoccupied = 'L'
occupied = '#'

def seat_update(t, adjacent):
  if t == floor:
    return floor

  occupied_seats = [x for x in adjacent if x == occupied]
 
  if t == unoccupied and len(occupied_seats) > 0:
    return unoccupied

  if len(occupied_seats) >= 5:
    return unoccupied

  return occupied

def seat_at(row, column, layout):
  if row < 0 or column < 0:
    return floor
  if row >= len(layout) or column >= len(layout[row]):
    return floor

  return layout[row][column]

def next_seat_in_direction(row, column, rx, dx, layout):
  r = row + rx
  c = column + dx
  if r < 0 or c < 0:
    return floor
  if r >= len(layout) or c >= len(layout[row]):
    return floor

  seat = layout[r][c]
  if seat == floor:
    return next_seat_in_direction(r, c, rx, dx, layout)
  else:
    return seat

def adjacent_seats(seat, layout):
  row, column = seat
  return [
    next_seat_in_direction(row,column, -1, -1, layout),
    next_seat_in_direction(row,column, -1,  0, layout),
    next_seat_in_direction(row,column, -1,  1, layout),

    next_seat_in_direction(row,column, 0, -1, layout),
    next_seat_in_direction(row,column, 0,  1, layout),

    next_seat_in_direction(row,column, 1, -1, layout),
    next_seat_in_direction(row,column, 1,  0, layout),
    next_seat_in_direction(row,column, 1,  1, layout)
  ]

def next_seat_map(layout):
  new_layout = []
  for r, row in enumerate(layout):
    new_row = ''
    for c, column in enumerate(row):
      new_row += seat_update(seat_at(r, c, layout), adjacent_seats((r, c), layout))
    new_layout.append(new_row)
  return new_layout

def iterations_until_stabilization(layout):
  last_layout = []
  next_layout = layout
  while last_layout != next_layout:
    last_layout = next_layout
    next_layout = next_seat_map(next_layout)

  occupied_seats = 0

  for row in next_layout:
    for column in row:
      if column == occupied:
        occupied_seats += 1

  return occupied_seats



def test_adjacent_seats():
#  assert(['L','.','L','L','L','L','.','L'] == adjacent_seats((1,1), sample_floor_layout))
#  assert(['.','.','.','.','.','.','L','L'] == adjacent_seats((0,0), sample_floor_layout))
#  assert(['.','L','.','L','.','.','.','.'] == adjacent_seats((9,9), sample_floor_layout))
  assert(['#','#','#','#','#','#','#','#'] == adjacent_seats((4,3), sample_seats_in_all_directions))
  assert(['.','.','.','.','#','.','#','.'] == adjacent_seats((0,0), sample_seats_in_all_directions))

def test_should_terminate_after_stabilization():
  print(iterations_until_stabilization(sample_floor_layout))
  assert(26 == iterations_until_stabilization(sample_floor_layout))

def test_can_generate_new_floor_layout():
  assert(sample_intermediate_layout_2 == next_seat_map(sample_intermediate_layout_1))
  
def test_should_update_seat():
  all_floor = [floor] * 8
  all_unoccupied = [unoccupied] * 8
  all_occupied = [occupied] * 8
  half_occupied = ([occupied]*5) + ([]*3)
  one_occupied = ([unoccupied]*7) + [occupied]

  assert(floor == seat_update(floor,all_floor))
  assert(floor == seat_update(floor,all_unoccupied))
  assert(floor == seat_update(floor,all_occupied))
  assert(floor == seat_update(floor,half_occupied))

  assert(occupied == seat_update(unoccupied,all_floor))
  assert(occupied == seat_update(unoccupied,all_unoccupied))
  assert(unoccupied == seat_update(unoccupied,all_occupied))
  assert(unoccupied == seat_update(unoccupied,half_occupied))
  assert(unoccupied == seat_update(unoccupied,one_occupied))

  assert(occupied == seat_update(occupied,all_floor))
  assert(occupied == seat_update(occupied,all_unoccupied))
  assert(unoccupied == seat_update(occupied,all_occupied))
  assert(unoccupied == seat_update(occupied,half_occupied))

test_should_update_seat()
test_adjacent_seats()
test_can_generate_new_floor_layout()
test_should_terminate_after_stabilization()

input = open("input.txt", "r").readlines()
floor_layout =  [x.strip() for x in input]

def part2():
  return iterations_until_stabilization(floor_layout)

print(part2())
