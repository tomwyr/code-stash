import gleam/int
import shellout

import git_branch_cleaner/types.{type GitRunner, type ShellError}

pub fn log_limited(
  of branch: String,
  limit number: Int,
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["log", "--oneline", branch, "-n", int.to_string(number)])
}

pub fn log_diff(
  from base_branch: String,
  to target_branch: String,
  using run_git_with: GitRunner,
) -> Result(String, ShellError) {
  run_git_with(["log", "--oneline", base_branch <> ".." <> target_branch])
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

pub fn run_git_in_shell(arguments: List(String)) {
  shellout.command(run: "git", with: arguments, in: ".", opt: [])
}
