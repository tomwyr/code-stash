import git_branch_cleaner/common/logger
import git_branch_cleaner/common/types.{
  type CommandError, type GitBranchCleanerConfig, FindError, RemoveError,
}
import git_branch_cleaner/core/cleaner
import git_branch_cleaner/core/finder
import git_branch_cleaner/git/commands
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn find(for config: GitBranchCleanerConfig) {
  logger.run_command("find", config: Some(config))

  let result =
    finder.find_branches_to_cleanup(
      for: config,
      using: commands.run_git_in_shell,
    )
    |> result.map_error(FindError)

  case result {
    Ok([]) -> io.println("No branches that can be cleaned up could be found.")

    Ok(branches) -> {
      let formatted_branches =
        branches
        |> list.map(fn(branch) { branch.name })
        |> string.join(", ")

      io.println("Branches that can be cleaned up:")
      io.println(formatted_branches)
    }

    Error(error) ->
      print_command_error(
        command: "find",
        cause: error,
        message: "An error occured while finding branches to clean up.",
      )
  }
}

pub fn remove(for config: GitBranchCleanerConfig) {
  logger.run_command("remove", config: Some(config))

  let result = {
    use branches <- result.try(
      finder.find_branches_to_cleanup(
        for: config,
        using: commands.run_git_in_shell,
      )
      |> result.map_error(FindError),
    )

    use _ <- result.map(
      cleaner.cleanup_branches(branches, using: commands.run_git_in_shell)
      |> result.map_error(RemoveError),
    )

    branches
  }

  case result {
    Ok(branches) -> {
      let formatted_branches =
        branches
        |> list.map(fn(branch) { branch.name })
        |> string.join(", ")

      io.println("Cleanup successful. Removed the following branches:")
      io.println(formatted_branches)
    }
    Error(error) ->
      print_command_error(
        command: "remove",
        cause: error,
        message: "An error occured while removing branches.",
      )
  }
}

pub fn help() {
  logger.run_command("remove", config: None)

  let message =
    "
A command-line utility for cleaning up git branches.

Usage: gbc <command> <options>

Available commands:
  find        Scan cwd for local git branches that have been merged into ref branch and can be safely removed. This command will NOT delete any branches.
  remove      Remove cwd local git branches that have been merged into ref branch. This command WILL delete found branches.
  help        Show this guide information.

Available command options:
  --max-depth <number>    Number of commits of the ref branch history to check for common history between cleaned up branches and the ref branch. Defaults to 25.
                          Applies in: find, remove.
  --ref-branch <branch>   Name of the branch that cleaned up branches are merged into. Defaults to \"master\".
                          Applies in: find, remove.

Available global options:
  --verbose   Show additional output for command.

If you're not sure how to use this tool, or if you'd like to suggest a change or improvement, your feedback is appreciated.
Please visit https://github.com/tomwyr/git_branch_cleaner/issues and open an issue or search for existing similar issues.
"
    |> string.trim

  io.println(message)
}

fn print_command_error(
  command command: String,
  cause error: CommandError,
  message error_message: String,
) {
  logger.command_error(command, error)

  let footer =
    "
This is most likely an error that needs to be fixed.
Please visit https://github.com/tomwyr/git_branch_cleaner/issues and open an issue or search for existing similar issues.
"
    |> string.trim

  let message = error_message <> "\n\n" <> footer

  io.println_error(message)
}
