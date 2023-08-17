def location(row, geology, slope):
  return geology[((row*slope) % len(geology))]

input = open("input.txt", "r").readlines()
tree_map = map(lambda x: x.strip(), input)



def trees_encountered(tree_map, slope):
  locations = [location(*x, slope=slope) for x in enumerate(tree_map)]
  trees = [x for x in locations if x == '#']
  return len(trees)


slope_1 = trees_encountered(tree_map, 1)
slope_2 = trees_encountered(tree_map, 3)
slope_3 = trees_encountered(tree_map, 5)
slope_4 = trees_encountered(tree_map, 7)
slope_5 = trees_encountered(tree_map[::2], 1)

print(slope_1 * slope_2 * slope_3 *slope_4 * slope_5)
