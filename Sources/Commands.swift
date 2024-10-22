@preconcurrency import ArgumentParser

@main
struct GitBranchCleaner: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "gbc",
    abstract: "A command-line utility for cleaning up git branches.",
    version: "1.0.0",
    subcommands: [Find.self, Remove.self]
  )
}

struct Find: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "find",
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
  var maxDepth: Int = 25

  @Option(
    name: .shortAndLong,
    help: ArgumentHelp(
      "Name of the branch that cleaned up branches are merged into.",
      valueName: "branch-name"
    )
  )
  var refBranch: String = "master"
}

struct Remove: ParsableCommand {
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
  var refBranch: String = "master"
}
