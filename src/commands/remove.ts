import { getProjectRoot } from "../common/project";
import { Branch } from "../common/types";
import * as ffi from "../ffi/ffi";
import { handleDefault, showInfo, showPicker } from "./common";

export function run() {
  const result = ffi.findBranchesToCleanup({
    projectRoot: getProjectRoot(),
    branchMaxDepth: 10,
    refBranchName: "main",
  });

  if (result.type === "success") {
    onSuccess(result.value);
  } else {
    handleDefault(result, { errorTitle: "Removing branches failed" });
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

  const selectedBranches = selection.map((name) => {
    return { name: name };
  });
  ffi.cleanupBranches({
    projectRoot: getProjectRoot(),
    branches: selectedBranches,
  });
  showInfo("Successfully removed selected branches.");
}
