import SwiftGodot

@Godot
class SwiftCubeColor: Node3D, @unchecked Sendable, NodePaintable {
  @Export
  var cubeColor: Color?

  override func _ready() {
    guard let color = cubeColor else {
      GD.print("SwiftCubeColor not set")
      return
    }
    changeCubeColor(color)
  }

  func paint(to color: Color) {
    cubeColor = color
    changeCubeColor(color)
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
