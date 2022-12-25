import std/[deques, enumerate, math, sets, sugar]

type
  Blizzard = tuple[r, c, offR, offC: int]
  State = tuple[r, c, t: int]
  Coord = tuple[r, c: int]

var blizzards = initHashSet[Blizzard]()

const offsets = [
  (0, 0),
  (-1, 0),
  (0, -1),
  (0, 1),
  (1, 0),
]

let lines = collect(newSeq):
  for line in lines("day24.txt"): line

for i, line in enumerate(1, lines[1..^2]):
  for j, c in enumerate(1, line[1..^2]):
    if c == '.':
      continue
    
    var b: Blizzard
    if c == '>':
      b = (i, j, 0, 1)
    elif c == '<':
      b = (i, j, 0, -1)
    elif c == 'v':
      b = (i, j, 1, 0)
    elif c ==  '^':
      b = (i, j, -1, 0)
    else:
      echo (i, j, c)
      assert false

    assert not blizzards.contains(b)
    blizzards.incl(b)
    
# echo blizzards
echo blizzards.len()

let height = lines.len() - 2
let width = lines[0].len() - 2
# assume endpoint is always at the last point
var endpoint = (height, width)

echo endpoint
echo (height, width)

# BFS?
# state: curr pos, t

proc getCurrPos(t: int, b: Blizzard): Coord =
  let newR = floorMod(b.r + t * b.offR - 1, height) + 1
  let newC = floorMod(b.c + t * b.offC - 1, width) + 1
  (newR, newC)

proc getPos(t: int): HashSet[Coord] =
  result = initHashSet[Coord]()
  for b in blizzards.items:
    result.incl(getCurrPos(t, b))

echo "============"
var startpoint = (0, 1)
var startTime = 0
var toVisit: Deque[State] = [(0, 1, 0)].toDeque()
var visited = initHashSet[State]()

# faster solution
# cache blizzard locations
# then can just do a lookup
var blizPos = HashSet[Coord]()
var blizT = 0

while toVisit.len() > 0:
  let (r, c, t) = toVisit.popFirst()
  if (r, c) == endpoint:
    # next to exit, we can escape
    echo "Part 1 answer: ", t + 1
    startTime = t + 1
    break

  # echo (r, c, t)

  # can stay at the startpoint
  if (r, c) == (0, 1):
    toVisit.addLast((r, c, t + 1))

  if t == blizT:
    # Calculate blizzard locations for next time step.
    # Since we are doing BFS, we won't need the previous
    # time steps' locations anymore.
    blizPos = getPos(t + 1)
    blizT = t + 1

  for offR, offC in offsets.items:
    let (newR, newC) = (r + offR, c + offC)
    if visited.contains((newR, newC, t + 1)):
      continue

    # check if it is a wall or blizzard
    if newR < 1 or height < newR or newC < 1 or width < newC:
      continue

    # echo (newR, newC)

    if blizPos.contains((newR, newC)):
      continue

    toVisit.addLast((newR, newC, t + 1))
    visited.incl((newR, newC, t + 1))
    # echo "Put ",  (r, c, t), " -> ", (newR, newC, t + 1)

# back from end to start
startpoint = (height + 1, width)
toVisit = [(height + 1, width, startTime)].toDeque
visited.clear()
endpoint = (1, 1)

while toVisit.len() > 0:
  let (r, c, t) = toVisit.popFirst()
  if (r, c) == endpoint:
    # next to exit, we can escape
    echo "Going back: ", t + 1
    startTime = t + 1
    break

  # can stay at the startpoint
  if (r, c) == startpoint:
    toVisit.addLast((r, c, t + 1))

  if t == blizT:
    # Calculate blizzard locations for next time step.
    # Since we are doing BFS, we won't need the previous
    # time steps' locations anymore.
    blizPos = getPos(t + 1)
    blizT = t + 1

  for offR, offC in offsets.items:
    let (newR, newC) = (r + offR, c + offC)
    if visited.contains((newR, newC, t + 1)):
      continue

    # check if it is a wall or blizzard
    if newR < 1 or height < newR or newC < 1 or width < newC:
      continue

    if blizPos.contains((newR, newC)):
      continue

    toVisit.addLast((newR, newC, t + 1))
    visited.incl((newR, newC, t + 1))

# from start to end again
startpoint = (0, 1)
toVisit = [(0, 1, startTime)].toDeque
visited.clear()
endpoint = (height, width)

while toVisit.len() > 0:
  let (r, c, t) = toVisit.popFirst()
  if (r, c) == endpoint:
    # next to exit, we can escape
    echo "Part 2 answer: ", t + 1
    break

  # can stay at the startpoint
  if (r, c) == startpoint:
    toVisit.addLast((r, c, t + 1))

  if t == blizT:
    # Calculate blizzard locations for next time step.
    # Since we are doing BFS, we won't need the previous
    # time steps' locations anymore.
    blizPos = getPos(t + 1)
    blizT = t + 1

  for offR, offC in offsets.items:
    let (newR, newC) = (r + offR, c + offC)
    if visited.contains((newR, newC, t + 1)):
      continue

    # check if it is a wall or blizzard
    if newR < 1 or height < newR or newC < 1 or width < newC:
      continue

    if blizPos.contains((newR, newC)):
      continue

    toVisit.addLast((newR, newC, t + 1))
    visited.incl((newR, newC, t + 1))