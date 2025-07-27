import { commands, ExtensionContext } from "vscode"
import { moveSymbolDown, moveSymbolUp } from "./commands"

export function activate(context: ExtensionContext) {
  context.subscriptions.push(
    commands.registerCommand("dart-move-symbol.up", moveSymbolUp),
    commands.registerCommand("dart-move-symbol.down", moveSymbolDown),
  )
}
