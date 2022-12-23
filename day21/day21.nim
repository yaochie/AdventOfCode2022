import std/[deques, math, sequtils, sets, strutils, tables]

type
  Operation = enum Plus, Minus, Multiply, Divide
  MonkeyKind = enum Number, Op
  Monkey = object
    # name: string
    case kind: MonkeyKind
    of Number: value: int
    of Op:
      a: string
      b: string
      op: Operation

var monkeys = initTable[string, Monkey]()

# assume each monkey is only depended on once
var edges = initTable[string, string]()

for line in lines("day21.txt"):
  let parts = line.split(" ")
  let name = parts[0][0..^2]

  if parts.len() == 2:
    # number only
    monkeys[name] = Monkey(kind: Number, value: parseInt(parts[1]))
  else:
    let opStr = parts[2]
    var op: Operation

    case opStr
    of "+":
      op = Operation.Plus
    of "-":
      op = Operation.Minus
    of "*":
      op = Operation.Multiply
    of "/":
      op = Operation.Divide

    let a = parts[1]
    let b = parts[3]
    monkeys[name] = Monkey(kind: Op, a: a, b: b, op: op)

    assert not edges.contains(a)
    assert not edges.contains(b)
    edges[a] = name
    edges[b] = name

echo monkeys.len()

# topological sort using DFS
# https://en.wikipedia.org/wiki/Topological_sorting#Depth-first_search

proc visit(name: string, sorted: var Deque[string], unvisited: var HashSet[string]) =
  if not unvisited.contains(name):
    return

  if edges.contains(name):
    visit(edges[name], sorted, unvisited)
    # for other in edges[name].items:
    #   visit(other, sorted, unvisited)

  unvisited.excl(name)
  sorted.addFirst(name)

proc topoSort(): Deque[string] =
  # just do recursive one for now
  var unvisited = initHashSet[string]()
  for name in monkeys.keys:
    unvisited.incl(name)

  var sorted = initDeque[string]()

  while unvisited.len() > 0:
    let next = unvisited.pop()
    unvisited.incl(next)
    visit(next, sorted, unvisited)

  sorted

let sorted = topoSort()

var values = initTable[string, int]()
for name in sorted:
  let monkey = monkeys[name]
  case monkey.kind
  of Number:
    values[name] = monkey.value
  of Op:
    case monkey.op
    of Plus:
      values[name] = values[monkey.a] + values[monkey.b]
    of Minus:
      values[name] = values[monkey.a] - values[monkey.b]
    of Multiply:
      values[name] = values[monkey.a] * values[monkey.b]
    of Divide:
      assert floorMod(values[monkey.a], values[monkey.b]) == 0
      values[name] = values[monkey.a] div values[monkey.b]

echo "Part 1 answer: ", values["root"]

# Part 2

# echo values

# get the side that doesn't contain humn
var trail = ["humn"].toSeq()
while edges[trail[^1]] != "root":
  trail.add(edges[trail[^1]])

var other: string
if monkeys["root"].a == trail[^1]:
  other = monkeys["root"].b
else:
  other = monkeys["root"].a

var valueToReach = values[other]

# echo trail[^1], " Value to reach: ", valueToReach

# go backwards
while trail.len() > 1:
  let next = trail.pop()
  let nextMonkey = monkeys[next]
  let goLeft = nextMonkey.a == trail[^1]

  case nextMonkey.op
  of Plus:
    if goLeft:
      valueToReach = valueToReach - values[nextMonkey.b]
    else:
      valueToReach = valueToReach - values[nextMonkey.a]

  of Minus:
    if goLeft:
      valueToReach = valueToReach + values[nextMonkey.b]
    else:
      valueToReach = values[nextMonkey.a] - valueToReach
  
  of Multiply:
    if goLeft:
      valueToReach = valueToReach div values[nextMonkey.b]
    else:
      valueToReach = valueToReach div values[nextMonkey.a]

  of Divide:
    if goLeft:
      valueToReach = valueToReach * values[nextMonkey.b]
    else:
      valueToReach = values[nextMonkey.a] div valueToReach

  # echo trail[^1], " Value to reach: ", valueToReach

echo "Part 2 answer: ", valueToReach