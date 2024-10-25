extension Array where Element: Hashable {
  func toSet() -> Set<Element> {
    Set(self)
  }
}

extension Array {
  var single: Element? {
    count == 1 ? self[0] : nil
  }
}

extension Set {
  func toArray() -> [Element] {
    Array(self)
  }
}
