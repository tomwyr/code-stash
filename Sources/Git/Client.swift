class GitClient {
  private let commands: GitCommands

  init(commands: GitCommands = GitCommands()) {
    self.commands = commands
  }

  func getLocalOnlyBranches() throws(GitError) -> [Branch] {
    try runCatching {
      let localBranches = try commands.localBranches().toSet()
      let remoteBranches = try commands.remoteBranches().toSet()
      return localBranches.subtracting(remoteBranches).toArray()
    }
  }

  func diffBranches(startingFrom base: Branch, presentIn target: Branch) throws(GitError)
    -> BranchDiff
  {
    try runCatching {
      let baseOnlyCommits = try commands.commitsDiff(from: target, to: base)
      let targetOnlyCommits = try commands.commitsDiff(from: base, to: target)
      return BranchDiff(
        base: BranchSlice(branch: base, commits: baseOnlyCommits),
        target: BranchSlice(branch: target, commits: targetOnlyCommits)
      )
    }
  }

  func hasCommonAncestor(branch: Branch, with other: Branch, notDeeperThan maxDepth: Int)
    throws(GitError) -> Bool
  {
    try runCatching {
      let branchCommits = try commands.commits(of: branch, limit: maxDepth).toSet()
      let otherCommits = try commands.commits(of: other, limit: maxDepth).toSet()
      return !branchCommits.isDisjoint(with: otherCommits)
    }
  }

  func deleteBranch(branch: Branch) throws(GitError) {
    try runCatching {
      _ = try commands.deleteBranch(branch: branch)
    }
  }

  private func runCatching<T>(block: () throws -> T) throws(GitError) -> T {
    do {
      return try block()
    } catch let error as GitError {
      throw error
    } catch {
      throw .unknown(cause: error)
    }
  }
}
