class GitBranchActions {
  let gitClient: GitClient

  init(gitClient: GitClient = GitClient()) {
    self.gitClient = gitClient
  }

  private func runCatching<T>(block: () throws(GitError) -> T) throws(CommandError) -> T {
    do { return try block() } catch { throw .gitError(error) }
  }
}

extension GitBranchActions {
  func cleanupBranches(branches: [Branch]) throws(CommandError) {
    try validateBranchesExist(branches: branches)
    for branch in branches {
      try runCatching { () throws(GitError) in try gitClient.deleteBranch(branch: branch) }
    }
    try validateBranchesRemoved(branches: branches)
  }

  private func validateBranchesExist(branches: [Branch]) throws(CommandError) {
    let localBranches = try runCatching { () throws(GitError) in
      try gitClient.getLocalOnlyBranches()
    }
    let unknownBranches = branches.toSet().subtracting(localBranches.toSet()).toArray()
    guard unknownBranches.isEmpty else {
      throw .branchesNotFound(unknownBranches)
    }
  }

  private func validateBranchesRemoved(branches: [Branch]) throws(CommandError) {
    let localBranches = try runCatching { () throws(GitError) in
      try gitClient.getLocalOnlyBranches()
    }
    let notRemovedBranches = branches.toSet().intersection(localBranches.toSet()).toArray()
    guard notRemovedBranches.isEmpty else {
      throw .branchesNotRemoved(notRemovedBranches)
    }
  }
}

extension GitBranchActions {
  func findBranchesToCleanup(for config: GitBranchCleanerConfig) throws(CommandError) -> [Branch] {
    try runCatching { () throws(GitError) in
      let localBranches = try gitClient.getLocalOnlyBranches()
      let localToRefBranchDiffs = try diffBranchesAgainstRef(
        localBranches: localBranches,
        for: config
      )

      func mergedInRef(localToRefDiff: BranchDiff) -> Bool {
        config.branchMergeMatchers.contains { matcher in
          matcher.matches(branchDiff: localToRefDiff)
        }
      }

      return localToRefBranchDiffs.filter(mergedInRef).map(\.base.branch)
    }
  }

  private func diffBranchesAgainstRef(
    localBranches: [Branch],
    for config: GitBranchCleanerConfig
  ) throws(GitError) -> [BranchDiff] {
    let maxDepth = config.branchMaxDepth
    let refBranch = Branch(name: config.refBranchName)

    let refSubBranches =
      try! localBranches
      .filter { branch in branch != refBranch }
      .filter { branch in
        try gitClient.hasCommonAncestor(branch: branch, with: refBranch, notDeeperThan: maxDepth)
      }

    return try refSubBranches.map { branch throws(GitError) in
      try gitClient.diffBranches(startingFrom: branch, presentIn: refBranch)
    }
  }
}
