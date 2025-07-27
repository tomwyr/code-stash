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

export function scanBranches({
  projectRoot,
  branchMaxDepth,
  refBranchName,
}: ScanBranchesInput): Result<Branch[]> {
  const result = gbc.scanBranches([projectRoot, branchMaxDepth, refBranchName]);
  return parseResult(result);
}

export type ScanBranchesInput = {
  projectRoot: string;
  branchMaxDepth: number;
  refBranchName: string;
};

export function cleanupBranches({
  projectRoot,
  branches,
}: CleanupBranchesInput): Result<void> {
  const branchesData = JSON.stringify(branches);
  const result = gbc.cleanupBranches([projectRoot, branchesData]);
  return parseResult(result, { discardData: true });
}

export type CleanupBranchesInput = {
  projectRoot: string;
  branches: Branch[];
};

const gbc = define({
  scanBranches: {
    library: "gbc",
    paramsType: [DataType.String, DataType.I32, DataType.String],
    retType: DataType.String,
    freeResultMemory: true,
  },
  cleanupBranches: {
    library: "gbc",
    paramsType: [DataType.String, DataType.String],
    retType: DataType.String,
    freeResultMemory: true,
  },
});
