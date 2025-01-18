@preconcurrency import ArgumentParser
import GitBranchCleaner

@main
struct GitBranchCleanerCli: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "gbc",
    abstract: "A command-line utility for cleaning up git branches.",
    version: "0.0.3",
    subcommands: [Find.self, Remove.self]
  )
}
