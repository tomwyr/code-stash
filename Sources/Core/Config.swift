struct GitBranchCleanerConfig {
  let branchMaxDepth: Int
  let refBranchName: String
  let refBranchType: BranchType
  let mergeStrategy: BranchMergeStrategy
  let mergeMatchers: [BranchMergeMatcher]

  init(
    branchMaxDepth: Int = 25,
    refBranchName: String = "master",
    refBranchType: BranchType = .local,
    mergeStrategy: BranchMergeStrategy = .squashAndMerge,
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
    self.mergeMatchers = branchMergeMatchers
  }
}
