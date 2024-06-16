import git_branch_cleaner/finder
import gleam/io

pub fn main() {
  case finder.find_branches_to_cleanup() {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}
