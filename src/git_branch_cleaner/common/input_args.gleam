import argv
import git_branch_cleaner/common/types.{type InputArgs, InputArgs}
import gleam/list

pub fn raw() -> List(String) {
  argv.load().arguments
}

pub fn load() -> InputArgs {
  let args = argv.load().arguments

  InputArgs(verbose: list.contains(args, "-v"))
}
