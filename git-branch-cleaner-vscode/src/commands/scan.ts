import { Branch } from "../common/types";
import * as cleanup from "./cleanup";
import { handleDefault, scanBranches, showInfo } from "./common";

export function run() {
  const result = scanBranches();

  if (result.type === "success") {
    showStaleBranchesInfo(result.value);
  } else {
    handleDefault(result, { errorTitle: "Scanning branches failed" });
  }
}

async function showStaleBranchesInfo(branches: Branch[]) {
  if (branches.length === 0) {
    showInfo("No branches that can be cleaned up were found.");
    return;
  }

  const cleanUpItem = "Cleanup";
  const item = await showInfo(formatCleanUpMessage(branches), cleanUpItem);

  switch (item) {
    case cleanUpItem:
      cleanup.run();
      break;
  }
}

function formatCleanUpMessage(branches: Branch[]) {
  const formattedBranches = branches.map((branch) => branch.name).join(", ");
  return `Found ${branches.length} branch${
    branches.length > 1 ? "es" : ""
  } that can be cleaned up: ${formattedBranches}.`;
}
