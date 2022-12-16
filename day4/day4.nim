import std/strutils

proc part1(text: string) =
  var numContained = 0
  for line in text.splitLines():
    let parts = line.split(",")
    let left = parts[0]
    let right = parts[1]
    let leftParts = left.split("-")
    let leftMin = parseInt(leftParts[0])
    let leftMax = parseInt(leftParts[1])
    let rightParts = right.split("-")
    let rightMin = parseInt(rightParts[0])
    let rightMax = parseInt(rightParts[1])

    if (rightMin <= leftMin) and (rightMax >= leftMax):
      numContained += 1
    elif (leftMin <= rightMin) and (leftMax >= rightMax):
      numContained += 1

  echo numContained

proc part2(text: string) =
  var numOverlap = 0
  for line in text.splitLines():
    let parts = line.split(",")
    let left = parts[0]
    let right = parts[1]
    let leftParts = left.split("-")
    let leftMin = parseInt(leftParts[0])
    let leftMax = parseInt(leftParts[1])
    let rightParts = right.split("-")
    let rightMin = parseInt(rightParts[0])
    let rightMax = parseInt(rightParts[1])

    if (leftMin >= rightMin) and (leftMin <= rightMax):
      numOverlap += 1
    elif (rightMin >= leftMin) and (rightMin <= leftMax):
      numOverlap += 1
        
  echo numOverlap

let f = open("day4.txt")
let text = f.readAll()
f.close()

part1(text)
part2(text)