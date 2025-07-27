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

public struct Branch: Hashable, Sendable, Codable {
  public init(name: String) {
    self.name = name
  }

  public let name: String
}

struct BranchDiff: Hashable {
  let base: BranchSlice
  let target: BranchSlice
}

struct BranchSlice: Hashable {
  let branch: Branch
  let commits: [Commit]
}

public enum BranchType {
  case local, remote
}

public enum BranchMergeMatcher {
  case defaultMergeMessage, branchNamePrefix, squashedCommitsMessage, identicalHistory
}

public enum BranchMergeStrategy {
  case createMergeCommit, squashAndMerge, rebaseAndMerge
}
