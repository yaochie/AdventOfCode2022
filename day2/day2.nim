import std/strutils

proc part1(text: string): int =
  result = 0
  for line in text.splitLines():
    let parts = line.splitWhitespace()
    let opp = parts[0]
    let me = parts[1]

    case me
    of "X":
      result += 1
    of "Y":
      result += 2
    of "Z":
      result += 3
    
    case opp
    of "A":
      case me
      of "X":
        result += 3
      of "Y":
        result += 6
    of "B":
      case me
      of "Y":
        result += 3
      of "Z":
        result += 6
    of "C":
      case me
      of "Z":
        result += 3
      of "X":
        result += 6

proc part2(text: string): int =
  result = 0
  for line in text.splitLines():
    let parts = line.splitWhitespace()
    let opp = parts[0]
    let res = parts[1]

    case res
    of "Y":
      result += 3
    of "Z":
      result += 6

    case opp
    of "A":
      case res
      of "X":
        result += 3
      of "Y":
        result += 1
      of "Z":
        result += 2
    of "B":
      case res
      of "X":
        result += 1
      of "Y":
        result += 2
      of "Z":
        result += 3
    of "C":
      case res
      of "X":
        result += 2
      of "Y":
        result += 3
      of "Z":
        result += 1

let f = open("day2.txt")
let text = f.readAll()
f.close()

echo part1(text)
echo part2(text)