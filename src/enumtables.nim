type
  EnumTable*[K: enum, V] = object
    data: array[K, V]
    keysWithValues: set[K]

proc raiseKeyError[T](key: T) {.noinline, noreturn.} =
  when compiles($key):
    raise newException(KeyError, "key not found: " & $key)
  else:
    raise newException(KeyError, "key not found")

proc initEnumTable*[K: enum, V](): EnumTable[K, V] =
  discard

proc toEnumTable*[K, V](pairs: openArray[(K, V)]): EnumTable[K, V] =
  for (key, val) in pairs:
    result[key] = val

proc `[]`*[K, V](table: EnumTable[K, V], key: K): V =
  if key notin table.keysWithValues:
    raiseKeyError(key)

  table.data[key]

proc `[]`*[K, V](table: var EnumTable[K, V], key: K): var V =
  if key notin table.keysWithValues:
    raiseKeyError(key)

  table.data[key]

proc `[]=`*[K, V](table: var EnumTable[K, V], key: K, val: sink V) =
  table.keysWithValues.incl(key)
  table.data[key] = val

proc add*[K, V](table: var EnumTable[K, V]; key: K; val: sink V) =
  {.error "`add` is not supported for EnumTable, `[]=` should be used.".}

proc del*[K, V](table: var EnumTable[K, V], key: K) =
  table.keysWithValues.excl(key)
  table.data[key].reset()

proc clear*[K, V](table: var EnumTable[K, V]) =
  table.keysWithValues = {}
  table.data.reset()

proc hasKey*[K, V](table: EnumTable[K, V], key: K): bool =
  key in table.keysWithValues

proc contains*[K, V](table: EnumTable[K, V], key: K): bool =
  hasKey(table, key)

proc hasKeyOrPut*[K, V](table: var EnumTable[K, V], key: K, val: V): bool =
  if key in table:
    true
  else:
    table[key] = val
    false

proc getOrDefault*[K, V](table: EnumTable[K, V], key: K): V =
  if key in table.keysWithValues:
    result = table.data[key]

proc getOrDefault*[K, V](table: EnumTable[K, V], key: K, default: V): V =
  if key in table.keysWithValues:
    table.data[key]
  else:
    default

proc len*[K, V](table: EnumTable[K, V]): int =
  table.keysWithValues.len

proc mgetOrPut*[K, V](table: var EnumTable[K, V], key: K, val: V): var V =
  if key notin table:
    table[key] = val
  table[key]

proc pop*[K, V](table: var EnumTable[K, V], key: K, val: var V): bool =
  if key in table:
    val = table[key]
    table.del(key)
    true
  else:
    false

proc take*[K, V](table: var EnumTable[K, V], key: K, val: var V): bool =
  pop(table, key, val)

iterator keys*[K, V](table: EnumTable[K, V]): lent K =
  for key in table.keysWithValue:
    yield key

iterator values*[K, V](table: EnumTable[K, V]): lent V =
  for key in table.keysWithValues:
    yield table.data[key]

iterator mvalues*[K, V](table: var EnumTable[K, V]): var V =
  for key in table.keysWithValues:
    yield table.data[key]

iterator pairs*[K, V](table: EnumTable[K, V]): (K, V) =
  for key in table.keysWithValues:
    yield (key, table.data[key])

iterator mpairs*[K, V](table: var EnumTable[K, V]): (K, var V) =
  for key in table.keysWithValues:
    yield (key, table.data[key])
