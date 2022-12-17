import std/[algorithm, enumerate, math, sequtils, strutils, sugar]

type
  ItemKind {.pure.} = enum Integer, List
  Item = ref object
    case kind: ItemKind
    of Integer: value: int
    of List: items: seq[Item]

let lines = collect(newSeq):
  for line in lines("day13.txt"): line

proc splitItems(text: string): seq[string] =
  result = newSeq[string]()
  var level = 0
  var accum = newSeq[char]()
  for c in text:
    if c == '[':
      level += 1
    elif c == ']':
      assert level >= 1
      level -= 1
    elif c == ',' and level == 0:
      result.add(accum.join(""))
      accum = newSeq[char]()
      continue
    accum.add(c)

  if accum.len() > 0:
    result.add(accum.join(""))

proc parsePacket(text: string): Item =
  if text[0] == '[' and text[^1] == ']':
    # list
    result = Item(kind: List)
    var itemTexts = splitItems(text[1..^2])
    result.items = map(itemTexts, parsePacket)
    
  else:
    result = Item(kind: Integer, value: parseInt(text))

func comparePacket(a: Item, b: Item): int =
  if a.kind == Integer and b.kind == Integer:
    if a.value < b.value:
      return -1
    elif a.value > b.value:
      return 1
    else:
      return 0
      
  elif a.kind == List and b.kind == List:
    for (left, right) in zip(a.items, b.items):
      let cmp_val = comparePacket(left, right)
      if cmp_val == 0:
        continue
      elif cmp_val < 0:
        return -1
      else:
        return 1

    if a.items.len() < b.items.len():
      return -1
    elif a.items.len() > b.items.len():
      return 1
    else:
      return 0

  elif a.kind == List and b.kind == Integer:
    return comparePacket(a, Item(kind: List, items: @[b]))

  elif a.kind == Integer and b.kind == List:
    return comparePacket(Item(kind: List, items: @[a]), b)

# part 1
var i = 0
var indexSum = 0
while i < lines.len():
  let leftPacket = parsePacket(lines[i])
  let rightPacket = parsePacket(lines[i+1])
  if comparePacket(leftPacket, rightPacket) < 0:
    indexSum += floorDiv(i, 3) + 1

  i += 3

echo indexSum

# part 2 - sort!
let a = Item(
    kind: List,
    items: @[Item(kind: List, items: @[Item(kind:Integer, value: 2)])]
  )
let b = Item(
    kind: List,
    items: @[Item(kind: List, items: @[Item(kind:Integer, value: 6)])]
  )
var packets = @[a, b]
i = 0
while i < lines.len():
  packets.add(parsePacket(lines[i]))
  packets.add(parsePacket(lines[i+1]))
  i += 3

sort(packets, comparePacket)

var
  first: int
  second: int
for i, packet in enumerate(packets):
  if packet == a:
    first = i + 1
  if packet == b:
    second = i + 1

echo first * second