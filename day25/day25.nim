import std/[algorithm, math, strutils]

proc parseSnafu(num: string): int =
  var multiplier = 1
  var total = 0
  for i in countdown(num.len() - 1, 0):
    let c = num[i]
    var val: int
    if c == '2':
      val = 2
    elif c == '1':
      val = 1
    elif c == '0':
      val = 0
    elif c == '-':
      val = -1
    elif c == '=':
      val = -2
    else:
      assert false

    total += val * multiplier
    multiplier *= 5
  
  total

proc toSnafu(num: int): string =
  var digits = newSeq[char]()
  var multiplier = 1

  var remaining = num
  while remaining > 0:
    let v = floorMod(remaining + 2 * multiplier, multiplier * 5) div multiplier
    echo (remaining, multiplier, v)

    if v == 4:
      digits.add('2')
    elif v == 3:
      digits.add('1')
    elif v == 2:
      digits.add('0')
    elif v == 1:
      digits.add('-')
    elif v == 0:
      digits.add('=')
    else:
      assert false

    remaining -= (v - 2) * multiplier
    multiplier *= 5

  digits.reverse()
  digits.join("")

var total = 0
for line in lines("day25.txt"):
  total += parseSnafu(line)

echo total
echo "Part 1 answer: ", toSnafu(total)