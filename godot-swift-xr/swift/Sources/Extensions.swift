import SwiftGodot

extension Vector3 {
  init(x: Float = 0.0, y: Float = 0.0, z: Float = 0.0) {
    self.init()
    self.x = x
    self.y = y
    self.z = z
  }
}

extension Node {
  func getNodeOrNull<T>(_ path: NodePath) -> T? where T: Node {
    getNodeOrNull(path: path) as? T
  }

  func getParent<T>() -> T? where T: Node {
    getParent() as? T
  }
}
