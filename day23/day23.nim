import std/[deques, sets, tables]

type Coord = tuple[r, c: int]

var orig = initHashSet[Coord]()

var i = 0
for line in lines("day23.txt"):
  i += 1

  var j = 0
  for c in line:
    j += 1

    if c == '#':
      orig.incl((i, j))

echo orig.len()

const moveOrder = [
  ((-1, 0), [(-1, 0), (-1, -1), (-1, 1)]),
  ((1, 0), [(1, 0), (1, -1), (1, 1)]),
  ((0, -1), [(0, -1), (1, -1), (-1, -1)]),
  ((0, 1), [(0, 1), (1, 1), (-1, 1)]),
]

const surround = [
  (-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)
]

proc part1Answer(map: HashSet[Coord]) =
  var minR, maxR, minC, maxC: int
  for r, c in map.items:
    minR = r
    maxR = r
    minC = c
    maxC = c
    break

  for r, c in map.items:
    minR = min(minR, r)
    maxR = max(maxR, r)
    minC = min(minC, c)
    maxC = max(maxC, c)

  let area = (maxR - minR + 1) * (maxC - minC + 1)
  echo "Part 1 answer: ", area - map.len()

# do the simulation
let numElves = orig.len()

var map = orig
var currOrder = moveOrder.toDeque
for i in 1..10000:
  # first half - propose move
  var proposedMoves = initTable[Coord, Coord]()
  var moveCount = initCountTable[Coord]()

  for r, c in map.items:
    # don't move if surrounding is empty
    var stay = true
    for offR, offC in surround.items:
      if map.contains((r + offR, c + offC)):
        stay = false
        break

    if stay:
      continue

    # find proposed move direction
    for move, toCheck in currOrder.items:
      var canMove = true
      for offR, offC in toCheck.items:
        if map.contains((r + offR, c + offC)):
          canMove = false
          break

      if canMove:
        let (moveR, moveC) = move
        let newPos = (r + moveR, c + moveC)
        proposedMoves[(r, c)] = newPos
        moveCount.inc(newPos)
        break
  
  # echo proposedMoves.len()

  var numMoves = 0
  for oldPos, newPos in proposedMoves.pairs:
    if moveCount[newPos] > 1:
      continue

    map.excl(oldPos)
    map.incl(newPos)

    numMoves += 1

  if numMoves == 0:
    # Part 2
    echo "Part 2 answer: ", i
    break

  # update move order
  let temp = currOrder.popFirst()
  currOrder.addLast(temp)

  # echo map
  assert map.len() == numElves

  if i == 10:
    part1Answer(map)
