import SwiftGodot

@Godot(.tool)
class SwiftPickupRay: Node3D, @unchecked Sendable {
  var controller: XRController3D? {
    getParent() as? XRController3D
  }

  var rayMaxLength = 5.0
  var rayWidth = 0.005

  var active = false
  var lineNode: MeshInstance3D?

  var lastBasis: Basis?
  var lastPosition: Vector3?
  var lastLength: Double?

  @Export
  var expansion: Double = 1.0
  var expansionTween: Tween?

  override func _ready() {
    setupSignals()
  }

  override func _process(delta: Double) {
    guard active, checkLineChanged() else { return }

    let (origin, target) = resolveLineEnds()
    animateLengthIncrease(from: origin, to: target)
    drawLine(from: origin, to: target)
  }

  func setupSignals() {
    guard let controller = controller else { return }

    controller.buttonPressed.connect { button in
      if button == "trigger_click" {
        self.activateRay()
      }
    }
    controller.buttonReleased.connect { button in
      if button == "trigger_click" {
        self.deactivateRay()
      }
    }
  }

  func activateRay() {
    active = true

    let node = createLineNode()
    lineNode = node
    addChild(node: node)

    animateExpansion(from: 0)
  }

  func deactivateRay() {
    self.active = false

    lineNode?.queueFree()
    lineNode = nil
    lastBasis = nil
    lastPosition = nil
    lastLength = nil
  }

  func createLineNode() -> MeshInstance3D {
    let material = StandardMaterial3D()
    material.albedoColor = .firebrick

    let mesh = CylinderMesh()
    mesh.material = material
    mesh.topRadius = rayWidth
    mesh.bottomRadius = rayWidth
    mesh.height = 0.0

    let node = MeshInstance3D()
    node.mesh = mesh
    node.castShadow = .off

    return node
  }

  func animateLengthIncrease(from origin: Vector3, to target: Vector3) {
    let length = (target - origin).length()
    let lengthDelta = length - (lastLength ?? 0)
    let tweenActive = expansionTween?.isRunning() ?? false
    if !tweenActive && lengthDelta > 0.1 {
      let startExpansion = 1 - lengthDelta / length
      animateExpansion(from: startExpansion)
    }
    lastLength = length
  }

  func animateExpansion(from startValue: Double) {
    expansion = startValue
    expansionTween?.kill()
    expansionTween = createTween()
    expansionTween?
      .tweenProperty(object: self, property: "expansion", finalVal: Variant(1), duration: 0.1)?
      .from(value: Variant(startValue))?
      .setEase(.in)?.setTrans(.circ)
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
    let origin = Vector3.zero
    let maxTarget = Vector3(z: -Float(rayMaxLength))
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
    guard let node = lineNode, let mesh = node.mesh as? CylinderMesh
    else { return }

    mesh.height = (target - origin).length()
    node.position = origin + Vector3(z: -Float(mesh.height) / 2)
    node.rotation = Vector3(x: .pi / 2)
  }
}
