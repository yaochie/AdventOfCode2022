import std/[enumerate, sugar]

const W = 99
const H = 99

let inputLines = collect(newSeq):
  for line in lines("day8.txt"): line

# array?
var map: array[H, array[W, int]]

# echo inputLines.len()
# echo inputLines[0].len()

for i, line in enumerate(inputLines):
  for j, c in enumerate(line):
    map[i][j] = int(c)

proc isVisible(map: array[H, array[W, int]], i: int, j: int): bool =
  let val = map[i][j]
  # left
  var leftVisible = true
  for a in countdown(j-1, 0):
    if map[i][a] >= val:
      leftVisible = false
      break
  if leftVisible:
    return true
  
  # right
  var rightVisible = true
  for a in countup(j+1, W-1):
    if map[i][a] >= val:
      rightVisible = false
      break
  if rightVisible:
    return true

  # top
  var topVisible = true
  for a in countdown(i-1, 0):
    if map[a][j] >= val:
      topVisible = false
      break
  if topVisible:
    return true

  # bottom
  var bottomVisible = true
  for a in countup(i+1, H-1):
    if map[a][j] >= val:
      bottomVisible = false
      break
  
  return bottomVisible

proc part1(map: array[H, array[W, int]]) =
  var numVisible = 0
  for i in 1..<H-1:
    for j in 1..<W-1:
      if isVisible(map, i, j):
        numVisible += 1

  echo numVisible + H + H + W + W - 4

part1(map)

proc getScenicScore(map: array[H, array[W, int]], i: int, j: int): int =
  let val = map[i][j]
  
  var leftScore = 0
  for a in countdown(j-1, 0):
    leftScore += 1
    if map[i][a] >= val:
      break

  var rightScore = 0
  for a in countup(j+1, W-1):
    rightScore += 1
    if map[i][a] >= val:
      break
  
  var topScore = 0
  for a in countdown(i-1, 0):
    topScore += 1
    if map[a][j] >= val:
      break
  
  var bottomScore = 0
  for a in countup(i+1, H-1):
    bottomScore += 1
    if map[a][j] >= val:
      break

  leftScore * rightScore * topScore * bottomScore

proc part2(map: array[H, array[W, int]]) =
  var maxScore = 0
  for i in 0..<H:
    for j in 0..<W:
      maxScore = max(maxScore, getScenicScore(map, i, j))
  
  echo maxScore

part2(map)
