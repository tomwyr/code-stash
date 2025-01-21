import { Branch } from "../common/types";
import {
  cleanupBranches,
  findBranchesToCleanup,
  handleDefault,
  showInfo,
} from "./common";

export function run() {
  const result = findBranchesToCleanup();

  if (result.type === "success") {
    onSuccess(result.value);
  } else {
    handleDefault(result, { errorTitle: "Finding branches failed" });
  }
}

async function onSuccess(branches: Branch[]) {
  if (branches.length === 0) {
    showInfo("No branches that can be cleaned up were found.");
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
      cleanupBranches(branches);
      break;
  }
}
