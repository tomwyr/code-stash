import SwiftGodot

@Godot(.tool)
class SwiftPickupRay: Node3D, @unchecked Sendable {
  var controller: XRController3D? { getParent() }
  var rayLine: MeshInstance3D? { getNodeOrNull("Line") }
  var rayTip: Node3D? { getNodeOrNull("Tip") }

  let maxLength = 5.0
  let width = 0.005
  let color = Color.tomato

  @Export
  var expansion: Double = 0.0
  var expansionTween: Tween?

  var active = false
  var lastExpandedLength = 0.0

  override func _ready() {
    setupSignals()
  }

  override func _process(delta: Double) {
    guard active else { return }

    let data = resolveRayData()
    updateExpansion(data)
    updateTipNode(data)
    updateLineNode(data)

    lastExpandedLength = data.expandedLength
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
    let node = PickupRayLine.create(name: "Line", color: color, width: width)
    addChild(node: node)
    animateExpansion()
  }

  func deactivateRay() {
    active = false

    rayLine?.queueFree()
    rayTip?.queueFree()

    expansionTween?.kill()
    expansionTween = nil
    expansion = 0
    lastExpandedLength = 0
  }

  func resolveRayData() -> PickupRayData {
    let origin = Vector3.zero
    let maxTarget = Vector3(z: -Float(maxLength))
    let hitTarget = detectCollision(
      origin: toGlobal(localPoint: origin),
      target: toGlobal(localPoint: maxTarget)
    ).flatMap(toLocal)
    let target = hitTarget ?? maxTarget
    let expandedLength = (target - origin).length()

    return .init(
      origin: origin,
      target: target,
      expandedLength: expandedLength,
      collides: hitTarget != nil
    )
  }

  func detectCollision(origin: Vector3, target: Vector3) -> Vector3? {
    guard let space = getWorld3d()?.directSpaceState,
      let query = PhysicsRayQueryParameters3D.create(from: origin, to: target)
    else { return nil }

    query.collideWithAreas = true
    query.collideWithBodies = true

    let hit = space.intersectRay(parameters: query)
    return hit?.position
  }

  func updateExpansion(_ data: PickupRayData) {
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

  func updateLineNode(_ data: PickupRayData) {
    guard let rayLine, let lineMesh = rayLine.mesh as? CylinderMesh else { return }

    let length = data.expandedLength * expansion
    lineMesh.height = length
    rayLine.position = data.origin + Vector3(z: -Float(length) / 2)
    rayLine.rotation = Vector3(x: .pi / 2)
  }

  func updateTipNode(_ data: PickupRayData) {
    let collides = data.collides

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

  func animateExpansion() {
    expansionTween?.kill()
    expansionTween = createTween()
    expansionTween?
      .tweenProperty(object: self, property: "expansion", finalVal: Variant(1), duration: 0.1)?
      .from(value: Variant(expansion))?
      .setEase(.in)?.setTrans(.circ)
  }
}

struct PickupRayData {
  let origin: Vector3
  let target: Vector3
  let expandedLength: Double
  let collides: Bool
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
