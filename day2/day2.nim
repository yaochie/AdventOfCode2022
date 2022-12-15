import std/strutils

proc part1(text: string): int =
    var score = 0
    for line in text.splitLines():
        let parts = line.splitWhitespace()
        let opp = parts[0]
        let me = parts[1]

        case me
        of "X":
            score += 1
        of "Y":
            score += 2
        of "Z":
            score += 3
        
        case opp
        of "A":
            case me
            of "X":
                score += 3
            of "Y":
                score += 6
        of "B":
            case me
            of "Y":
                score += 3
            of "Z":
                score += 6
        of "C":
            case me
            of "Z":
                score += 3
            of "X":
                score += 6
    return score

proc part2(text: string): int =
    var score = 0
    for line in text.splitLines():
        let parts = line.splitWhitespace()
        let opp = parts[0]
        let res = parts[1]

        case res
        of "Y":
            score += 3
        of "Z":
            score += 6

        case opp
        of "A":
            case res
            of "X":
                score += 3
            of "Y":
                score += 1
            of "Z":
                score += 2
        of "B":
            case res
            of "X":
                score += 1
            of "Y":
                score += 2
            of "Z":
                score += 3
        of "C":
            case res
            of "X":
                score += 2
            of "Y":
                score += 3
            of "Z":
                score += 1
    return score

let f = open("day2.txt")
let text = f.readAll()
f.close()

echo part1(text)
echo part2(text)