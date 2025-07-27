import * as vscode from "vscode";
import * as commands from "./commands/commands";
import * as ffi from "./ffi/ffi";

export function activate(context: vscode.ExtensionContext) {
  ffi.initialize(context);
  registerCommands(context);
}

function registerCommands(context: vscode.ExtensionContext) {
  const pushCommand = (command: string, callback: () => void) => {
    context.subscriptions.push(
      vscode.commands.registerCommand(command, callback)
    );
  };

  pushCommand("git-branch-cleaner-vscode.scan", commands.scan);
  pushCommand("git-branch-cleaner-vscode.cleanup", commands.cleanup);
}

export function deactivate() {
  ffi.dispose();
}
