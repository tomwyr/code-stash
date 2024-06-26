import git_branch_cleaner/cli/commands
import git_branch_cleaner/common/input_args
import gleam/io

pub fn run() {
  case input_args.raw() {
    ["find"] -> commands.find()
    ["remove"] -> commands.remove()
    ["help"] | [] -> commands.help()
    [other, ..] -> {
      io.println("Could not find a command called \"" <> other <> "\"")
      commands.help()
    }
  }
}
