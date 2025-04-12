import SwiftGodot

@Godot
class SwiftCubeColor: Node3D, @unchecked Sendable, RayPainterDelegate {
  private var pickableCube: RigidBody3D { getNode("../..") }
  private var nodePainter: SwiftRayPainter {
    getNode("/root/Main/XROrigin/LeftHandController/RayPainter")
  }

  @Export
  var cubeColor: Color?

  override func _ready() {
    nodePainter.register(delegate: self)
    guard let color = cubeColor else {
      GD.print("SwiftCubeColor not set")
      return
    }
    changeCubeColor(color)
  }

  func paint(_ target: Object, to color: Color) -> Bool {
    guard target == pickableCube else {
      return false
    }
    cubeColor = color
    changeCubeColor(color)
    return true
  }

  private func changeCubeColor(_ color: Color) {
    guard let parent = getParent() as? MeshInstance3D,
      let mesh = parent.mesh as? BoxMesh
    else {
      GD.print("SwiftCubeColor parent is not a box mesh instance")
      return
    }

    var material = StandardMaterial3D()
    material.albedoColor = color
    mesh.material = material
  }
}
