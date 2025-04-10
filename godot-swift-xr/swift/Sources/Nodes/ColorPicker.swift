import SwiftGodot

@Godot
class SwiftColorPicker: Node3D, @unchecked Sendable {
  private var controller: XRController3D { getParent() }
  private var currentColor: MeshInstance3D? { getNodeOrNull("Panel/CurrentColor") }
  private var previousColor: MeshInstance3D? { getNodeOrNull("Panel/PreviousColor") }
  private var nextColor: MeshInstance3D? { getNodeOrNull("Panel/NextColor") }

  @Signal var colorChanged: SignalWithArguments<Color>
  var activeColor: Color { picker.activeColor }

  var open = false
  var picker = ColorPicker()
  var activeGesture: StickGesture?

  override func _ready() {
    picker.onChanged = { color in
      self.updatePanel()
      self.colorChanged.emit(color)
    }
    setupSignals()
    if Engine.isEditorHint() {
      openPanel()
    }
  }

  func setupSignals() {
    controller.inputVector2Changed.connect { name, input in
      guard name == "primary" else { return }
      self.processStickInput(input)
    }
  }

  func processStickInput(_ input: Vector2) {
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

  func processStickGesture(_ gesture: StickGesture) {
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

  func openPanel() {
    open = true
    let node = ColorPickerPanel.create(name: "Panel")
    addChild(node: node)
    updatePanel()
  }

  func closePanel() {
    open = false
    getNode("Panel").queueFree()
  }

  func updatePanel() {
    setPanelColor(of: currentColor, to: picker.activeColor)
    setPanelColor(of: previousColor, to: picker.previousColor)
    setPanelColor(of: nextColor, to: picker.nextColor)
  }

  func setPanelColor(of node: MeshInstance3D?, to color: Color) {
    if let mesh = node?.mesh as? PlaneMesh,
      let material = mesh.material as? StandardMaterial3D
    {
      material.albedoColor = color
    }
  }
}

struct ColorPickerPanel {
  static func create(name: StringName) -> MeshInstance3D? {
    guard let scene = GD.load(path: "res://scenes/color_panel.tscn") as? PackedScene,
      let node = scene.instantiate() as? MeshInstance3D
    else { return nil }
    node.name = name
    node.position = Vector3(x: 0.05, y: 0.15, z: 0.05)
    return node
  }
}

class ColorPicker {
  let colors = [Color](arrayLiteral: .red, .green, .blue, .yellow, .purple)

  private(set) var activeIndex = 0
  var previousIndex: Int { activeIndex > 0 ? activeIndex - 1 : colors.count - 1 }
  var nextIndex: Int { activeIndex < colors.count - 1 ? activeIndex + 1 : 0 }

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
