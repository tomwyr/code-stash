class GitClient {
  let commands: GitCommands

  init(commands: GitCommands = GitCommands()) {
    self.commands = commands
  }

  func getLocalOnlyBranches() throws(GitError) -> [Branch] {
    let localBranches = try commands.localBranches()
    let remoteBranches = try commands.remoteBranches()
    let localOnlyBranches = localBranches.toSet().subtracting(remoteBranches.toSet())
    // Filter the original array to preserve order of the elements.
    return localBranches.filter(localOnlyBranches.contains)
  }

  func deleteBranch(branch: Branch) throws(GitError) {
    try commands.deleteBranch(branch: branch)
  }

  func hasCommonAncestor(
    branch: Branch,
    with other: Branch,
    notDeeperThan maxDepth: Int
  ) throws(GitError) -> Bool {
    let branchCommits = try commands.commits(of: branch, limit: maxDepth).toSet()
    let otherCommits = try commands.commits(of: other, limit: maxDepth).toSet()
    return !branchCommits.isDisjoint(with: otherCommits)
  }

  func diffBranches(
    startingFrom base: Branch,
    presentIn target: Branch
  ) throws(GitError) -> BranchDiff {
    let baseOnlyCommits = try commands.commitsDiff(from: target, to: base)
    let targetOnlyCommits = try commands.commitsDiff(from: base, to: target)
    return BranchDiff(
      base: BranchSlice(branch: base, commits: baseOnlyCommits),
      target: BranchSlice(branch: target, commits: targetOnlyCommits)
    )
  }

  func filterLocalBranches(from branches: [Branch]) throws(GitError) -> [Branch] {
    let localBranches = try commands.localBranches()
    let inputLocalBranches = branches.toSet().intersection(localBranches.toSet())
    // Filter the original array to preserve order of the elements.
    return branches.filter(inputLocalBranches.contains)
  }

  func filterNonLocalBranches(from branches: [Branch]) throws(GitError) -> [Branch] {
    let localBranches = try commands.localBranches()
    let inputNonLocalBranches = branches.toSet().subtracting(localBranches.toSet())
    // Filter the original array to preserve order of the elements.
    return branches.filter(inputNonLocalBranches.contains)
  }

  func filterRemoteBranches(from branches: [Branch]) throws(GitError) -> [Branch] {
    let remoteBranches = try commands.remoteBranches()
    let inputRemoteBranches = branches.toSet().intersection(remoteBranches.toSet())
    // Filter the original array to preserve order of the elements.
    return branches.filter(inputRemoteBranches.contains)
  }
}
