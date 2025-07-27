import * as vscode from "vscode";

export function getProjectRoot(): string {
  const folders = vscode.workspace.workspaceFolders ?? [];
  if (folders.length === 0) {
    throw noProjectError;
  } else if (folders.length > 1) {
    throw multipleProjectsError;
  }

  const uri = folders[0].uri.toString();
  if (!uri.startsWith("file://")) {
    throw invalidProjectError;
  }

  return uri.replace("file://", "");
}

const noProjectError = new Error(
  "No active folder could be found. Open a project with Git repository before using Git Branch Cleaner."
);
const multipleProjectsError = new Error(
  "Multiple active folders found. Open a single project before using Git Branch Cleaner."
);
const invalidProjectError = new Error(
  "Unsupported folder type found. Open a local project before using Git Branch Cleaner."
);
