import std/[strutils, sugar, tables]

type
  ItemType = enum Directory, File
  Name = string
  Item = object
    name: Name
    typ: ItemType
    children: seq[string]
    size: int

let inputLines = collect(newSeq):
  for line in lines("day7.txt"): line

var pwd: seq[string] = @[]

## mapping from name to info
var allItems = initTable[string, Item]()

var i = 0
while i < inputLines.len():
  let line = inputLines[i]
  
  if line[0] == '$':
    # command
    if line[2..3] == "cd":
      let newdir = line.splitWhitespace()[^1]
      if newdir == "/":
        # reset
        pwd = @[]
      elif newdir == "..":
        discard pwd.pop()
      else:
        pwd.add(newdir)

    else:
      assert line[2..3] == "ls"
    
    i += 1

  else:
    # ls result
    let pwdName = if pwd.len() == 0: "" else: "/" & pwd.join("/")
    let dirName = if pwd.len() != 0: pwd[^1] else: ""

    var childrenNames: seq[string] = @[]

    while i < inputLines.len() and inputLines[i][0] != '$':
      let line = inputLines[i]
      let parts = line.split(" ")
      let first = parts[0]
      let name = parts[1]
      let fullName = pwdName & "/" & name
      
      childrenNames.add(fullName)
      if first != "dir":
        let fileSize = parseInt(first)
        assert not allItems.hasKey(fullName)
        allItems[fullName] = Item(name: name, typ: File, size: fileSize)

      i += 1

    assert not allItems.hasKey(pwdName)
    allItems[pwdName] = Item(name: dirName, typ: Directory, children: childrenNames)

proc getDirSize(dirName: string, allItems: var Table[string, Item]): int =
  # read cached value if it exists
  if allitems[dirName].size > 0:
    return allitems[dirName].size

  result = 0
  for itemName in allitems[dirName].children:
    let item = allItems[itemName]
    if item.typ == File:
      result += item.size
    else:
      result += getDirSize(itemName, allItems)

  # cache
  allItems[dirName].size = result

proc part1(allItems: var Table[string, Item]) =
  var totalSize = 0
  for itemName, item in allItems.mpairs:
    if item.typ == Directory:
      let dirSize = getDirSize(itemName, allItems)
      if dirSize <= 100000:
        totalSize += dirSize
      
  echo totalSize

proc part2(allItems: var Table[string, Item]) =
  let totalSize = getDirSize("", allItems)
  let unusedSpace = 70000000 - totalSize
  let requiredSpace = 30000000 - unusedSpace

  var minSize = 70000000
  for itemName, item in allItems.mpairs:
    if item.typ == Directory and item.size > requiredSpace:
      minSize = min(minSize, item.size)

  echo minSize

part1(allItems)
part2(allItems)
