import ShellOut

protocol GitRunner {
  func run(with arguments: String...) throws -> String
}

class ShellGitRunner: GitRunner {
  func run(with arguments: String...) throws -> String {
    try shellOut(to: "git", arguments: arguments)
  }
}
