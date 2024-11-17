public class GitBranchCleaner {
  private let git: GitClient

  public init() {
    self.git = GitClient()
  }

  public init(projectRoot: String) {
    self.git = GitClient(commands: GitCommands(runner: ShellGitRunner(path: projectRoot)))
  }

  init(gitClient: GitClient = GitClient()) {
    self.git = gitClient
  }
}

extension GitBranchCleaner {
  public func findBranchesToCleanup(
    config: GitBranchCleanerConfig
  ) throws(GitBranchCleanerError) -> [Branch] {
    let matchers = config.mergeMatchers

    let localBranches = try runCatching {
      try git.getLocalOnlyBranches()
    }
    let localToRefBranchDiffs = try diffBranchesAgainstRef(
      localBranches: localBranches,
      config: config
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
    config: GitBranchCleanerConfig
  ) throws(GitBranchCleanerError) -> [BranchDiff] {
    let maxDepth = config.branchMaxDepth
    let refBranch = Branch(name: config.refBranchName)

    let refSubBranches =
      try localBranches
      .filter { branch in branch != refBranch }
      .filterThrowing { branch throws(GitBranchCleanerError) in
        try runCatching {
          try git.hasCommonAncestor(branch: branch, with: refBranch, notDeeperThan: maxDepth)
        }
      }

    return try refSubBranches.map { branch throws(GitBranchCleanerError) in
      try runCatching {
        try git.diffBranches(startingFrom: branch, presentIn: refBranch)
      }
    }
  }
}

extension GitBranchCleaner {
  public func cleanupBranches(branches: [Branch]) throws(GitBranchCleanerError) {
    try validateBranchesBeforeCleanup(branches: branches)
    for branch in branches {
      try runCatching {
        try git.deleteBranch(branch: branch)
      }
    }
    try validateBranchesAfterCleanup(branches: branches)
  }

  private func validateBranchesBeforeCleanup(branches: [Branch]) throws(GitBranchCleanerError) {
    let (unknownBranches, remoteBranches) = try runCatching {
      (
        try git.filterNonLocalBranches(from: branches),
        try git.filterRemoteBranches(from: branches)
      )
    }
    guard unknownBranches.isEmpty else {
      throw .branchesNotFound(unknownBranches)
    }
    guard remoteBranches.isEmpty else {
      throw .branchesInRemote(remoteBranches)
    }
  }

  private func validateBranchesAfterCleanup(branches: [Branch]) throws(GitBranchCleanerError) {
    let notRemovedBranches = try runCatching {
      try git.filterLocalBranches(from: branches)
    }
    guard notRemovedBranches.isEmpty else {
      throw .branchesNotRemoved(notRemovedBranches)
    }
  }

  private func runCatching<T>(block: () throws -> T) throws(GitBranchCleanerError) -> T {
    do {
      return try block()
    } catch let error as GitError {
      throw .git(error)
    } catch {
      throw .other(error)
    }
  }
}

public enum GitBranchCleanerError: Error {
  case branchesNotFound([Branch])
  case branchesInRemote([Branch])
  case branchesNotRemoved([Branch])
  case git(GitError)
  case other(Error)
}
