import Foundation
import SwiftGodot

@Godot(.tool)
class SwiftLabel3D: Label3D, @unchecked Sendable {
  @Export
  var initialText: String = "..."

  override func _ready() {
    text = initialText
  }

  override func _process(delta: Double) {
    if Engine.isEditorHint() {
      text = "<\(initialText)>"
    }
  }
}
