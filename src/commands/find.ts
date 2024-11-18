import * as vscode from "vscode";
import * as ffi from "../ffi/ffi";
import { getProjectRoot } from "../common/project";
import { Branch } from "../common/types";

export function run() {
  let result = ffi.findBranchesToCleanup({
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

function onSuccess(branches: Branch[]) {
  let formattedBranches = branches.map((branch) => branch.name).join(", ");
  showInfo(`Branches: ${formattedBranches}`);
}

async function onError(error: object) {
  let title = "Finding branches failed";
  let moreInfo = "More info";

  let item = await showError(title, moreInfo);
  switch (item) {
    case moreInfo:
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
