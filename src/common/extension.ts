import path from "path";
import * as vscode from "vscode";

export function getLibraryPath(context: vscode.ExtensionContext): string {
  const root = context.extensionPath;
  console.log(root);
  const fileName = "gbc." + getFileExtension();
  return path.join(root, "out", fileName);
}

function getFileExtension(): string {
  switch (process.platform) {
    case "win32":
      return "dll";
    case "linux":
      return "so";
    case "darwin":
      return "dylib";
    default:
      throw unsupportedOsError;
  }
}

const unsupportedOsError = new Error(
  "Unsupported operating system. This extension supports only Windows, Linux, or macOS."
);
