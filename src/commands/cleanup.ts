import { Branch } from "../common/types";
import {
  cleanupBranches,
  handleDefault,
  scanBranches,
  showInfo,
  showPicker,
} from "./common";

export function run() {
  const result = scanBranches();

  if (result.type === "success") {
    pickAndCleanUpBranches(result.value);
  } else {
    handleDefault(result, { errorTitle: "Scanning branches failed" });
  }
}

async function pickAndCleanUpBranches(branches: Branch[]) {
  if (branches.length === 0) {
    showInfo("No branches that can be cleaned up were found.");
    return;
  }
  const selection = await pickBranchesToCleanUp(branches);
  if (selection.length > 0) {
    await cleanUpBranches(selection);
  }
}

async function pickBranchesToCleanUp(branches: Branch[]): Promise<Branch[]> {
  const branchNames = branches.map((branch) => branch.name);
  const selection = await showPicker(branchNames, {
    canPickMany: true,
    placeHolder: "Selected branches to clean up...",
  });

  if (!selection) {
    // Canceled by user.
    return [];
  }

  if (selection.length === 0) {
    showInfo("Nothing to clean up.");
  }

  return selection?.map((name) => {
    return { name: name };
  });
}

async function cleanUpBranches(branches: Branch[]) {
  const result = cleanupBranches(branches);
  if (result.type === "success") {
    showInfo("Successfully removed selected branches.");
  } else {
    handleDefault(result, { errorTitle: "Removing branches failed" });
  }
}
