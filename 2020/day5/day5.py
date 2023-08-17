
import math

def _row_assignment(assignment, low, high):
  if len(assignment) == 0:
    return low

  if assignment[0] == 'F':
    return _row_assignment(assignment[1:], low, math.floor((high+low)/2))
  if assignment[0] == 'B':
    return _row_assignment(assignment[1:], math.ceil((high+low)/2), high)

def row_assignment(row):
  return _row_assignment(row, 0, 127)

def _seat_assignment(assignment, low, high):
  if len(assignment) == 0:
    return low

  if assignment[0] == 'L':
    return _seat_assignment(assignment[1:], low, math.floor((high+low)/2))
  if assignment[0] == 'R':
    return _seat_assignment(assignment[1:], math.ceil((high+low)/2), high)


def seat_assignment(seat):
  return _seat_assignment(seat, 0, 7)

def row_and_seat_assignment(assignment):
  row = assignment[:7]
  seat = assignment[7:]

  return (row_assignment(row), seat_assignment(seat))

def seat_id(row, seat):
  return row * 8 + seat

input = open("input.txt", "r").readlines()
boarding_passes =  [x.strip() for x in input]

def highest_seat_id(boarding_passes):
  rows_and_seats = [row_and_seat_assignment(x) for x in boarding_passes]
  seat_ids = [seat_id(*x) for x in rows_and_seats]
  return max(seat_ids)

def missing_seat_id(boarding_passes):
  rows_and_seats = [row_and_seat_assignment(x) for x in boarding_passes]
  seat_ids = [seat_id(*x) for x in rows_and_seats]
  seat_ids.sort()
  seat_pairs = zip(seat_ids, seat_ids[1:])

  for x in seat_pairs:
    if (x[1] - x[0]) != 1:
      return x[0] + 1

print(highest_seat_id(boarding_passes))
print(missing_seat_id(boarding_passes))

def test_row_assignment():
  assert(70 == row_assignment('BFFFBBF'))
  assert(14 == row_assignment('FFFBBBF'))
  assert(102 == row_assignment('BBFFBBF'))

def test_seat_assignment():
  assert(7 == seat_assignment('RRR'))
  assert(4 == seat_assignment('RLL'))

def test_row_and_seat_assignment():
  assert((70, 7) == row_and_seat_assignment('BFFFBBFRRR'))

def test_seat_id():
  assert(567 == seat_id(70, 7))

test_row_assignment()
test_seat_assignment()
test_row_and_seat_assignment()
test_seat_id()
