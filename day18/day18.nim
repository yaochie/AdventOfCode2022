import std/[sets, strutils, sugar]

type Coord = tuple[x, y, z: int]

var cubes = initHashSet[Coord]()

for line in lines("day18.txt"):
  let parts = line.split(",")
  cubes.incl((parseInt(parts[0]), parseInt(parts[1]), parseInt(parts[2])))

const offsets = [
  (-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)
]

# part 1
# check all adjacent cubes - if not already a cube, then that side
# is exposed.

var numExposed = 0
for x, y, z in cubes.items:
  for a, b, c in offsets.items:
    let newCoord = (x+a, y+b, z+c)
    if not cubes.contains(newCoord):
      numExposed += 1

echo "Part 1 answer: ", numExposed

# part 2
# flood-fill the outside
# then do the same thing as part one, but also check if the adjacent space is
# in the flood-fill.

let xes = collect(newSeq):
  for x, _, _ in cubes.items: x
let yes = collect(newSeq):
  for _, y, _ in cubes.items: y
let zes = collect(newSeq):
  for _, _, z in cubes.items: z

# add/subtract 1 so that the exterior is connected when we flood-fill
# (otherwise need to add/subtract 1 for each check)
let
  minX = min(xes) - 1
  maxX = max(xes) + 1
  minY = min(yes) - 1
  maxY = max(yes) + 1
  minZ = min(zes) - 1
  maxZ = max(zes) + 1

echo minX, ' ' , maxX
echo minY, ' ' , maxY
echo minZ, ' ' , maxZ

var exterior = initHashSet[Coord]()
var toVisit = newSeq[Coord]()
toVisit.add((minX, minY, minZ))

while toVisit.len() > 0:
  let currCoord = toVisit.pop()
  exterior.incl(currCoord)
  let (x, y, z) = currCoord

  for a, b, c in offsets.items:
    let newX = x + a
    let newY = y + b
    let newZ = z + c

    if newX < minX or maxX < newX or
       newY < minY or maxY < newY or
       newZ < minZ or maxZ < newZ:
      # out of bounds
      continue

    let newCoord = (newX, newY, newZ)
    if exterior.contains(newCoord) or cubes.contains(newCoord):
      continue

    toVisit.add(newCoord)

echo "Total exterior cubes: ", exterior.len()

numExposed = 0
for x, y, z in cubes.items:
  for a, b, c in offsets.items:
    let newCoord = (x+a, y+b, z+c)
    if exterior.contains(newCoord) and not cubes.contains(newCoord):
      numExposed += 1

echo "Part 2 answer: ", numExposed