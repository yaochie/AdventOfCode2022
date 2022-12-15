import std/strutils
import std/algorithm

let f = open("day1.txt")

var calories: seq[int] = @[]
var currCalories = 0
for line in f.lines:
    if line == "":
        calories.add(currCalories)
        currCalories = 0
    else:
        currCalories = currCalories + parseInt(line)

calories.sort(order=SortOrder.Descending)
echo calories[0]
echo calories[0] + calories[1] + calories[2]

f.close()