import { Branch } from "../common/types";
import {
  cleanupBranches,
  findBranchesToCleanup,
  handleDefault,
  showInfo,
  showPicker,
} from "./common";

export function run() {
  const result = findBranchesToCleanup();

  if (result.type === "success") {
    onSuccess(result.value);
  } else {
    handleDefault(result, { errorTitle: "Removing branches failed" });
  }
}

async function onSuccess(branches: Branch[]) {
  if (branches.length === 0) {
    showInfo("No branches that can be cleaned up were found.");
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

  const selectedBranches = selection.map((name) => {
    return { name: name };
  });
  cleanupBranches(selectedBranches);
  showInfo("Successfully removed selected branches.");
}
