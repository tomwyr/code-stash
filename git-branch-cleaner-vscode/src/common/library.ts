import path from "path";
import * as vscode from "vscode";

export function getLibraryPath(context: vscode.ExtensionContext): string {
  const root = context.extensionPath;
  const fileName = getFileName();
  return path.join(root, "out", fileName);
}

function getFileName(): string {
  switch (process.platform) {
    case "win32":
      return "gbc-windows.dll";
    case "linux":
      return "gbc-linux.so";
    case "darwin":
      return "gbc-macos.dylib";
    default:
      throw unsupportedOsError;
  }
}

const unsupportedOsError = new Error(
  "Unsupported operating system. This extension supports only Windows, Linux, or macOS."
);
