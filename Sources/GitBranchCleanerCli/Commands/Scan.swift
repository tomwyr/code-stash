@preconcurrency import ArgumentParser
import GitBranchCleaner

struct Scan: ParsableCommand {
  func run() {
    let cleaner = GitBranchCleaner()
    let logger = Logger(verbose: verbose)
    let config = GitBranchCleanerConfig(
      branchMaxDepth: maxDepth,
      refBranchName: refBranch
    )

    logger.runScan(config: config)

    do {
      let branches = try cleaner.scanBranches(config: config)
      if branches.isEmpty {
        logger.noBranchesToCleanup()
      } else {
        logger.branchesToCleanup(branches: branches)
      }
    } catch {
      logger.scanError(error: error)
    }
  }

  static let configuration = CommandConfiguration(
    commandName: "scan",
    abstract:
      "Scan cwd for local git branches that have been merged into ref branch and can be safely removed. This command will NOT delete any branches."
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
    )
  )
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
  func runScan(config: GitBranchCleanerConfig) {
    runCommand(command: "scan", config: config)
  }

  func noBranchesToCleanup() {
    log(.info) {
      "No branches that can be cleaned up could be found."
    }
  }

  func branchesToCleanup(branches: [Branch]) {
    let branchCount = if branches.count == 1 { "branch" } else { "\(branches.count) branches" }
    let formattedBranches = branches.map(\.name).joined(separator: " ")
    log(.info) {
      """
      The following \(branchCount) can be cleaned up:
      \(formattedBranches)
      """
    }
  }

  func scanError(error: GitBranchCleanerError) {
    commandError(command: "scan", error: error)
  }
}
