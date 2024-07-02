import git_branch_cleaner/cli/command_parser
import git_branch_cleaner/cli/commands
import git_branch_cleaner/common/types.{
  type CliCommandError, Find, GitBranchCleanerConfig, Help, IncorrectOptionValue,
  MissingOptionValue, Remove, UnknownCommand, UnknownOption,
}
import git_branch_cleaner/core/config
import gleam/io
import gleam/option

pub fn run() {
  let config = config.default()

  case command_parser.from_input() {
    Ok(command) ->
      case command {
        Find(max_depth, ref_branch, _) -> {
          let branch_max_depth =
            option.unwrap(max_depth, config.branch_max_depth)
          let ref_branch_name =
            option.unwrap(ref_branch, config.ref_branch_name)

          commands.find(
            for: GitBranchCleanerConfig(
              ..config,
              branch_max_depth: branch_max_depth,
              ref_branch_name: ref_branch_name,
            ),
          )
        }

        Remove(max_depth, ref_branch, _) -> {
          let branch_max_depth =
            option.unwrap(max_depth, config.branch_max_depth)
          let ref_branch_name =
            option.unwrap(ref_branch, config.ref_branch_name)

          commands.remove(
            for: GitBranchCleanerConfig(
              ..config,
              branch_max_depth: branch_max_depth,
              ref_branch_name: ref_branch_name,
            ),
          )
        }

        Help -> commands.help()
      }
    Error(error) -> {
      io.println_error(get_error_message(error))
      io.println("")
      commands.help()
    }
  }
}

fn get_error_message(error: CliCommandError) {
  case error {
    UnknownCommand(command) ->
      "Could not find a command called \"" <> command <> "\""
    UnknownOption(option) ->
      "Could not find an option called \"" <> option <> "\""
    MissingOptionValue(option) ->
      "Could not find a value for the option \"" <> option <> "\""
    IncorrectOptionValue(option, value) ->
      "Found an incorrect value \""
      <> value
      <> "\" for the option \""
      <> option
      <> "\""
  }
}
