@preconcurrency import ArgumentParser

struct Remove: ParsableCommand {
  func run() {
    let cleaner = GitBranchCleaner()
    let logger = Logger(verbose: verbose)
    let config = GitBranchCleanerConfig(
      branchMaxDepth: maxDepth,
      refBranchName: refBranch
    )

    logger.runRemove(config: config)

    do {
      let branches = try cleaner.findBranchesToCleanup(config: config)
      _ = try cleaner.cleanupBranches(branches: branches)
      logger.branchesRemoved(branches: branches)
    } catch {
      logger.removeError(error: error)
    }
  }

  static let configuration = CommandConfiguration(
    commandName: "remove",
    abstract:
      "Remove cwd local git branches that have been merged into ref branch. This command WILL delete found branches."
  )

  @Flag(
    name: .shortAndLong,
    help: "Show detailed output of command."
  )
  var verbose = false

  @Option(
    name: .shortAndLong,
    help: ArgumentHelp(
      "Number of commits of the ref branch history to check for common history between cleaned up branches and the ref branch.",
      valueName: "commits-number"
    ))
  var maxDepth: Int = 25

  @Option(
    name: .shortAndLong,
    help: ArgumentHelp(
      "Name of the branch that cleaned up branches are merged into.",
      valueName: "branch-name"
    )
  )
  var refBranch: String = "main"
}

extension Logger {
  func runRemove(config: GitBranchCleanerConfig) {
    runCommand(command: "remove", config: config)
  }

  func branchesRemoved(branches: [Branch]) {
    let formattedBranches = branches.map(\.name).joined(separator: ", ")
    log(.info) {
      """
      Cleanup successful. Removed the following branches:
      \(formattedBranches)
      """
    }
  }

  func removeError(error: BranchCleanerError) {
    commandError(command: "find", error: error)
  }
}
