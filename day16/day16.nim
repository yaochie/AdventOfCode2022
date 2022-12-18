import std/[deques, tables, sequtils, sets, strformat, strutils, sugar]

type
  ValveInfo = tuple[rate: int, connected: seq[string]]
  VisitValve = tuple[t: int, name: string]

var valves = initTable[string, ValveInfo]()

for line in lines("day16.txt"):
  let parts = line.split(" ", maxsplit=9)
  let valveName = parts[1]
  let rate = parseInt(parts[4][5..^2])
  let connectedValves = parts[^1].split(", ")

  valves[valveName] = (rate, connectedValves)

# can figure out how much pressure is released by calc
# - how far + how much time left + flow rate

# do floyd-warshall to get distances between all valves
var dist = initTable[string, int]()

# initialize floyd-warshall
for valveName, (rate, connectedValves) in valves.pairs:
  dist[fmt"{valveName}|{valveName}"] = 0
  for valveName2 in valves.keys:
    if valveName == valveName2:
      continue

    if valveName2 in connectedValves:
      dist[fmt"{valveName}|{valveName2}"] = 1

# do floyd-warshall
for k in valves.keys:
  for src in valves.keys:
    for dst in valves.keys:
      let k1 = fmt"{src}|{k}"
      let k2 = fmt"{k}|{dst}"
      let k3 = fmt"{src}|{dst}"

      if not (dist.contains(k1) and dist.contains(k2)):
        continue

      let p = dist[k1] + dist[k2]
      if dist.contains(k3):
        if dist[k3] > p:
          dist[k3] = p
      else:
        dist[k3] = p

# time allowed for part 1
const totalTime = 30

# brute force search, but hopefully the time limit limits overall runtime

# reduce runtime by only considering valves with positive flow
let valveSet = collect(initHashSet):
  for valveName, (rate, _) in valves.pairs:
    if rate > 0: {valveName}

echo valveSet

# DFS
proc stepNext(valveSet: HashSet[string], visited: var HashSet[string],
              path: var Deque[string], t: int, released: int): int =
  let currValve = path.peekLast()
  var maxReleased = released

  for nextValve in valveSet.difference(visited):
    let newT = t + dist[fmt"{currValve}|{nextValve}"] + 1
    if newT >= totalTime:
      continue

    visited.incl(nextValve)
    path.addLast(nextValve)
    let contribution = (totalTime - newT) * valves[nextValve].rate

    maxReleased = max(
      maxReleased,
      stepNext(valveSet, visited, path, newT, released + contribution)
    )

    visited.excl(nextValve)
    path.popLast()
  
  return maxReleased
  
var visited = ["AA"].toHashSet
var path = ["AA"].toDeque

echo "Part 1 answer: ", stepNext(valveSet, visited, path, 0, 0)

# part 2 -
# keep track of the two valves that both people are heading to.
# once the nearer one is reached, give it a new destination
# kind of similar to the part 1 solution
# this approach is quite slow.. but still reasonable

# time allowed for part 2
const totalTime2 = 26

proc stepNext2(unvisited: HashSet[string], toVisit: var HashSet[VisitValve]): int =
  let curr = min(toVisit.toSeq())
  toVisit.excl(curr)
  let (t, currValve) = curr
  let contribution = (totalTime2 - t) * valves[currValve].rate
  # echo currValve, ' ', t, ' ', contribution
  var best = 0

  if toVisit.len() > 0:
    best = max(best, stepNext2(unvisited, toVisit))

  if unvisited.len() > 0:
    for nextValve in unvisited:
      let nextT = t + dist[fmt"{currValve}|{nextValve}"] + 1
      if nextT >= totalTime2:
        continue

      toVisit.incl((nextT, nextValve))

      # make copy
      let nextUnvisited = unvisited - [nextValve].toHashSet()
      # echo nextUnvisited, ' ', toVisit

      let res = stepNext2(nextUnvisited, toVisit)
      # echo currValve, ' ', nextValve, ' ', res
      best = max(best, res)
      toVisit.excl((nextT, nextValve))

  toVisit.incl(curr)
  contribution + best

var best = 0
let valveSeq = valveSet.toSeq()
for i in 0..<valveSeq.len():
  for j in i+1..<valveSeq.len():
    let a = valveSeq[i]
    let b = valveSeq[j]

    var toVisit = [(dist[fmt"AA|{a}"] + 1, a), (dist[fmt"AA|{b}"] + 1, b)].toHashSet()
    var unvisited = valveSet.difference([a, b].toHashSet())

    let result = stepNext2(unvisited, toVisit)
    echo a, ' ', b, ' ', result
    best = max(best, result)

echo "Part 2 answer: ", best