struct Commit: Hashable {
  let hash: String
  let summary: String
  let description: String?

  init(hash: String, summary: String, description: String? = nil) {
    self.hash = hash
    self.summary = summary
    self.description = description
  }
}

struct Branch: Hashable {
  let name: String
}

enum BranchType {
  case local, remote
}

struct BranchDiff: Hashable {
  let base: BranchSlice
  let target: BranchSlice
}

struct BranchSlice: Hashable {
  let branch: Branch
  let commits: [Commit]
}

enum BranchMergeMatcher {
  case defaultMergeMessage, branchNamePrefix, squashedCommitsMessage
}

enum BranchMergeStrategy {
  case createMergeCommit, squashAndMerge, rebaseAndMerge
}
