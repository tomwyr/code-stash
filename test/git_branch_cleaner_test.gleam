import git_branch_cleaner/finder
import git_branch_cleaner/types.{type ShellError}
import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn runs_finder_test() {
  finder.find_branches_to_cleanup(git_runner: do_nothing)
}

fn do_nothing(_: List(String)) -> Result(String, ShellError) {
  Ok("")
}
