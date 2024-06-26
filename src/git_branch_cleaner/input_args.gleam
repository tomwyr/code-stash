import argv
import gleam/list

pub fn load() -> InputArgs {
  let args = argv.load().arguments

  InputArgs(verbose: list.contains(args, "-v"))
}

pub type InputArgs {
  InputArgs(verbose: Bool)
}
