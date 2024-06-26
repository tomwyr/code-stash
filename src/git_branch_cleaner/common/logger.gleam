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
    let formatted_output = case output {
      Ok(value) -> value
      Error(value) -> {
        let #(code, message) = value
        "Git error code " <> int.to_string(code) <> ": " <> message
      }
    }

    io.println("Which outputted:")
    io.println(formatted_output)
  })
}

fn log(log_message: fn() -> Nil) {
  let args = input_args.load()
  case args.verbose {
    True -> log_message()
    False -> Nil
  }
}
