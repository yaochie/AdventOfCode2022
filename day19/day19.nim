import std/[deques, enumerate, strutils]

type
  Params = tuple[
    oreCost, clayCost, obsOreCost, obsClayCost, geodeOreCost, geodeObsCost: int
  ]
  State = tuple[
    t, numOre, numClay, numObs, numGeode,
    numOreBots, numClayBots, numObsBots, numGeodeBots: int
  ]

proc getMaxGeodes(params: Params, maxT: int, verbose: bool): int =
  # DFS (for lower mem usage)
  var toVisit = initDeque[State]()
  toVisit.addLast((0, 0, 0, 0, 0, 1, 0, 0, 0))

  var best = 0
  var maxDequeLen = 1
  while toVisit.len() > 0:
    var state = toVisit.popLast()

    let canGeode = state.numOre >= params.geodeOreCost and state.numObs >= params.geodeObsCost
    let canObs = state.numOre >= params.obsOreCost and state.numClay >= params.obsClayCost
    let canClay = state.numOre >= params.clayCost
    let canOre = state.numOre >= params.oreCost

    # collect
    state.t += 1
    state.numOre += state.numOreBots
    state.numClay += state.numClayBots
    state.numObs += state.numObsBots
    state.numGeode += state.numGeodeBots

    if state.t == maxT:
      if verbose and state.numGeode > best:
        echo "Final state: ", state
      best = max(best, state.numGeode)
    else:
      # if ore and clay can both be built, assume we won't do nothing
      # (since obs and geode ore costs are also around the same?)
      if not (canOre and canClay):
        toVisit.addLast(state)

      if canGeode:
        var newState = state
        newState.numGeodeBots += 1
        newState.numOre -= params.geodeOreCost
        newState.numObs -= params.geodeObsCost
        toVisit.addLast(newState)

        # assume that if we can build a geode, we will build a geode?
        continue
      
      if canObs:
        var newState = state
        newState.numObsBots += 1
        newState.numOre -= params.obsOreCost
        newState.numClay -= params.obsClayCost
        toVisit.addLast(newState)

      if canClay:
        var newState = state
        newState.numClayBots += 1
        newState.numOre -= params.clayCost
        toVisit.addLast(newState)

        # assume that if we can build an obs or clay, we won't
        # be building ore
        if canObs:
          continue

      if canOre:
        var newState = state
        newState.numOreBots += 1
        newState.numOre -= params.oreCost
        toVisit.addLast(newState)

    maxDequeLen = max(maxDequeLen, toVisit.len())

  echo "Best: ", best
  echo "Max deque length: ", maxDequeLen

  best

# Part 1
var qualityLevel = 0
for i, line in enumerate(1, lines("day19.txt")):
  let parts = line.split(" ")
  let params: Params = (
    oreCost: parseInt(parts[6]),
    clayCost: parseInt(parts[12]),
    obsOreCost: parseInt(parts[18]),
    obsClayCost: parseInt(parts[21]),
    geodeOreCost: parseInt(parts[27]),
    geodeObsCost: parseInt(parts[30]),
  )

  echo params
  let best = getMaxGeodes(params, 24, false)
  qualityLevel += best * i

echo "Part 1 answer: ", qualityLevel
echo "======================"

# Part 2
var prod = 1
for i, line in enumerate(0, lines("day19.txt")):
  if i >= 3:
    break

  let parts = line.split(" ")
  let params: Params = (
    oreCost: parseInt(parts[6]),
    clayCost: parseInt(parts[12]),
    obsOreCost: parseInt(parts[18]),
    obsClayCost: parseInt(parts[21]),
    geodeOreCost: parseInt(parts[27]),
    geodeObsCost: parseInt(parts[30]),
  )

  echo "Params: ", params
  let best = getMaxGeodes(params, 32, false)
  prod *= best

echo "Part 2 answer: ", prod
