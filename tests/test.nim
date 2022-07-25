import pkg/balls
import enumtables

type SomeEnum = enum
  A, B, C, D

suite "main":
  block thing:
    var table: EnumTable[SomeEnum, int]

    assert not table.hasKey(A)
    assert not table.hasKey(B)

    table[A] = 123
    assert table.hasKey(A)
    check table[A] == 123

  block toEnumTable:
    let table = {A: 12, B: 32}.toEnumTable()
    assert table.len == 2
    assert table[A] == 12
    assert table[B] == 32
    assert C notin table
    assert D notin table

    expect KeyError:
      discard table[C]
    expect KeyError:
      discard table[D]

  block assignment:
    var table: EnumTable[SomeEnum, int]
    assert A notin table

    table[A] = 123

    assert table[A] == 123
    assert table.len == 1
    assert A in table

  block equality:
    let table1 = {A: 12, B: 32}.toEnumTable()
    var table2: EnumTable[SomeEnum, int]

    table2[A] = 12
    table2[B] = 32
    table2[C] = 12
    table2.del(C)

    assert table1 == table2

  block reset:
    var table = {A: 12, B: 32}.toEnumTable()
    assert table.len == 2

    table.reset()

    assert table.len == 0
    assert A notin table
    assert B notin table
    expect KeyError:
      discard table[A]
    expect KeyError:
      discard table[B]
