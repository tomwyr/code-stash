import git_branch_cleaner/common/types.{FindError, RemoveError}
import git_branch_cleaner/core/cleaner
import git_branch_cleaner/core/finder
import git_branch_cleaner/git/commands
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn find() {
  let result =
    finder.find_branches_to_cleanup(
      for: cleaner.get_default_config(),
      using: commands.run_git_in_shell,
    )

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

    Error(_) ->
      io.println_error("An error occured while finding branches to clean up.")
  }
}

pub fn remove() {
  let result = {
    use branches <- result.try(
      finder.find_branches_to_cleanup(
        for: cleaner.get_default_config(),
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
    _ -> io.print_error("An error occured while removing branches.")
  }
}

pub fn help() {
  let message =
    "
A command-line utility for cleaning up git branches.

Usage: gbc <command> <options>

Available commands:
  find      Scan cwd for local git branches that have been merged into ref branch and can be safely removed. This command will NOT delete any branches.
  remove    Remove cwd local git branches that have been merged into ref branch. This command WILL delete found branches.
  help      Show this guide information.

Available global options:
  -v        Show additional output for command.
"

  let trimme_message =
    message |> string.slice(at_index: 1, length: string.length(message) - 2)

  io.println(trimme_message)
}
