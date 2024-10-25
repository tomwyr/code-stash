struct GitBranchCleanerConfig {
  let branchMaxDepth: Int
  let refBranchName: String
  let refBranchType: BranchType
  let mergeStrategy: MergeStrategy
  let branchMergeMatchers: [BranchMergeMatcher]

  init(
    branchMaxDepth: Int = 25,
    refBranchName: String = "master",
    refBranchType: BranchType = .local,
    mergeStrategy: MergeStrategy = .squashAndMerge,
    branchMergeMatchers: [BranchMergeMatcher] = [
      .defaultMergeMessage,
      .branchNamePrefix,
      .squashedCommitsMessage,
    ]
  ) {
    self.branchMaxDepth = branchMaxDepth
    self.refBranchName = refBranchName
    self.refBranchType = refBranchType
    self.mergeStrategy = mergeStrategy
    self.branchMergeMatchers = branchMergeMatchers
  }
}

enum MergeStrategy {
  case createMergeCommit, squashAndMerge, rebaseAndMerge
}

enum BranchMergeMatcher {
  case defaultMergeMessage, branchNamePrefix, squashedCommitsMessage
}

enum CommandError: Error {
  case branchesNotFound([Branch])
  case branchesNotRemoved([Branch])
  case gitError(GitError)
}
