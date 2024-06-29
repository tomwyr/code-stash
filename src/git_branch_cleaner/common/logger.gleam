import git_branch_cleaner/common/input_args
import git_branch_cleaner/common/types.{type ShellError}
import gleam/int
import gleam/io
import gleam/string

pub fn git_command_input(arguments: List(String)) {
  log(fn() {
    let formatted_args = string.join(arguments, " ")

    io.println("Running git command:")
    io.println("git " <> formatted_args)
    io.println("")
  })
}

pub fn git_command_output(output: Result(String, ShellError)) {
  log(fn() {
    case output {
      Ok(_) -> Nil
      Error(value) -> {
        let #(code, message) = value
        let message =
          "Git error occured: " <> message <> "(" <> int.to_string(code) <> ")"
        io.println(message)
      }
    }
    Nil
  })
}

fn log(log_message: fn() -> Nil) {
  case input_args.verbose() {
    True -> log_message()
    False -> Nil
  }
}
