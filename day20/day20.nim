import std/[algorithm, enumerate, math, strutils, tables]

# numbers can occur more than once.

var nums = initTable[int, int]()
var orig = newSeq[int]()
var zeroKey: int

for i, line in enumerate(lines("day20.txt")):
  let num = parseInt(line)
  if num == 0:
    zeroKey = i
  nums[i] = num
  orig.add(i)

proc mix(orig: seq[int], arr: var seq[int], nums: Table[int, int]) =
  # using in-place rotate
  let length = orig.len()
  for i in orig:
    let startIdx = arr.find(i)
    let num = nums[i]
    let endIdx = floorMod(startIdx + num, length - 1)

    if startIdx < endIdx:
      arr.rotateLeft(startIdx..endIdx, 1)
    else:
      # rotate right by 1
      arr.rotateLeft(endIdx..startIdx, -1)

proc getAnswer(arr: seq[int], nums: Table[int, int], zeroKey: int): int =
  let length = arr.len()
  let zeroIdx = arr.find(zeroKey)
  let
    i = floorMod(zeroIdx + 1000, length)
    j = floorMod(zeroIdx + 2000, length)
    k = floorMod(zeroIdx + 3000, length)

  echo i, ' ', j, ' ', k
  echo arr[i], ' ', arr[j], ' ', arr[k]
  echo nums[arr[i]], ' ', nums[arr[j]], ' ', nums[arr[k]]

  nums[arr[i]] + nums[arr[j]] + nums[arr[k]]

# Part 1
var arr = orig
mix(orig, arr, nums)

echo "Part 1 answer: ", getAnswer(arr, nums, zeroKey)

# Part 2
const multiplier = 811589153

for v in nums.mvalues:
  v *= multiplier

arr = orig
for _ in 1..10:
  mix(orig, arr, nums)

echo "Part 2 answer: ", getAnswer(arr, nums, zeroKey)