import std/[deques, enumerate]

let f = open("day6.txt")
let text = f.readAll()
f.close()

proc findUniques(text: string, uniqueCount: int) =
  var recent: Deque[char] = initDeque[char]()
  for i, c in enumerate(1, text):
    recent.addLast(c)

    if recent.len() == uniqueCount:
      var a: set[char]
      for b in recent:
        incl(a, b)

      if a.len() == uniqueCount:
        echo i
        return

      recent.popFirst()

findUniques(text, 4)
findUniques(text, 14)