import SwiftGodot

@Godot
class SwiftPickupRay: Node3D, @unchecked Sendable {
  private var controller: XRController3D { getParent() }
  private var rayLine: MeshInstance3D? { getNodeOrNull("Line") }
  private var rayTip: MeshInstance3D? { getNodeOrNull("Tip") }
  private var colorPicker: SwiftColorPicker { getNode("../ColorPicker") }

  private let maxLength = 5.0
  private let width = 0.005

  @Export
  var color: Color = Color.transparent

  var currentCollision: Object?

  @Export
  var expansion: Double = 0.0
  private var expansionTween: Tween?

  private var active = false
  private var lastExpandedLength = 0.0

  override func _ready() {
    setupColor()
    setupButtons()
  }

  override func _process(delta: Double) {
    guard active else { return }

    let data = resolveRayData()
    updateExpansion(data)
    updateTipNode(data)
    updateLineNode(data)

    currentCollision = data.collider
    lastExpandedLength = data.expandedLength
  }

  private func setupColor() {
    color = colorPicker.activeColor
    colorPicker.colorChanged.connect { color in
      self.color = color
      self.updateNodesColor()
    }
  }

  private func updateNodesColor() {
    if let mesh = rayLine?.mesh as? CylinderMesh,
      let material = mesh.material as? StandardMaterial3D
    {
      material.albedoColor = color
    }
    if let mesh = rayTip?.mesh as? SphereMesh,
      let material = mesh.material as? StandardMaterial3D
    {
      material.albedoColor = color
      material.emission = color
    }
    if let light = rayTip?.getChild(idx: 0) as? OmniLight3D {
      light.lightColor = color
    }
  }

  private func setupButtons() {
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

  private func activateRay() {
    active = true
    let node = PickupRayLine.create(name: "Line", color: color, width: width)
    addChild(node: node)
    animateExpansion()
  }

  private func deactivateRay() {
    active = false

    rayLine?.queueFree()
    rayTip?.queueFree()

    expansionTween?.kill()
    expansionTween = nil
    expansion = 0
    lastExpandedLength = 0
  }

  private func resolveRayData() -> PickupRayData {
    let origin = Vector3.zero
    let maxTarget = Vector3(z: -Float(maxLength))
    let hitResult = detectCollision(
      origin: toGlobal(localPoint: origin),
      target: toGlobal(localPoint: maxTarget)
    )
    let hitTarget = (hitResult?.target).flatMap(toLocal)
    let target = hitTarget ?? maxTarget
    let expandedLength = (target - origin).length()

    return .init(
      origin: origin,
      target: target,
      expandedLength: expandedLength,
      collider: hitResult?.collider
    )
  }

  private func detectCollision(origin: Vector3, target: Vector3) -> RayCollisionResult? {
    guard let space = getWorld3d()?.directSpaceState,
      let query = PhysicsRayQueryParameters3D.create(from: origin, to: target)
    else { return nil }

    query.collideWithAreas = true
    query.collideWithBodies = true

    guard let hit = space.intersectRay(parameters: query) else {
      return nil
    }
    return (hit.collider, hit.position)
  }

  private func updateExpansion(_ data: PickupRayData) {
    let expandedLength = data.expandedLength
    let lengthDelta = expandedLength - (lastExpandedLength ?? 0)
    let animating = expansionTween?.isRunning() ?? false

    if animating {
      if lengthDelta > 0.05 && lastExpandedLength > 0 {
        // Set initial expansion to start the animation at previous length.
        expansion = expansion * (lastExpandedLength / expandedLength)
        // Animate length change above the threshold to the new target length.
        animateExpansion()
      } else if expandedLength < lastExpandedLength * expansion {
        // Stop the animation and make the line fully expanded if the length decreased.
        expansionTween?.kill()
        expansionTween = nil
        expansion = 1
      }
    } else {
      if lengthDelta > 0.05 {
        if lastExpandedLength > 0 {
          // Set initial expansion to start the animation at previous length.
          expansion = expansion * (lastExpandedLength / expandedLength)
        }
        // Animate length change above the threshold.
        animateExpansion()
      } else {
        // Keep the line fully expanded for movement below the threshold.
        expansion = 1
      }
    }
  }

  private func updateLineNode(_ data: PickupRayData) {
    guard let rayLine, let lineMesh = rayLine.mesh as? CylinderMesh else { return }

    let length = data.expandedLength * expansion
    lineMesh.height = length
    rayLine.position = data.origin + Vector3(z: -Float(length) / 2)
    rayLine.rotation = Vector3(x: .pi / 2)
  }

  private func updateTipNode(_ data: PickupRayData) {
    let collides = data.collider != nil

    if collides, rayTip == nil {
      let node = PickupRayTip.create(name: "Tip", color: color)
      addChild(node: node)
    } else if !collides, let rayTip {
      rayTip.queueFree()
    }

    if collides, let rayTip {
      let length = data.expandedLength * expansion
      rayTip.position = data.origin + Vector3(z: -Float(length))
    }
  }

  private func animateExpansion() {
    expansionTween?.kill()
    expansionTween = createTween()
    expansionTween?
      .tweenProperty(object: self, property: "expansion", finalVal: Variant(1), duration: 0.1)?
      .from(value: Variant(expansion))?
      .setEase(.in)?.setTrans(.circ)
  }
}

private typealias RayCollisionResult = (collider: Object, target: Vector3)

private struct PickupRayData {
  let origin: Vector3
  let target: Vector3
  let expandedLength: Double
  let collider: Object?
}

struct PickupRayLine {
  static func create(name: StringName, color: Color, width: Double) -> MeshInstance3D {
    let material = StandardMaterial3D()
    material.albedoColor = color

    let cylinder = CylinderMesh()
    cylinder.material = material
    cylinder.topRadius = width
    cylinder.bottomRadius = width
    cylinder.height = 0

    let node = MeshInstance3D()
    node.name = name
    node.mesh = cylinder
    node.castShadow = .off
    return node
  }
}

struct PickupRayTip {
  static func create(name: StringName, color: Color) -> MeshInstance3D {
    let material = StandardMaterial3D()
    material.albedoColor = color
    material.emissionEnabled = true
    material.emission = color

    let sphere = SphereMesh()
    sphere.radius = 0.01
    sphere.height = 0.02
    sphere.material = material

    let light = OmniLight3D()
    light.lightColor = color
    light.lightEnergy = 0.1
    light.omniRange = 0.2
    light.position = Vector3(z: 0.01)

    let node = MeshInstance3D()
    node.name = name
    node.mesh = sphere
    node.addChild(node: light)
    return node
  }
}
