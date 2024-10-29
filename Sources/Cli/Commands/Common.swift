extension Logger {
  func runCommand(command: String, config: GitBranchCleanerConfig?) {
    log(.debug) {
      if let config = config {
        "Running command \"\(command)\" with config: \(config)"
      } else {
        "Running command \"\(command)\""
      }
    }
  }

  func commandError(command: String, error: BranchCleanerError) {
    log(.debug) {
      """
      An error occured while running \"\(command)\" command: \(error)

      This is most likely an error that needs to be fixed.
      Please visit https://github.com/tomwyr/git_branch_cleaner/issues and open an issue or search for existing similar issues.
      """
    }
  }

  func runGitCommand(arguments: [String]) {
    log(.debug) {
      "Running git command: git \(arguments.joined(separator: " "))"
    }
  }
}
