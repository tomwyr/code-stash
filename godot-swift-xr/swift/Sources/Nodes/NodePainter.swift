import SwiftGodot

@Godot
class SwiftNodePainter: Node3D, @unchecked Sendable {
  private var controller: XRController3D { getParent() }
  private var colorPicker: SwiftColorPicker { getNode("../../RightHandController/ColorPicker") }
  private var pickupRay: SwiftPickupRay { getNode("../../RightHandController/PickupRay") }

  override func _ready() {
    controller.buttonPressed.connect { button in
      if button == "grip_click" {
        self.paintFocusedTarget()
      }
    }
  }

  private func paintFocusedTarget() {
    if let target = pickupRay.currentCollision as? NodePaintable {
      target.paint(to: colorPicker.activeColor)
    }
  }
}

protocol NodePaintable {
  func paint(to color: Color)
}
