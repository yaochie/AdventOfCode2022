import std/[sets, strutils, sugar]

type
  Coord = tuple
    x: int
    y:int

var blocked = initHashSet[Coord]()

func parseCoord(text: string): Coord =
  let parts = text.split(",")
  (parseInt(parts[0]), parseInt(parts[1]))

for line in lines("day14.txt"):
  let coords = collect(newSeq):
    for c in line.split(" -> "): parseCoord(c)
  
  blocked.incl(coords[0])
  var (prevX, prevY) = coords[0]

  # add from previous to next coord
  for (nextX, nextY) in coords[1..^1]:
    if nextX == prevX:
      if nextY > prevY:
        for y in countup(prevY + 1, nextY):
          blocked.incl((nextX, y))
      else:
        for y in countdown(prevY - 1, nextY):
          blocked.incl((nextX, y))

    else:
      # nextY == prevY
      if nextX > prevX:
        for x in countup(prevX + 1, nextX):
          blocked.incl((x, nextY))
      else:
        for x in countdown(prevX - 1, nextX):
          blocked.incl((x, nextY))

    (prevX, prevY) = (nextX, nextY)

echo "# of blocked squares: ", blocked.len()

const start: Coord = (500, 0)
const offsets = [(0, 1), (-1, 1), (1, 1)]

# get max Y
var maxY = 0
for _, y in blocked.items:
  maxY = max(maxY, y)
echo "Max Y: ", maxY

# part 1 - simulate sand dropping
proc part1(orig: HashSet[Coord], maxY: int) =
  var blocked = orig
  var numDropped = 0

  # drop sand
  while true:
    var (x, y) = start
    var stopped = false
    while y <= maxY:
      var moved = false
      for offX, offY in offsets.items:
        let newPos = (x + offX, y + offY)

        if not blocked.contains(newPos):
          (x, y) = newPos
          moved = true
          break

      if not moved:
        # stop here
        inc numDropped
        stopped = true
        blocked.incl((x, y))
        break

    if not stopped:
      break

  echo "Part 1 dropped: ", numDropped

part1(blocked, maxY)

# part 2 - simulate sand dropping with floor

proc part2(orig: HashSet[Coord], maxY: int) =
  var blocked = orig
  var numDropped = 0
  while not blocked.contains(start):
    var (x, y) = start
    var stopped = false

    # drop sand
    while y <= maxY:
      var moved = false
      for offX, offY in offsets.items:
        let newPos = (x + offX, y + offY)

        if not blocked.contains(newPos):
          (x, y) = newPos
          moved = true
          break

      if not moved:
        # stop here
        inc numDropped
        stopped = true
        blocked.incl((x, y))
        break

    if stopped:
      continue

    # stop on floor
    if not blocked.contains((x, y)):
      inc numDropped
      blocked.incl((x, y))
      continue

    break

  echo "Part 2 dropped: ", numDropped

part2(blocked, maxY)