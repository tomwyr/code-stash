extension Array where Element: Hashable {
  func toSet() -> Set<Element> {
    Set(self)
  }
}

extension Array {
  var single: Element? {
    count == 1 ? self[0] : nil
  }

  func sorted<Key>(key keyOf: (Element) -> Key) -> [Element] where Key: Comparable {
    sorted { e1, e2 in keyOf(e1) <= keyOf(e2) }
  }

  @inlinable public func filterThrowing<E>(_ isIncluded: (Element) throws(E) -> Bool)
    throws(E) -> [Element]
  {
    var result = [Element]()
    for element in self {
      if try isIncluded(element) {
        result.append(element)
      }
    }
    return result
  }

  @inlinable public func forEachThrowing<E>(_ body: (Element) throws(E) -> Void) throws(E) {
    for element in self {
      try body(element)
    }
  }
}

extension Set {
  func toArray() -> [Element] {
    Array(self)
  }
}
