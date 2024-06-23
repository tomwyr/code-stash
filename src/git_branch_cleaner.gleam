import git_branch_cleaner/finder
import git_branch_cleaner/git/commands.{run_git_in_shell}
import gleam/io

pub fn main() {
  case finder.find_branches_to_cleanup(using: run_git_in_shell) {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}
