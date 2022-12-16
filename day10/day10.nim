import math
import strutils
import sugar
import sets

var x = 1
var cycle = 1 
var totalStrength = 0

let lines = collect(newSeq):
  for line in lines("day10.txt"): line

for line in lines:
  if line == "noop":
    if cycle < 240 and floorMod(cycle + 20, 40) == 0:
      totalStrength += cycle * x
    cycle += 1

  else:
    # addx
    if cycle < 240 and floorMod(cycle + 20, 40) == 0 or
        floorMod(cycle + 21, 40) == 0:
      let tempCycle = floorDiv(cycle + 21, 40) * 40 - 20
      totalStrength += tempCycle * x
      
    cycle += 2
    x += parseInt(line.splitWhitespace()[1])

echo totalStrength

# part 2
x = 1
cycle = 0

var diagram = initHashSet[int]()

for line in lines:
  if line == "noop":
    if abs(floorMod(cycle, 40) - x) <= 1:
      diagram.incl(cycle)
    cycle += 1

  else:
    # addx
    if abs(floorMod(cycle, 40) - x) <= 1:
      diagram.incl(cycle)
    cycle += 1
    if abs(floorMod(cycle, 40) - x) <= 1:
      diagram.incl(cycle)
    cycle += 1

    x += parseInt(line.splitWhitespace()[1])

# draw
echo "Diagram:\n"

for r in 0 ..< 6:
  for c in 0 ..< 40:
    if diagram.contains(r * 40 + c):
      stdout.write "#"
    else:
      stdout.write " "
  
  stdout.write "\n"
