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
