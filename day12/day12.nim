import tables
import std/enumerate
import deques

type
  Coord = tuple
    x: int
    y: int
  BFSItem = tuple
    x: int
    y: int
    distance: int

var
  heightmap = initTable[Coord, char]()
  startPos: Coord
  endPos: Coord

for i, line in enumerate(lines("day12.txt")):
  for j, c in enumerate(line):
    if c == 'S':
      startPos = (i, j)
      heightmap[startPos] = 'a'
    elif c == 'E':
      endPos = (i, j)
      heightmap[endPos] = 'z'
    else:
      heightmap[(i, j)] = c

# echo heightmap
# echo startPos, ' ', heightmap[startPos]
# echo endPos, ' ', heightmap[endPos]

proc part1(heightmap: Table[Coord, char], startPos: Coord, endPos: Coord): int =
  ## BFS from start to end point
  var distances = initTable[Coord, int]()
  var toVisit = initDeque[BFSItem]()
  toVisit.addLast((startPos[0], startPos[1], 0))

  const offsets = [(-1, 0), (1, 0), (0, -1), (0, 1)]

  while toVisit.len() > 0:
    let (x, y, distance) = toVisit.popFirst()

    if distances.contains((x, y)):
      continue

    # since BFS, guaranteed to be minimum
    distances[(x, y)] = distance

    # add neighbours
    let height = heightmap[(x, y)]

    for (i, j) in offsets:
      let x2 = x + i
      let y2 = y + j
      let nextPos = (x2, y2)

      if not heightmap.contains(nextPos):
        continue

      if nextPos == endPos and (height == 'y' or height == 'z'):
        return distance + 1

      let h = heightmap[nextPos]
      if int(h) <= int(height) + 1:
        toVisit.addLast((x2, y2, distance + 1))

  # shouldn't reach here
  assert false

echo part1(heightmap, startPos, endPos)

proc part2(heightmap: Table[Coord, char], startPos: Coord): int =
  ## BFS from start to any lowest point
  var distances = initTable[Coord, int]()
  var toVisit = initDeque[BFSItem]()
  toVisit.addLast((startPos[0], startPos[1], 0))

  const offsets = [(-1, 0), (1, 0), (0, -1), (0, 1)]

  while toVisit.len() > 0:
    let (x, y, distance) = toVisit.popFirst()

    if distances.contains((x, y)):
      continue

    # since BFS, guaranteed to be minimum
    distances[(x, y)] = distance

    # add neighbours
    let height = heightmap[(x, y)]
    for (i, j) in offsets:
      let x2 = x + i
      let y2 = y + j
      let nextPos = (x2, y2)

      if not heightmap.contains(nextPos):
        continue

      let h = heightmap[nextPos]
      if height == 'b' and h == 'a':
        return distance + 1

      if int(h) >= int(height) - 1:
        toVisit.addLast((x2, y2, distance + 1))

  # shouldn't reach here
  assert false

echo part2(heightmap, endPos)