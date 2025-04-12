import SwiftGodot

@Godot
class SwiftRayPainter: Node3D, @unchecked Sendable {
  private var controller: XRController3D { getParent() }
  private var colorPicker: SwiftColorPicker { getNode("../../RightHandController/ColorPicker") }
  private var pickupRay: SwiftPickupRay { getNode("../../RightHandController/PickupRay") }

  private var delegates = [any RayPainterDelegate]()

  override func _ready() {
    controller.buttonPressed.connect { button in
      if button == "grip_click" {
        self.paintFocusedTarget()
      }
    }
  }

  func register(delegate: any RayPainterDelegate) {
    delegates.append(delegate)
  }

  private func paintFocusedTarget() {
    guard let target = pickupRay.currentCollision else { return }

    let color = colorPicker.activeColor
    for delegate in delegates {
      if delegate.paint(target, to: color) {
        break
      }
    }
  }
}

protocol RayPainterDelegate {
  func paint(_ target: Object, to color: Color) -> Bool
}
