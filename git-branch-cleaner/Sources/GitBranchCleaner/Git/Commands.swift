import ShellOut

class GitCommands {
  static let formatArg = "--format=\"%h %s%n%w(0,2,2)%b\""
  private let formatArg = GitCommands.formatArg

  let runner: GitRunner
  let parser: GitParser

  init(runner: GitRunner = ShellGitRunner(), parser: GitParser = GitParser()) {
    self.runner = runner
    self.parser = parser
  }

  func commits(of branch: Branch, limit number: Int) throws(GitError) -> [Commit] {
    try runCatching {
      let output = try runner.run(with: "log", formatArg, branch.name, "-n", "\(number)", "--")
      return try parser.parseCommitsLog(data: output)
    }
  }

  func commitsDiff(from base: Branch, to target: Branch) throws(GitError) -> [Commit] {
    try runCatching {
      let output = try runner.run(with: "log", formatArg, "\(base.name)..\(target.name)")
      return try parser.parseCommitsLog(data: output)
    }
  }

  func localBranches() throws(GitError) -> [Branch] {
    try runCatching {
      let output = try runner.run(with: "branch")
      return try parser.parseBranchLog(data: output, branchType: .local)
    }
  }

  func remoteBranches() throws(GitError) -> [Branch] {
    try runCatching {
      let output = try runner.run(with: "branch", "-r")
      return try parser.parseBranchLog(data: output, branchType: .remote)
    }
  }

  func deleteBranch(branch: Branch) throws(GitError) {
    try runCatching {
      _ = try runner.run(with: "branch", "-D", branch.name)
    }
  }

  func runCatching<T>(block: () throws -> T) throws(GitError) -> T {
    do {
      return try block()
    } catch let error as GitError {
      throw error
    } catch {
      throw .other(error)
    }
  }
}

public enum GitError: Error {
  case command(ShellOutError)
  case parser(content: String, parse_type: GitParseType)
  case other(Error)
}
