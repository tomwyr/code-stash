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
  func getNode<T>(_ path: NodePath) -> T where T: Node {
    getNode(path: path) as! T
  }

  func getNodeOrNull<T>(_ path: NodePath) -> T? where T: Node {
    getNodeOrNull(path: path) as! T?
  }

  func getParent<T>() -> T where T: Node {
    getParent() as! T
  }
}

extension Callable {
  convenience init<T>(_ callback: @escaping (T) -> Void) where T: VariantStorable {
    self.init({ args in
      guard args.count == 1, let variant = args.first as? Variant, let arg = T(variant) else {
        GD.print("Unexpected callable arguments (expected \(T.self))")
        return nil
      }
      callback(arg)
      return nil
    })
  }
}
