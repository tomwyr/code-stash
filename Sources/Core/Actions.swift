class BranchCleanerActions {
  private let git: GitClient

  init(gitClient: GitClient = GitClient()) {
    self.git = gitClient
  }
}

extension BranchCleanerActions {
  func findBranchesToCleanup(
    for config: GitBranchCleanerConfig
  ) throws(BranchCleanerError) -> [Branch] {
    let matchers = config.mergeMatchers

    let localBranches = try runCatching {
      try git.getLocalOnlyBranches()
    }
    let localToRefBranchDiffs = try diffBranchesAgainstRef(
      localBranches: localBranches,
      for: config
    )

    let localBranchesInRef = localToRefBranchDiffs.filter { branchDiff in
      matchers.contains { matcher in
        matcher.matches(branchDiff: branchDiff)
      }
    }

    return localBranchesInRef.map(\.base.branch)
  }

  private func diffBranchesAgainstRef(
    localBranches: [Branch],
    for config: GitBranchCleanerConfig
  ) throws(BranchCleanerError) -> [BranchDiff] {
    let maxDepth = config.branchMaxDepth
    let refBranch = Branch(name: config.refBranchName)

    let refSubBranches =
      try localBranches
      .filter { branch in branch != refBranch }
      .filterThrowing { branch throws(BranchCleanerError) in
        try runCatching {
          try git.hasCommonAncestor(branch: branch, with: refBranch, notDeeperThan: maxDepth)
        }
      }

    return try refSubBranches.map { branch throws(BranchCleanerError) in
      try runCatching {
        try git.diffBranches(startingFrom: branch, presentIn: refBranch)
      }
    }
  }
}

extension BranchCleanerActions {
  func cleanupBranches(branches: [Branch]) throws(BranchCleanerError) {
    try validateBranchesExist(branches: branches)
    for branch in branches {
      try runCatching {
        try git.deleteBranch(branch: branch)
      }
    }
    try validateBranchesRemoved(branches: branches)
  }

  private func validateBranchesExist(branches: [Branch]) throws(BranchCleanerError) {
    let localBranches = try runCatching {
      try git.getLocalOnlyBranches()
    }
    let unknownBranches = branches.toSet().subtracting(localBranches.toSet()).toArray()
    guard unknownBranches.isEmpty else {
      throw .branchesNotFound(unknownBranches)
    }
  }

  private func validateBranchesRemoved(branches: [Branch]) throws(BranchCleanerError) {
    let localBranches = try runCatching {
      try git.getLocalOnlyBranches()
    }
    let notRemovedBranches = branches.toSet().intersection(localBranches.toSet()).toArray()
    guard notRemovedBranches.isEmpty else {
      throw .branchesNotRemoved(notRemovedBranches)
    }
  }

  private func runCatching<T>(block: () throws -> T) throws(BranchCleanerError) -> T {
    do {
      return try block()
    } catch let error as GitError {
      throw .git(error)
    } catch {
      throw .other(error)
    }
  }
}

enum BranchCleanerError: Error {
  case branchesNotFound([Branch])
  case branchesNotRemoved([Branch])
  case git(GitError)
  case other(Error)
}
