import re
total = 0

import collections
import itertools
import functools

Claim = collections.namedtuple('Claim', 'id x y width height')
Point = collections.namedtuple('Point', 'x y')
Rectangle = collections.namedtuple('Rectangle', 'top_left bottom_right')

def claim_to_rectangle(claim):
  x = claim.x
  y = claim.y
  width = claim.width
  height = claim.height
  top_left = Point(x,y)
  bottom_right = Point(x+width-1,y+height-1)
  return Rectangle(top_left, bottom_right)

prog = re.compile(
    r"""^#(?P<id>\d+?) @ (?P<x>\d+?),(?P<y>\d+?): (?P<w>\d+?)x(?P<h>\d+?)$""")
def parse_claim(line):
  result = prog.match(line)
  claim_id = int(result.group("id"))
  x = int(result.group("x"))
  y = int(result.group("y"))
  width = int(result.group("w"))
  height = int(result.group("h"))
  return Claim(claim_id, x, y, width, height)

def rectangles_overlap(r1, r2):
  if r1.bottom_right.x < r2.top_left.x or r2.bottom_right.x < r1.top_left.x:
    return False

  if r1.bottom_right.y < r2.top_left.y or r2.bottom_right.y < r1.top_left.y:
    return False

  return True
def overlapping_area(r1, r2):
  xs = sorted([r1.top_left.x, r1.bottom_right.x, r2.top_left.x, r2.bottom_right.x])
  ys = sorted([r1.top_left.y, r1.bottom_right.y, r2.top_left.y, r2.bottom_right.y])

  overlapping_coords = {(x,y) for x in range(xs[1], xs[2]+1) for y in range(ys[1], ys[2]+1)}

  return overlapping_coords

#with open("input.txt") as input:
#    for line in input:
#      print(line)
#      claim = parse_claim(line)
#      print(claim)

claims = [parse_claim(c) for c in open("input.txt")]
#claims = [parse_claim(c) for c in ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2", "#4 @ 2,1: 2x2"]]
claim_combinations = [c for c in itertools.combinations(claims, 2)]
overlapping_claims = [c for c in claim_combinations if rectangles_overlap(claim_to_rectangle(c[0]), claim_to_rectangle(c[1]))]
non_overlapping_claims = [c for c in claim_combinations if not rectangles_overlap(claim_to_rectangle(c[0]), claim_to_rectangle(c[1]))]

overlapping_claim_ids = map(lambda x: x.id, {x for l in overlapping_claims for x in l})
non_overlapping_claim_ids = map(lambda x: x.id, {x for l in non_overlapping_claims for x in l})

non_overlapping_claim_ids = set(non_overlapping_claim_ids) - set(overlapping_claim_ids)

print(list(overlapping_claim_ids))
print(list(non_overlapping_claim_ids))

