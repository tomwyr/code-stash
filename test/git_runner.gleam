import git_branch_cleaner/types.{type ShellError}
import gleam/list
import gleam/option.{None, Some}
import gleam/regex.{Match}
import gleam/result
import gleam/string

pub fn run_test_git(
  local_branches local_branches: List(String),
  remote_branches remote_branches: List(String),
  log_limited log_limited: fn(String) -> List(String),
  log_diff log_diff: fn(String, String) -> List(String),
) {
  fn(args: List(String)) -> Result(String, ShellError) {
    let args_str = string.join(args, " ")
    let unexpected_command_error = #(
      -1,
      "Unexpected git command args: " <> args_str,
    )

    let command_answer = case args_str {
      "branch" ->
        Some(
          local_branches
          |> list.map(fn(branch) { "  " <> branch }),
        )
      "branch -r" ->
        Some(
          remote_branches
          |> list.map(fn(branch) { "  " <> branch }),
        )
      "log --oneline" <> _ -> {
        [
          maybe_log_limited(args_str, log_limited),
          maybe_log_diff(args_str, log_diff),
        ]
        |> list.fold(None, option.lazy_or)
      }
      _ -> None
    }

    command_answer
    |> option.to_result(unexpected_command_error)
    |> result.map(string.join(_, "\n"))
  }
}

fn maybe_log_limited(args_str: String, log_limited: fn(String) -> List(String)) {
  fn() {
    let assert Ok(log_limited_regex) =
      regex.from_string("^log --oneline (\\w+) -n \\d+$")
    let log_limited_match = regex.scan(log_limited_regex, args_str)

    case log_limited_match {
      [Match(_, [Some(branch_name)])] -> Some(log_limited(branch_name))
      _ -> None
    }
  }
}

fn maybe_log_diff(
  args_str: String,
  log_diff: fn(String, String) -> List(String),
) {
  fn() {
    let assert Ok(log_diff_regex) =
      regex.from_string("^log --oneline (\\w+)\\.\\.(\\w+)$")
    let log_diff_match = regex.scan(log_diff_regex, args_str)

    case log_diff_match {
      [Match(_, [Some(base_name), Some(target_name)])] ->
        Some(log_diff(base_name, target_name))
      _ -> None
    }
  }
}
