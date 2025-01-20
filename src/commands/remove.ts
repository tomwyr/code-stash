import * as vscode from "vscode";
import * as ffi from "../ffi/ffi";
import { getProjectRoot } from "../common/project";
import { Branch } from "../common/types";

export function run() {
  const result = ffi.findBranchesToCleanup({
    projectRoot: getProjectRoot(),
    branchMaxDepth: 10,
    refBranchName: "main",
  });

  switch (result.type) {
    case "success":
      onSuccess(result.value);
      break;
    case "error":
      onError(result.value);
      break;
    case "unknown":
      onUnknown(result.value);
      break;
  }
}

async function onSuccess(branches: Branch[]) {
  if (branches.length === 0) {
    showInfo("No branches that can be cleaned up could be found.");
    return;
  }

  const branchNames = branches.map((branch) => branch.name);

  const selection = await showPicker(branchNames, {
    canPickMany: true,
    placeHolder: "Selected branches to clean up...",
  });

  if (!selection) {
    return;
  } else if (selection.length === 0) {
    showInfo("Nothing to clean up.");
    return;
  }

  const branchesToRemove = selection.map((name) => {
    return {
      name: name,
    } satisfies Branch;
  });
  ffi.cleanupBranches(branchesToRemove);
  showInfo("Successfully removed selected branches.");
}

async function onError(error: object) {
  const title = "Finding branches failed";
  const moreItem = "More info";

  const item = await showError(title, moreItem);
  switch (item) {
    case moreItem:
      showError(title, {
        modal: true,
        detail: JSON.stringify(error),
      });
      break;
  }
}

function onUnknown(result: any) {
  showWarning(`Unexpected result received: ${result}`);
}

const showInfo = vscode.window.showInformationMessage;
const showWarning = vscode.window.showWarningMessage;
const showError = vscode.window.showErrorMessage;
const showPicker = vscode.window.showQuickPick;
