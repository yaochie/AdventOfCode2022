import std/strutils
import std/deques

let maxCols = 9

proc parseCrates(crateText: string): seq[Deque[char]] =
    var crates = newSeq[Deque[char]](maxCols)

    for line in crateText.splitLines():
        if line[1] == '1':
            break
        for i in 0..(maxCols - 1):
            let c = line[i*4 + 1]
            if c != ' ':
                crates[i].addFirst(c)
    
    return crates

proc getResult(crates: seq[Deque[char]]) =
    var top: seq[char]
    for stack in crates:
        top.add(stack.peekLast())
    echo top.join("")

proc part1(crateText: string, moveText: string) =
    var crates = parseCrates(crateText)

    for line in moveText.splitLines():
        let parts = line.splitWhitespace()
        let num = parseInt(parts[1])
        let startPos = parseInt(parts[3]) - 1
        let endPos = parseInt(parts[5]) - 1

        for i in 1..num:
            crates[endPos].addLast(crates[startPos].popLast())

    getResult(crates)

proc part2(crateText: string, moveText: string) =
    var crates = parseCrates(crateText)

    for line in moveText.splitLines():
        let parts = line.splitWhitespace()
        let num = parseInt(parts[1])
        let startPos = parseInt(parts[3]) - 1
        let endPos = parseInt(parts[5]) - 1

        # inefficient way...
        for i in countdown(num, 1):
            crates[endPos].addLast(crates[startPos][^i])

        for i in 1..num:
            crates[startPos].popLast()

    getResult(crates)

let f = open("day5.txt")
let text = f.readAll()
f.close()

let parts = text.split("\n\n")
let crateText = parts[0]
let moveText = parts[1]

part1(crateText, moveText)
part2(crateText, moveText)