import git_branch_cleaner/common/input_args
import git_branch_cleaner/common/types.{
  type CommandError, type GitBranchCleanerConfig,
}
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string

pub fn run_command(
  command: String,
  config config: Option(GitBranchCleanerConfig),
) {
  log(fn() {
    case config {
      Some(config) -> {
        let message =
          "Running command \""
          <> command
          <> "\" with config: "
          <> string.inspect(config)
        io.println(message)
      }
      None -> io.println("Running command \"" <> command <> "\"")
    }
  })
}

pub fn command_error(command: String, error: CommandError) {
  log(fn() {
    let message =
      "An error occured while running \""
      <> command
      <> "\" command: "
      <> string.inspect(error)
    io.println(message)
  })
}

pub fn run_git_command(arguments: List(String)) {
  log(fn() {
    let command = "git " <> string.join(arguments, " ")
    io.println("Running git command: " <> command)
  })
}

fn log(log_message: fn() -> Nil) {
  case input_args.verbose() {
    True -> {
      io.print("[debug] ")
      log_message()
    }
    False -> Nil
  }
}
