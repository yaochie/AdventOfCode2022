import std/[math, tables, sets, sugar]

type Coord = tuple[x, y: int]

let f = open("day17.txt")
let windseq = f.readAll()
f.close()

echo "Wind sequence length: ", windseq.len()

# falling with collision detection

const blockSeq: seq[seq[Coord]] = @[
  @[(2, 0), (3, 0), (4, 0), (5, 0)],
  @[(3, 0), (2, 1), (3, 1), (4, 1), (3, 2)],
  @[(2, 0), (3, 0), (4, 0), (4, 1), (4, 2)],
  @[(2, 0), (2, 1), (2, 2), (2, 3)],
  @[(2, 0), (3, 0), (2, 1), (3, 1)]
]
const numBlocks = blockSeq.len()

var occupied = initHashSet[Coord]()

const floorY = 0
var topY = floorY
var windIndex = 0
for blockNum in 0..<2022:
  let i = floorMod(blockNum, numBlocks)

  var currPos: HashSet[Coord] = collect(initHashSet):
    for x, y in blockSeq[i].items: {(x, y + topY + 4)}

  while true:
    # shift by wind
    let currWind = windseq[floorMod(windIndex, windseq.len())]

    let xOffset = if currWind == '>': 1 else: -1
    var moved = true
    var newPos = initHashSet[Coord]()
    for x, y in currPos.items:
      let newX = x + xOffset
      if newX < 0 or 7 <= newX or occupied.contains((newX, y)):
        moved = false
        break
      newPos.incl((newX, y))

    if moved:
      currPos = newPos

    windIndex += 1

    # drop by 1, stopping if can't drop anymore
    let yOffset = -1
    moved = true
    newPos = initHashSet[Coord]()
    for x, y in currPos.items:
      let newY = y + yOffset
      if newY <= floorY or occupied.contains((x, newY)):
        moved = false
        break
      newPos.incl((x, newY))

    if moved:
      currPos = newPos
    else:
      break

  for pos in currPos.items:
    topY = max(topY, pos.y)
    occupied.incl(pos)

  # echo blockNum, ' ', topY, ' ', occupied.len()

echo "Part 1 answer: ", topY

# part 2 - same as part 1, but detect a cycle and
# use that to calculate the final height

# reset
occupied = initHashSet[Coord]()
topY = floorY
windIndex = 0

var pairs = initCountTable[(int, int)]()
var topDiff = newSeq[int]()
var foundCycle = false
var cycleStart: (int, int)

for blockNum in 0..<20000:
  let i = floorMod(blockNum, numBlocks)
  let j = floorMod(windIndex, windseq.len())

  if pairs[(i, j)] > 2 and not foundCycle:
    echo "Found cycle start (after 2): ", blockNum
    cycleStart = (i, j)
    echo "blockNum and windIndex: ", cyclestart
    foundCycle = true

  elif foundCycle and (i, j) == cycleStart:
    # finished cycle, calculate final result
    let cycleDiff = sum(topDiff)
    let cycleLength = topDiff.len()

    echo "Cycle length : ", topDiff.len()
    echo "Cycle diff   : ", cycleDiff

    let x = 1_000_000_000_000 - blockNum
    let numRounds = floorDiv(x, cycleLength)
    let remaining = floorMod(x, cycleLength)

    let answer = topY + numRounds * cycleDiff + sum(topDiff[0..<remaining])
    echo "Part 2 answer: ", answer
    break

  pairs.inc((i, j))

  var currPos: HashSet[Coord] = collect(initHashSet):
    for x, y in blockSeq[i].items: {(x, y + topY + 4)}

  while true:
    # shift by wind
    let currWind = windseq[floorMod(windIndex, windseq.len())]

    let xOffset = if currWind == '>': 1 else: -1
    var moved = true
    var newPos = initHashSet[Coord]()
    for x, y in currPos.items:
      let newX = x + xOffset
      if newX < 0 or 7 <= newX or occupied.contains((newX, y)):
        moved = false
        break
      newPos.incl((newX, y))

    if moved:
      currPos = newPos

    windIndex += 1

    # drop by 1, stopping if can't drop anymore
    let yOffset = -1
    moved = true
    newPos = initHashSet[Coord]()
    for x, y in currPos.items:
      let newY = y + yOffset
      if newY <= floorY or occupied.contains((x, newY)):
        moved = false
        break
      newPos.incl((x, newY))

    if moved:
      currPos = newPos
    else:
      break

  var newTopY = topY
  for pos in currPos.items:
    newTopY = max(newTopY, pos.y)
    occupied.incl(pos)

  if foundCycle:
    topDiff.add(newTopY - topY)
  topY = newTopY