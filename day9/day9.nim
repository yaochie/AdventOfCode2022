import strutils
import strformat
import sugar
import sets

let inputLines = collect(newSeq):
  for line in lines("day9.txt"): line

proc part1(steps: seq[string]) =
  ## naive simulation
  var
    hx = 0
    hy = 0
    tx = 0
    ty = 0

  var uniqueTailPos = initHashSet[string]()
  uniqueTailPos.incl(fmt"{tx}|{ty}")

  for step in steps:
    let parts = step.split(" ")
    let dir = parts[0]
    let dist = parseInt(parts[1])

    case dir
    of "L":
      for i in 1 .. dist:
        hx -= 1
        if tx - hx > 1:
          tx -= 1
          if ty != hy:
            ty = hy
          
          uniqueTailPos.incl(fmt"{tx}|{ty}")

    of "R":
      for i in 1 .. dist:
        hx += 1
        if hx - tx > 1:
          tx += 1
          if ty != hy:
            ty = hy
          
          uniqueTailPos.incl(fmt"{tx}|{ty}")

    of "U":
      for i in 1 .. dist:
        hy -= 1
        if ty - hy > 1:
          ty -= 1
          if tx != hx:
            tx = hx

          uniqueTailPos.incl(fmt"{tx}|{ty}")
      
    of "D":
      for i in 1 .. dist:
        hy += 1
        if hy - ty > 1:
          ty += 1
          if tx != hx:
            tx = hx
            
          uniqueTailPos.incl(fmt"{tx}|{ty}")

  echo uniqueTailPos.len()

part1(inputLines)

proc updateRest(xs: var array[10, int], ys: var array[10, int]) =
  ## update rest of rope
  for i in 1 .. 9:
    let xdiff = xs[i] - xs[i-1]
    if abs(xdiff) > 1:
      xs[i] += (if xdiff > 1: -1 else: 1)
      if ys[i] > ys[i-1]:
        ys[i] -= 1
      elif ys[i] < ys[i-1]:
        ys[i] += 1
    
    let ydiff = ys[i] - ys[i-1]
    if abs(ydiff) > 1:
      ys[i] += (if ydiff > 1: -1 else: 1)
      if xs[i] > xs[i-1]:
        xs[i] -= 1
      elif xs[i] < xs[i-1]:
        xs[i] += 1

proc part2(steps: seq[string]) =
  ## naive simulation still seems to run okay?
  var
    xs: array[10, int]
    ys: array[10, int]
  
  var uniqueTailPos = initHashSet[string]()
  uniqueTailPos.incl(fmt"{xs[^1]}|{ys[^1]}")
  
  for step in steps:
    let parts = step.split(" ")
    let dir = parts[0]
    let dist = parseInt(parts[1])

    case dir
    of "L":
      for _ in 1 .. dist:
        xs[0] -= 1
        updateRest(xs, ys)
        uniqueTailPos.incl(fmt"{xs[^1]}|{ys[^1]}")

    of "R":
      for _ in 1 .. dist:
        xs[0] += 1
        updateRest(xs, ys)
        uniqueTailPos.incl(fmt"{xs[^1]}|{ys[^1]}")

    of "U":
      for _ in 1 .. dist:
        ys[0] -= 1
        updateRest(xs, ys)
        uniqueTailPos.incl(fmt"{xs[^1]}|{ys[^1]}")
    
    of "D":
      for _ in 1 .. dist:
        ys[0] += 1
        updateRest(xs, ys)
        uniqueTailPos.incl(fmt"{xs[^1]}|{ys[^1]}")

  echo uniqueTailPos.len()

part2(inputLines)