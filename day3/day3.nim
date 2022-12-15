import std/strutils
import std/sets

proc part1(text: string) =
    var total = 0
    for line in text.splitLines():
        let middle = line.len() div 2

        let first = toHashSet(substr(line, 0, middle - 1))
        let second = toHashSet(substr(line, middle))
    
        var c = intersection(first, second)

        let common = c.pop()
        case common
        of 'a'..'z':
            total += int(common) - int('a') + 1
        of 'A'..'Z':
            total += int(common) - int('A') + 27
        else:
            discard
    
    echo total

proc part2(text: string) =
    var total = 0
    let lines = text.splitLines()
    let num_groups = lines.len() div 3

    for group in 0..(num_groups - 1):
        let first = toHashSet(lines[group * 3])
        let second = toHashSet(lines[group * 3 + 1])
        let third = toHashSet(lines[group * 3 + 2])
        
        var c = intersection(intersection(first, second), third)
        let common = c.pop()
        case common
        of 'a'..'z':
            total += int(common) - int('a') + 1
        of 'A'..'Z':
            total += int(common) - int('A') + 27
        else:
            discard

    echo total

let f = open("day3.txt")
let text = f.readAll()
f.close()

part1(text)
part2(text)