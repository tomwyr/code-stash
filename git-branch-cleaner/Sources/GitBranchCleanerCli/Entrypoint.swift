@preconcurrency import ArgumentParser
import GitBranchCleaner

@main
struct GitBranchCleanerCli: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "gbc",
    abstract: "A command-line utility for cleaning up git branches.",
    version: "0.1.0",
    subcommands: [Scan.self, Cleanup.self]
  )
}
