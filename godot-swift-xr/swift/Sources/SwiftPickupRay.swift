import SwiftGodot

@Godot(.tool)
class SwiftPickupRay: Node3D, @unchecked Sendable {
  var controller: XRController3D? {
    getParent() as? XRController3D
  }

  var rayMaxLength = 5.0
  var rayWidth = 0.005

  var active = false
  var collides = false
  var lineNode: MeshInstance3D?
  var tipNode: Node3D?

  var lastBasis: Basis?
  var lastPosition: Vector3?
  var lastLength: Double?

  var color = Color.tomato

  @Export
  var expansion: Double = 1.0
  var expansionTween: Tween?

  override func _ready() {
    setupSignals()
  }

  override func _process(delta: Double) {
    guard active, checkLineChanged() else { return }

    let (origin, target, collided) = resolveLineData()
    updateTipNode(collided)
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

  func updateTipNode(_ collided: Bool) {
    switch (collided, tipNode) {
    case (true, .none):
      let node = createTipNode()
      tipNode = node
      addChild(node: node)
    case (false, .some(var node)):
      node.queueFree()
      tipNode = nil
    default: break
    }
  }

  func addTipNode() {
    let node = createTipNode()
    tipNode = node
    addChild(node: node)
  }

  func createTipNode() -> Node3D {
    let light = OmniLight3D()
    light.lightColor = color
    light.lightEnergy = 0.1
    light.omniRange = 0.1
    light.position = Vector3(z: 0.01)

    let material = StandardMaterial3D()
    material.albedoColor = color
    material.emissionEnabled = true
    material.emission = color

    let mesh = SphereMesh()
    mesh.radius = 0.01
    mesh.height = 0.02
    mesh.material = material

    let tip = MeshInstance3D()
    tip.mesh = mesh

    tip.addChild(node: light)

    return tip
  }

  func activateRay() {
    active = true

    let node = createLineNode()
    lineNode = node
    addChild(node: node)

    animateExpansion(from: 0)
  }

  func deactivateRay() {
    active = false
    collides = false

    lineNode?.queueFree()
    lineNode = nil
    tipNode?.queueFree()
    tipNode = nil

    lastBasis = nil
    lastPosition = nil
    lastLength = nil
  }

  func createLineNode() -> MeshInstance3D {
    let material = StandardMaterial3D()
    material.albedoColor = color

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

  func resolveLineData() -> RayLineData {
    let origin = Vector3.zero
    let maxTarget = Vector3(z: -Float(rayMaxLength))
    let hitTarget = detectCollision(
      from: toGlobal(localPoint: origin),
      to: toGlobal(localPoint: maxTarget)
    )
    let target = hitTarget.flatMap(toLocal) ?? maxTarget
    return (origin: origin, target: target, collided: hitTarget != nil)
  }

  func detectCollision(from origin: Vector3, to target: Vector3) -> Vector3? {
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

    let currentTarget = origin + (target - origin) * expansion

    mesh.height = (currentTarget - origin).length()
    node.position = origin + Vector3(z: -Float(mesh.height) / 2)
    node.rotation = Vector3(x: .pi / 2)

    if let tipNode {
      tipNode.position = origin + Vector3(z: -Float(mesh.height))
    }
  }
}

typealias RayLineData = (
  origin: Vector3,
  target: Vector3,
  collided: Bool
)
