import { getProjectRoot } from "../common/project";
import { Branch } from "../common/types";
import * as ffi from "../ffi/ffi";
import { handleDefault, showInfo } from "./common";

export function run() {
  const result = ffi.findBranchesToCleanup({
    projectRoot: getProjectRoot(),
    branchMaxDepth: 10,
    refBranchName: "main",
  });

  if (result.type === "success") {
    onSuccess(result.value);
  } else {
    handleDefault(result, { errorTitle: "Finding branches failed" });
  }
}

async function onSuccess(branches: Branch[]) {
  if (branches.length === 0) {
    showInfo("No branches that can be cleaned up found.");
    return;
  }

  const removeItem = "Remove All";
  const formattedBranches = branches.map((branch) => branch.name).join(", ");
  const item = await showInfo(
    `Branches that can be cleaned up: ${formattedBranches}`,
    removeItem
  );

  switch (item) {
    case removeItem:
      ffi.cleanupBranches(branches);
      break;
  }
}
