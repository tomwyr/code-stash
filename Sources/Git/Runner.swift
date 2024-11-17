import ShellOut

protocol GitRunner {
  func run(with arguments: String...) throws -> String
}

class ShellGitRunner: GitRunner {
  let path: String

  init(path: String = ".") {
    self.path = path
  }

  func run(with arguments: String...) throws -> String {
    try shellOut(to: "git", arguments: arguments, at: path)
  }
}
