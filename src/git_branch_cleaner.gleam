import git_branch_cleaner/core/branch_finder
import git_branch_cleaner/git/commands.{run_git_in_shell}
import git_branch_cleaner/types.{
  type BranchCleanerConfig, BranchCleanerConfig, Local, SquashAndMerge,
}
import gleam/io

pub fn main() {
  let result =
    branch_finder.find_branches_to_cleanup(
      for: get_default_config(),
      using: run_git_in_shell,
    )

  case result {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}

pub fn get_default_config() -> BranchCleanerConfig {
  BranchCleanerConfig(
    branch_max_depth: 25,
    ref_branch_name: "master",
    ref_branch_type: Local,
    merge_strategy: SquashAndMerge,
  )
}
