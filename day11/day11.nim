import std/[algorithm, deques, math, strutils, sugar]

var items: seq[seq[int]] = @[]
var divs: seq[int] = @[]
var trues: seq[int] = @[]
var falses: seq[int] = @[]

let lines = collect(newSeq):
  for line in lines("day11.txt"): line

# parse
var i = 0
while i < lines.len():
  let monkeyItems = collect(newSeq):
    for i in lines[i+1][18..^1].split(", "): parseInt(i)

  let monkeyDiv = parseInt(lines[i+3][21..^1])
  items.add(monkeyItems)
  divs.add(monkeyDiv)
  trues.add(parseInt(lines[i+4][29..^1]))
  falses.add(parseInt(lines[i+5][30..^1]))

  i += 7

echo items
echo divs
echo trues
echo falses

# part 1: simulate 20 times
func doOp(worry: int, monkeyId: 0..7): int =
  ## hardcoded, since too troublesome to parse
  case monkeyId:
  of 0: return worry * 3
  of 1: return worry * 17
  of 2: return worry + 1
  of 3: return worry + 2
  of 4: return worry * worry
  of 5: return worry + 8
  of 6: return worry + 6
  of 7: return worry + 7

proc part1(items: seq[seq[int]], divs: seq[int],
           trues: seq[int], falses: seq[int]) =
  var modItems = collect(newSeq):
    for itemList in items: itemList.toDeque

  var counts = newSeq[int](modItems.len())
  for _ in 1..20:
    for i in 0..<modItems.len():
      while modItems[i].len() > 0:
        let worry = doOp(modItems[i].popFirst(), i)
        let newWorry = floorDiv(worry, 3)

        if floorMod(newWorry, divs[i]) == 0:
          modItems[trues[i]].addLast(newWorry)
        else:
          modItems[falses[i]].addLast(newWorry)
        counts[i] += 1

  sort(counts, order=SortOrder.Descending)
  echo counts[0] * counts[1]

part1(items, divs, trues, falses)

# part 2 - 10000 times, worry doesn't drop
# keep track of modulos!
proc doOp2(worry: var seq[int], divs: seq[int], monkeyId: 0..7) =
  case monkeyId:
  of 0:
    for i in 0..7:
      worry[i] = floorMod(worry[i] * 3, divs[i])
  of 1:
    for i in 0..7:
      worry[i] = floorMod(worry[i] * 17, divs[i])
  of 2:
    for i in 0..7:
      worry[i] = floorMod(worry[i] + 1, divs[i])
  of 3:
    for i in 0..7:
      worry[i] = floorMod(worry[i] + 2, divs[i])
  of 4:
    for i in 0..7:
      worry[i] = floorMod(worry[i] * worry[i], divs[i])
  of 5:
    for i in 0..7:
      worry[i] = floorMod(worry[i] + 8, divs[i])
  of 6:
    for i in 0..7:
      worry[i] = floorMod(worry[i] + 6, divs[i])
  of 7:
    for i in 0..7:
      worry[i] = floorMod(worry[i] + 7, divs[i])

var modItems = newSeq[Deque[seq[int]]]()
for itemList in items:
  var modDeque = initDeque[seq[int]]()
  for item in itemList:
    var mods = newSeq[int]()
    for divisor in divs:
      mods.add(floorMod(item, divisor))
    modDeque.addLast(mods)
  
  modItems.add(modDeque)

echo modItems

var counts = newSeq[int](modItems.len())
for _ in 1..10000:
  for i in 0..<modItems.len():
    while modItems[i].len() > 0:
      var worry = modItems[i].popFirst()
      doOp2(worry, divs, i)

      if worry[i] == 0:
        modItems[trues[i]].addLast(worry)
      else:
        modItems[falses[i]].addLast(worry)
      counts[i] += 1

sort(counts, order=SortOrder.Descending)
echo counts[0] * counts[1]