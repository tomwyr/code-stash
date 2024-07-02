import git_branch_cleaner/common/input_args
import git_branch_cleaner/common/types.{
  type CliCommand, type CliCommandError, Find, Help, IncorrectOptionValue,
  MissingOptionValue, Remove, UnknownCommand, UnknownOption,
}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result

pub fn from_input() -> Result(CliCommand, CliCommandError) {
  case input_args.all() {
    [command, ..other_args] -> {
      case command {
        "find" -> parse_find(other_args)
        "remove" -> parse_remove(other_args)
        "help" -> parse_help(other_args)
        other -> Error(UnknownCommand(other))
      }
    }
    [] -> Ok(Help)
  }
}

fn parse_find(args: List(String)) -> Result(CliCommand, CliCommandError) {
  use #(verbose, args_left) <- result.try(parse_verbose(in: args))
  use #(max_depth, args_left) <- result.try(parse_max_depth(in: args_left))
  use #(ref_branch, args_left) <- result.try(parse_ref_branch(in: args_left))

  let command =
    Find(verbose: verbose, max_depth: max_depth, ref_branch: ref_branch)

  assert_no_more_args(args_left) |> result.replace(command)
}

fn parse_remove(args: List(String)) -> Result(CliCommand, CliCommandError) {
  use #(verbose, args_left) <- result.try(parse_verbose(in: args))
  use #(max_depth, args_left) <- result.try(parse_max_depth(in: args_left))
  use #(ref_branch, args_left) <- result.try(parse_ref_branch(in: args_left))

  let command =
    Remove(verbose: verbose, max_depth: max_depth, ref_branch: ref_branch)

  assert_no_more_args(args_left) |> result.replace(command)
}

fn parse_verbose(in args: List(String)) {
  parse_option_flag(with_name: "--verbose", in: args)
}

fn parse_max_depth(in args: List(String)) {
  parse_option_with_number_value(with_name: "--max-depth", in: args)
}

fn parse_ref_branch(in args: List(String)) {
  parse_option_with_value(with_name: "--ref-branch", in: args)
}

fn parse_help(args: List(String)) -> Result(CliCommand, CliCommandError) {
  case args {
    [] -> Ok(Help)
    [other, ..] -> Error(UnknownOption(other))
  }
}

fn parse_option_flag(with_name option: String, in args: List(String)) {
  args
  |> list.pop(fn(arg) { arg == option })
  |> fn(result) {
    case result {
      Ok(#(_, other_args)) -> Ok(#(Some(Nil), other_args))
      Error(_) -> Ok(#(None, args))
    }
  }
}

fn parse_option_with_value(with_name option: String, in args: List(String)) {
  args
  |> list.split_while(fn(arg) { arg != option })
  |> fn(split) {
    let #(before, option_and_after) = split
    case option_and_after {
      [] -> Ok(#(None, before))
      [_] -> Error(MissingOptionValue(option))
      [_, value, ..after] -> Ok(#(Some(value), list.append(before, after)))
    }
  }
}

fn parse_option_with_number_value(
  with_name option: String,
  in args: List(String),
) {
  use #(value_option, args_left) <- result.try(parse_option_with_value(
    option,
    args,
  ))

  case value_option {
    Some(value) -> {
      case int.parse(value) {
        Ok(number) -> Ok(#(Some(number), args_left))
        Error(_) -> Error(IncorrectOptionValue(option, value))
      }
    }
    None -> Ok(#(None, args_left))
  }
}

fn assert_no_more_args(args: List(String)) {
  case args {
    [] -> Ok(Nil)
    [option, ..] -> Error(UnknownOption(option))
  }
}
