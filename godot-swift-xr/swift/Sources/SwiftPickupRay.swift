import SwiftGodot

@Godot(.tool)
class SwiftPickupRay: Node3D, @unchecked Sendable {
  var controller: XRController3D? {
    getParent() as? XRController3D
  }

  var length = Float(10.0)

  var lineNode: MeshInstance3D?
  var lastBasis: Basis?
  var lastPosition: Vector3?

  var active: Bool { lineNode != nil }

  override func _ready() {
    setupSignals()
  }

  override func _process(delta: Double) {
    guard active, checkLineChanged() else { return }
    let (origin, target) = resolveLineEnds()
    drawLine(from: origin, to: target)
  }

  func setupSignals() {
    guard let controller = controller else { return }

    controller.buttonPressed.connect { button in
      if button == "trigger_click" {
        self.addLineNode()
      }
    }
    controller.buttonReleased.connect { button in
      if button == "trigger_click" {
        self.removeLineNode()
      }
    }
  }

  func addLineNode() {
    let node = createLineNode()
    lineNode = node
    addChild(node: node)
  }

  func createLineNode() -> MeshInstance3D {
    let mesh = MeshInstance3D()
    mesh.mesh = ImmediateMesh()
    mesh.castShadow = .off
    return mesh
  }

  func removeLineNode() {
    lineNode?.queueFree()
    lineNode = nil
    lastBasis = nil
    lastPosition = nil
  }

  func checkLineChanged() -> Bool {
    guard let controller = controller else { return false }

    let basis = controller.globalTransform.basis
    let position = controller.globalPosition
    let changed = basis != lastBasis || position != lastPosition

    lastBasis = basis
    lastPosition = position
    return changed
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
    guard let immediateMesh = lineNode?.mesh as? ImmediateMesh else { return }

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
