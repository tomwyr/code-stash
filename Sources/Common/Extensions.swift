extension Array where Element: Hashable {
  func toSet() -> Set<Element> {
    Set(self)
  }
}

extension Set {
  func toArray() -> [Element] {
    Array(self)
  }
}
