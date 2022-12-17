import std/[algorithm, math, sets, strutils]

type
  Coord = tuple[x, y: int]
  Range = tuple[min, max: int]
  RangePointType = enum Start, End
  RangePoint = tuple[x: int, typ: RangePointType]
  Sensor = tuple[sensorX, sensorY, beaconX, beaconY, radius: int]

func comparePoints(a: RangePoint, b: RangePoint): int =
    let cmp_val = cmp(a.x, b.x)
    if cmp_val != 0:
      return cmp_val
    else:
      if a.typ == b.typ:
        return 0
      elif a.typ == Start:
        return -1
      else:
        return 1

var sensors = initHashSet[Sensor]()
for line in lines("day15.txt"):
  let parts = line.split(" ")
  let sensorX = parseInt(parts[2][2..^2])
  let sensorY = parseInt(parts[3][2..^2])
  let beaconX = parseInt(parts[8][2..^2])
  let beaconY = parseInt(parts[9][2..^1])

  let radius = abs(beaconX - sensorX) + abs(beaconY - sensorY)

  sensors.incl((sensorX, sensorY, beaconX, beaconY, radius))

proc part1(sensors: HashSet[Sensor]) =
  var beacons = initHashSet[Coord]()
  var ranges = initHashSet[Range]()

  const rowY = 2000000

  for sensorX, sensorY, beaconX, beaconY, radius in sensors.items:
    beacons.incl((beaconX, beaconY))
    let width = 2 * (radius - abs(rowY - sensorY)) + 1
    # echo width
    if width <= 0:
      continue

    let rangeMin = sensorX - floorDiv(width, 2)
    let rangeMax = sensorX + floorDiv(width, 2)

    ranges.incl((rangeMin, rangeMax))

  # sum up ranges.
  var points = newSeq[RangePoint]()
  for rangeMin, rangeMax in ranges.items:
    points.add((rangeMin, Start))
    points.add((rangeMax, End))

  sort(points, comparePoints)

  var total = 0
  var level = 0
  var rangeStart = 0
  var rangeEnd = 0
  for (x, pointType) in points:
    case pointType
    of Start:
      if level == 0:
        rangeStart = x
        if rangeEnd == rangeStart:
          rangeStart += 1
      level += 1
    of End:
      level -= 1
      if level != 0:
        continue

      rangeEnd = x
      total += rangeEnd - rangeStart + 1
      for beaconX, beaconY in beacons.items:
        if beaconY == rowY and beaconX in rangeStart..rangeEnd:
          total -= 1

  echo "Part 1 answer: ", total

part1(sensors)

# part 2 - do the same way as part 1, just repeat for every possible row
for rowY in 0..4000000:
  var ranges = initHashSet[Range]()
  for sensorX, sensorY, beaconX, beaconY, radius in sensors.items:
    let width = 2 * (radius - abs(rowY - sensorY)) + 1
    if width <= 0:
      continue

    let rangeMin = max(0, sensorX - floorDiv(width, 2))
    let rangeMax = min(4000000, sensorX + floorDiv(width, 2))
    ranges.incl((rangeMin, rangeMax))

  var points = newSeq[RangePoint]()
  for rangeMin, rangeMax in ranges.items:
    points.add((rangeMin, Start))
    points.add((rangeMax, End))

  sort(points, comparePoints)

  # get total number of locations in the row that cannot have
  # the missing beacon.
  # NOTE: this includes places with known beacons
  var level = 0
  var rangeStart = -1
  var rangeEnd = -1
  var done = false
  for (x, pointType) in points:
    case pointType
    of Start:
      if level == 0:
        if x > rangeEnd + 1:
          # there was a gap between ranges, so we have found the
          # missing beacon
          let missingX = x - 1
          let missingY = rowY
          echo "X: ", missingX
          echo "Y: ", missingY
          echo "Part 2 answer: ", missingX * 4000000 + missingY
          done = true
          break
        rangeStart = x

      level += 1
    of End:
      level -= 1
      if level != 0:
        continue
      rangeEnd = x
  
  if done:
    break

  if floorMod(rowY, 100000) == 0:
    echo "row: ", rowY
