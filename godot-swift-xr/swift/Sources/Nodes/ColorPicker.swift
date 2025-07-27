import SwiftGodot

@Godot
class SwiftColorPicker: Node3D, @unchecked Sendable {
  private var controller: XRController3D { getParent() }
  private var panel: MeshInstance3D { getNode("Panel") }
  private var title: Label3D { getNode("Panel/Title") }
  private var currentColor: MeshInstance3D { getNode("Panel/CurrentColor") }
  private var previousColor: MeshInstance3D { getNode("Panel/PreviousColor") }
  private var nextColor: MeshInstance3D { getNode("Panel/NextColor") }

  @Signal var colorChanged: SignalWithArguments<Color>
  var activeColor: Color { picker.activeColor }

  private var open = false
  private var animating = false
  private var picker = ColorPicker()
  private var activeGesture: StickGesture?

  override func _ready() {
    picker.onChanged = { color in
      self.updatePanelColors()
      self.colorChanged.emit(color)
    }
    setupSignals()
    if Engine.isEditorHint() {
      openPanel()
    }
  }

  private func setupSignals() {
    controller.inputVector2Changed.connect { name, input in
      guard name == "primary" else { return }
      self.processStickInput(input)
    }
  }

  private func processStickInput(_ input: Vector2) {
    // Disallow gestures during opening/closing the panel.
    if animating { return }

    // Keep gesture active above threshold to avoid changing the color repeatedly.
    if activeGesture != nil && input.length() < 0.5 {
      activeGesture = nil
      return
    }

    let gesture = StickGesture(input: input, threshold: 0.95)
    if let gesture, activeGesture != gesture {
      processStickGesture(gesture)
    }
    activeGesture = gesture
  }

  private func processStickGesture(_ gesture: StickGesture) {
    switch gesture {
    case .up:
      if !open {
        openPanel()
      }
    case .down:
      if open {
        closePanel()
      }
    case .left:
      if open {
        picker.pickPrevious()
      }
    case .right:
      if open {
        picker.pickNext()
      }
    }
  }

  private func openPanel() {
    open = true
    let node = ColorPickerPanel.create(name: "Panel")
    addChild(node: node)
    updatePanelColors()
    animatePanel(to: .open)
  }

  private func closePanel() {
    open = false
    animatePanel(
      to: .close,
      onDone: { self.getNode("Panel").queueFree() }
    )
  }

  private func updatePanelColors() {
    modifyPlaneMesh(currentColor, color: picker.activeColor)
    modifyPlaneMesh(previousColor, color: picker.previousColor)
    modifyPlaneMesh(nextColor, color: picker.nextColor)
  }

  private func animatePanel(to direction: PanelDirection, onDone: (() -> Void)? = nil) {
    let (start, end) =
      switch direction {
      case .open: (0.0, 1.0)
      case .close: (1.0, 0.0)
      }

    let tween = createTween()?.tweenMethod(
      Callable(updateExpansion),
      from: Variant(start),
      to: Variant(end),
      duration: 0.3
    )?.setEase(.inOut)?.setTrans(.cubic)

    animating = true
    tween?.finished.connect {
      self.animating = false
      onDone?()
    }
  }

  private func updateExpansion(value: Float) {
    panel.position = getPanelPosition(expansion: value)
    modifyPlaneMesh(panel, alpha: value)
    modifyLabel(title, alpha: value)
    modifyPlaneMesh(currentColor, alpha: value)
    modifyPlaneMesh(previousColor, alpha: value)
    modifyPlaneMesh(nextColor, alpha: value)
  }

  private func modifyPlaneMesh(_ node: MeshInstance3D, color: Color? = nil, alpha: Float? = nil) {
    if let mesh = node.mesh as? PlaneMesh,
      let material = mesh.material as? StandardMaterial3D
    {
      if let color {
        material.albedoColor = color
      }
      if let alpha {
        material.albedoColor.alpha = alpha
      }
    }
  }

  private func modifyLabel(_ node: Label3D, alpha: Float? = nil) {
    if let alpha {
      node.modulate.alpha = alpha
    }
  }

  private func getPanelPosition(expansion: Float) -> Vector3 {
    let expansionShift = Vector3(x: 0.01, y: -0.1, z: -0.01) * Double(1 - expansion)
    return ColorPickerPanel.position + expansionShift
  }
}

enum PanelDirection {
  case open, close
}

struct ColorPickerPanel {
  static var position: Vector3 { Vector3(x: 0.05, y: 0.15, z: 0.05) }

  static func create(name: StringName) -> MeshInstance3D? {
    guard let scene = GD.load(path: "res://scenes/color_panel.tscn") as? PackedScene,
      let node = scene.instantiate() as? MeshInstance3D
    else { return nil }
    node.name = name
    node.position = position
    return node
  }
}

class ColorPicker {
  let colors = [Color](arrayLiteral: .red, .green, .blue, .yellow, .purple)

  private var activeIndex = 0
  private var previousIndex: Int { activeIndex > 0 ? activeIndex - 1 : colors.count - 1 }
  private var nextIndex: Int { activeIndex < colors.count - 1 ? activeIndex + 1 : 0 }

  var activeColor: Color { colors[activeIndex] }
  var previousColor: Color { colors[previousIndex] }
  var nextColor: Color { colors[nextIndex] }

  var onChanged: ((Color) -> Void)? = nil

  func pickPrevious() {
    pickColor(at: previousIndex)
  }

  func pickNext() {
    pickColor(at: nextIndex)
  }

  private func pickColor(at index: Int) {
    if index == activeIndex { return }
    activeIndex = index
    onChanged?(activeColor)
  }
}

enum StickGesture {
  case up, down, left, right

  init?(input: Vector2, threshold: Float) {
    if input.y >= threshold {
      self = .up
    } else if input.y <= -threshold {
      self = .down
    } else if input.x >= threshold {
      self = .right
    } else if input.x <= -threshold {
      self = .left
    } else {
      return nil
    }
  }
}
