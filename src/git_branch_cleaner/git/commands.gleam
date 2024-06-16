import gleam/int
import shellout

import git_branch_cleaner/types.{type ShellError}

pub fn log_limited(
  of branch: String,
  limit number: Int,
) -> Result(String, ShellError) {
  let args = ["log", "--oneline", branch, "-n", int.to_string(number)]
  exec_git(with: args)
}

pub fn log_diff(
  from base_branch: String,
  to target_branch: String,
) -> Result(String, ShellError) {
  exec_git(with: ["log", "--oneline", base_branch, target_branch])
}

pub fn local_branches() -> Result(String, ShellError) {
  exec_git(with: ["branch"])
}

pub fn remote_branches() -> Result(String, ShellError) {
  exec_git(with: ["branch", "-r"])
}

fn exec_git(with arguments: List(String)) {
  shellout.command(run: "git", with: arguments, in: ".", opt: [])
}
