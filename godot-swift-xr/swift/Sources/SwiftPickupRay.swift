import SwiftGodot

@Godot(.tool)
class SwiftPickupRay: Node3D, @unchecked Sendable {
  var controller: XRController3D? {
    getParent() as? XRController3D
  }

  var length = Float(10.0)
  var lineMesh: MeshInstance3D?

  var lastBasis: Basis?
  var lastPosition: Vector3?

  override func _ready() {
    let mesh = createLineMesh()
    lineMesh = mesh
    addChild(node: mesh)
  }

  override func _process(delta: Double) {
    guard let basis = controller?.globalTransform.basis,
      let position = controller?.globalPosition,
      basis != lastBasis || position != lastPosition
    else { return }

    lastBasis = basis
    lastPosition = position

    let (origin, target) = resolveLineEnds()
    drawLine(from: origin, to: target)
  }

  func createLineMesh() -> MeshInstance3D {
    let mesh = MeshInstance3D()
    mesh.mesh = ImmediateMesh()
    mesh.castShadow = .off
    return mesh
  }

  func resolveLineEnds() -> (Vector3, Vector3) {
    let origin = Vector3(x: 0, y: 0, z: -0.05)
    let maxTarget = Vector3(x: 0, y: 0, z: -length)
    let hitTarget = castLine(
      from: toGlobal(localPoint: origin),
      to: toGlobal(localPoint: maxTarget)
    )
    let target = hitTarget.flatMap(toLocal) ?? maxTarget
    return (origin, target)
  }

  func castLine(from origin: Vector3, to target: Vector3) -> Vector3? {
    guard let space = getWorld3d()?.directSpaceState,
      let query = PhysicsRayQueryParameters3D.create(from: origin, to: target)
    else { return nil }

    query.collideWithAreas = true
    query.collideWithBodies = true

    let hit = space.intersectRay(parameters: query)
    return hit?.position
  }

  func drawLine(from origin: Vector3, to target: Vector3) {
    guard let immediateMesh = lineMesh?.mesh as? ImmediateMesh else { return }

    let material = ORMMaterial3D()
    material.shadingMode = .unshaded
    material.albedoColor = .orange

    immediateMesh.clearSurfaces()
    immediateMesh.surfaceBegin(primitive: .lines, material: material)
    immediateMesh.surfaceAddVertex(origin)
    immediateMesh.surfaceAddVertex(target)
    immediateMesh.surfaceEnd()
  }
}
