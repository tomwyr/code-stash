import gleam/string

pub fn run_test_git(
  local_branches local_branches: List(String),
  remote_branches remote_branches: List(String),
  log_limited log_limited: List(String),
) {
  fn(args: List(String)) {
    let args_str = string.join(args, " ")
    case args_str {
      "branch" -> Ok(string.join(local_branches, "\n"))
      "branch -r" -> Ok(string.join(remote_branches, "\n"))
      "log --oneline master -n 25" -> Ok(string.join(log_limited, "\n"))
      _ -> Error(#(-1, "Unexpected git command args: " <> args_str))
    }
  }
}
