import git_branch_cleaner/common/logger
import git_branch_cleaner/utils/objectx
import gleam/int
import gleam/result
import gleam/string
import shellout

import git_branch_cleaner/common/types.{type GitRunner, type ShellError}

const format_arg = "--format=\"%h %s%n%w(0,2,2)%b\""

pub fn log_limited(
  of branch: String,
  limit number: Int,
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["log", format_arg, branch, "-n", int.to_string(number)])
}

pub fn log_diff(
  from base_branch: String,
  to target_branch: String,
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["log", format_arg, base_branch <> ".." <> target_branch])
}

pub fn local_branches(
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["branch"])
}

pub fn remote_branches(
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["branch", "-r"])
}

pub fn delete_branch(
  branch: String,
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["branch", "-D", branch])
}

pub fn run_git_in_shell(arguments: List(String)) {
  logger.git_command_input(arguments)

  let raw_output =
    shellout.command(
      run: "git",
      with: ["--no-pager", ..arguments],
      in: ".",
      opt: [],
    )

  raw_output
  |> result.map(string.replace(_, "\"", ""))
  |> objectx.relay(logger.git_command_output)
}
