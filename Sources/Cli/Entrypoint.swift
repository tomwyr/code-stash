@preconcurrency import ArgumentParser

@main
struct GitBranchCleanerCli: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "gbc",
    abstract: "A command-line utility for cleaning up git branches.",
    version: "0.0.1",
    subcommands: [Find.self, Remove.self]
  )
}
