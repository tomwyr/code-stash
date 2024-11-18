import * as vscode from "vscode";
import * as commands from "./commands/commands";
import * as ffi from "./ffi/ffi";

export function activate(context: vscode.ExtensionContext) {
  ffi.initialize();
  registerCommands(context);
}

function registerCommands(context: vscode.ExtensionContext) {
  const pushCommand = (command: string, callback: () => void) => {
    context.subscriptions.push(
      vscode.commands.registerCommand(command, callback)
    );
  };

  pushCommand("git-branch-cleaner.find", commands.find);
  pushCommand("git-branch-cleaner.remove", commands.remove);
}

export function deactivate() {
  ffi.dispose();
}
