import git_branch_cleaner/cli/commands
import git_branch_cleaner/common/input_args
import git_branch_cleaner/common/types.{
  type CliCommand, type CliCommandError, Find, Help, Remove, UnknownCommand,
  UnknownOption,
}
import gleam/io

pub fn run() {
  case get_command_from_input() {
    Ok(command) ->
      case command {
        Find -> commands.find()
        Remove -> commands.remove()
        Help -> commands.help()
      }
    Error(error) -> {
      case error {
        UnknownCommand(value) ->
          io.println("Could not find a command called \"" <> value <> "\"")
        UnknownOption(value) ->
          io.println("Could not find an option called \"" <> value <> "\"")
      }
      io.println("")
      commands.help()
    }
  }
}

fn get_command_from_input() -> Result(CliCommand, CliCommandError) {
  case input_args.all() {
    ["find", ..optional_args] -> Find |> validate_optional_args(optional_args)
    ["remove", ..optional_args] ->
      Remove |> validate_optional_args(optional_args)
    ["help", ..optional_args] -> Help |> validate_optional_args(optional_args)
    [] -> Ok(Help)
    [other, ..] -> Error(UnknownCommand(other))
  }
}

fn validate_optional_args(
  command: CliCommand,
  args: List(String),
) -> Result(CliCommand, CliCommandError) {
  case args {
    ["-v"] | [] -> Ok(command)
    [other, ..] -> Error(UnknownOption(other))
  }
}
