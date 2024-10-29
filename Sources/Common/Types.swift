struct Commit: Hashable {
  let hash: String
  let summary: String
  let description: String?
}

struct Branch: Hashable {
  let name: String
}

enum BranchType {
  case local, remote
}

struct BranchDiff {
  let base: BranchSlice
  let target: BranchSlice
}

struct BranchSlice {
  let branch: Branch
  let commits: [Commit]
}

enum BranchMergeMatcher {
  case defaultMergeMessage, branchNamePrefix, squashedCommitsMessage
}

enum BranchMergeStrategy {
  case createMergeCommit, squashAndMerge, rebaseAndMerge
}
