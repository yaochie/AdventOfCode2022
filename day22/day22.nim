import std/[math, strutils, tables]

type
  Coord = tuple[r, c: int]
  Facing = enum Right, Down, Left, Up

const offsets = {
  Right: (0, 1), Down: (1, 0), Left: (0, -1), Up: (-1, 0)
}.toTable()

var board = initTable[Coord, bool]()

var boardDone = false
var steps = newSeq[string]()
var startPos: Coord

# read input
var i = 0
for line in lines("day22.txt"):
  i += 1
  if line == "":
    # next line is the instruction 
    boardDone = true
    continue

  if boardDone:
    # read steps
    var accum = newSeq[char]()
    for c in line:
      if c == 'L' or c == 'R':
        if accum.len() > 0:
          steps.add(accum.join(""))
          accum = newSeq[char]()
        steps.add($c)
      else:
        accum.add(c)

    if accum.len() > 0:
      steps.add(accum.join(""))
    continue

  var j = 0
  for c in line:
    j += 1
    if c == ' ':
      continue

    if board.len() == 0:
      startPos = (i, j)
    board[(i, j)] = (c == '#')

echo steps.len()
echo startPos
# echo board

# Part 1 - simulate steps

# var facing = 0
var facing = Right
var (r, c) = startPos

for step in steps:
  if step == "R":
    facing = Facing(floorMod(ord(facing) + 1, 4))

  elif step == "L":
    facing = Facing(floorMod(ord(facing) - 1, 4))
    
  else:
    let numSteps = parseInt(step)
    let (offR, offC) = offsets[facing]

    for _ in 0..<numSteps:
      var nextR = r + offR
      var nextC = c + offC

      if not board.contains((nextR, nextC)):
        # wrap to other side

        let (otherR, otherC) = (-offR, -offC)
        var wrapR = r
        var wrapC = c
        while board.contains((wrapR + otherR, wrapC + otherC)):
          wrapR += otherR
          wrapC += otherC

        nextR = wrapR
        nextC = wrapC
      
      if not board[(nextR, nextC)]:
        # empty space - can move there
        r = nextR
        c = nextC

echo "Part 1 answer: ", r * 1000 + c * 4 + ord(facing)

# Part 2: cube walking

# Hard-code the direction changes based on my specific cube?

# top middle <-> bbl left
# tr top     <-> bbl bottom
# tr right   <-> b right
# tr bottom  <-> mid right
# top left   <-> bl left
# mid left   <-> bl top
# b bottom   <-> bbl right

facing = Right
(r, c) = startPos

for step in steps:
  if step == "R":
    facing = Facing(floorMod(ord(facing) + 1, 4))
  elif step == "L":
    facing = Facing(floorMod(ord(facing) - 1, 4))
  else:
    let numSteps = parseInt(step)

    for _ in 0..<numSteps:
      let (offR, offC) = offsets[facing]
      var nextR = r + offR
      var nextC = c + offC
      var nextFacing = facing

      if not board.contains((nextR, nextC)):
        # wrap to other side

        if nextR == 0 and nextC in 51..100:
          # top middle -> bbl left
          (nextR, nextC) = (nextC + 100, 1)
          assert facing == Up
          nextFacing = Right

        elif nextC == 0 and nextR in 151..200:
          # bbl left -> top middle
          (nextR, nextC) = (1, nextR - 100)
          assert facing == Left
          nextFacing = Down

        elif nextR == 0 and nextC in 101..150:
          # tr top -> bbl bottom
          (nextR, nextC) = (200, nextC - 100)
          assert facing == Up
          nextFacing = Up

        elif nextR == 201 and nextC in 1..50:
          # bbl bottom -> tr top
          (nextR, nextC) = (1, nextC + 100)
          assert facing == Down
          nextFacing = Down

        elif nextR in 1..50 and nextC == 151:
          # tr right -> b right
          (nextR, nextC) = (151 - nextR, 100)
          assert facing == Right
          nextFacing = Left
        
        elif nextR in 101..150 and nextC == 101:
          # b right -> tr right
          (nextR, nextC) = (151 - nextR, 150)
          assert facing == Right
          nextFacing = Left

        elif nextR == 51 and nextC in 101..150 and facing == Down:
          # tr bottom -> mid right
          (nextR, nextC) = (nextC - 50, 100)
          assert facing == Down
          nextFacing = Left
        
        elif nextR in 51..100 and nextC == 101 and facing == Right:
          # mid right -> tr bottom
          (nextR, nextC) = (50, nextR + 50)
          assert facing == Right
          nextFacing = Up

        elif nextR in 1..50 and nextC == 50:
          # top left -> bl left
          (nextR, nextC) = (151 - nextR, 1)
          assert facing == Left
          nextFacing = Right

        elif nextR in 101..150 and nextC == 0:
          # bl left -> top left
          (nextR, nextC) = (151 - nextR, 51)
          assert facing == Left
          nextFacing = Right

        elif nextR in 51..100 and nextC == 50 and facing == Left:
          # mid left -> bl top
          (nextR, nextC) = (101, nextR - 50)
          assert facing == Left
          nextFacing = Down

        elif nextR == 100 and nextC in 1..50 and facing == Up:
          # bl top -> mid left
          (nextR, nextC) = (nextC + 50, 51)
          assert facing == Up
          nextFacing = Right

        elif nextR == 151 and nextC in 51..100 and facing == Down:
          # b bottom -> bbl right
          (nextR, nextC) = (nextC + 100, 50)
          assert facing == Down
          nextFacing = Left
        
        elif nextR in 151..200 and nextC == 51 and facing == Right:
          # bbl right -> b bottom
          (nextR, nextC) = (150, nextR - 100)
          assert facing == Right
          nextFacing = Up

        else:
          # shouldn't reach here
          assert false

        # echo "Crossed ", (r, c, facing), " -> ", (nextR, nextC, nextFacing)

      if not board[(nextR, nextC)]:
        # empty space - can move there
        r = nextR
        c = nextC
        facing = nextFacing

echo "Part 2 answer: ", r * 1000 + c * 4 + ord(facing)