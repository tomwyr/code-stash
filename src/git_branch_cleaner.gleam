import git_branch_cleaner/finder
import git_branch_cleaner/git/commands.{run_git_in_shell}
import gleam/io

pub fn main() {
  let result =
    finder.find_branches_to_cleanup(
      matching: finder.get_default_config(),
      using: run_git_in_shell,
    )

  case result {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}
