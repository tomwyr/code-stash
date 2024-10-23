import ShellOut

class GitCommands {
  private let formatArg = "--format=\"%h %s%n%w(0,2,2)%b\""

  let parser: GitParser

  init(parser: GitParser = GitParser()) {
    self.parser = parser
  }

  func commits(of branch: Branch, limit number: Int) throws -> [Commit] {
    let output = try runGit(with: "log", formatArg, branch.name, "-n", "\(number)", "--")
    return try parser.parseCommitsLog(data: output)
  }

  func commitsDiff(from base: Branch, to target: Branch) throws -> [Commit] {
    let output = try runGit(with: "log", formatArg, "\(base.name)..\(target.name)")
    return try parser.parseCommitsLog(data: output)
  }

  func localBranches() throws -> [Branch] {
    let output = try runGit(with: "branch")
    return try parser.parseBranchLog(data: output, branchType: .remote)
  }

  func remoteBranches() throws -> [Branch] {
    let output = try runGit(with: "branch", "-r")
    return try parser.parseBranchLog(data: output, branchType: .remote)
  }

  func deleteBranch(branch: Branch) throws -> String {
    try runGit(with: "branch", "-D", branch.name)
  }

  private func runGit(with arguments: String...) throws -> String {
    try shellOut(to: "git", arguments: arguments)
  }
}
