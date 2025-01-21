@preconcurrency import ArgumentParser
import GitBranchCleaner

struct Cleanup: ParsableCommand {
  func run() {
    let cleaner = GitBranchCleaner()
    let logger = Logger(verbose: verbose)
    let config = GitBranchCleanerConfig(
      branchMaxDepth: maxDepth,
      refBranchName: refBranch
    )

    logger.runCleanup(config: config)

    do {
      let branches = try cleaner.scanBranches(config: config)
      _ = try cleaner.cleanupBranches(branches: branches)
      logger.branchesCleanedUp(branches: branches)
    } catch {
      logger.cleanupError(error: error)
    }
  }

  static let configuration = CommandConfiguration(
    commandName: "cleanup",
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
  var maxDepth: Int = 100

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
  func runCleanup(config: GitBranchCleanerConfig) {
    runCommand(command: "cleanup", config: config)
  }

  func branchesCleanedUp(branches: [Branch]) {
    let formattedBranches = branches.map(\.name).joined(separator: ", ")
    log(.info) {
      """
      Cleanup successful. Removed the following branches:
      \(formattedBranches)
      """
    }
  }

  func cleanupError(error: GitBranchCleanerError) {
    commandError(command: "scan", error: error)
  }
}
