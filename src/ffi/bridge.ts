import { open, define, DataType, close } from "ffi-rs";
import { parseResult, Result } from "./result";
import { Branch } from "../common/types";

export function initialize() {
  open({
    library: "gbc",
    path: `${__dirname}/gbc.dylib`,
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

export function cleanupBranches(branches: [Branch]) {
  const branchesData = JSON.stringify(branches);
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
