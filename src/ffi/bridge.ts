import { close, DataType, define, open } from "ffi-rs";
import * as vscode from "vscode";
import { getLibraryPath } from "../common/library";
import { Branch } from "../common/types";
import { parseResult, Result } from "./result";

export function initialize(context: vscode.ExtensionContext) {
  open({
    library: "gbc",
    path: getLibraryPath(context),
  });
}

export function dispose() {
  close("gbc");
}

export function findBranchesToCleanup({
  projectRoot,
  branchMaxDepth,
  refBranchName,
}: FindBranchesToCleanupInput): Result<Branch[]> {
  const result = gbc.findBranchesToCleanup([
    projectRoot,
    branchMaxDepth,
    refBranchName,
  ]);
  return parseResult(result);
}

export type FindBranchesToCleanupInput = {
  projectRoot: string;
  branchMaxDepth: number;
  refBranchName: string;
};

export function cleanupBranches(branches: Branch[]) {
  const branchesData = branches.map((branch) => branch.name);
  gbc.cleanupBranches(branchesData);
}

const gbc = define({
  findBranchesToCleanup: {
    library: "gbc",
    paramsType: [DataType.String, DataType.I32, DataType.String],
    retType: DataType.String,
    freeResultMemory: true,
  },
  cleanupBranches: {
    library: "gbc",
    paramsType: [DataType.String],
    retType: DataType.String,
    freeResultMemory: true,
  },
});
