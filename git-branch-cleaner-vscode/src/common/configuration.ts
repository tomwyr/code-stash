import * as vscode from "vscode";

export function loadConfiguration(): GitBranchCleanerConfig {
  const extConfig = vscode.workspace.getConfiguration(
    "git-branch-cleaner-vscode"
  );
  return {
    refBranch: extConfig.get("refBranch", "main"),
    maxDepth: extConfig.get("maxDepth", 100),
  };
}

export type GitBranchCleanerConfig = {
  refBranch: string;
  maxDepth: number;
};
