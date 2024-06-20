import git_branch_cleaner/types.{
  type Branch, type BranchType, type Commit, type GitError, Branch, BranchLog,
  Commit, CommitLog, GitParsingError, Local, Remote,
}
import gleam/list
import gleam/option.{Some}
import gleam/regex.{type Regex, Match}
import gleam/result
import gleam/string

pub fn parse_branch_log(
  branch_log: String,
  branch_type: BranchType,
) -> List(Result(Branch, GitError)) {
  let assert Ok(branch_regex) =
    regex.from_string(case branch_type {
      Local -> "^(?:\\*| ) (.+)$"
      Remote -> "^  (?:.+?\\/)(.+)$"
    })

  branch_log
  |> string.split("\n")
  |> list.map(parse_branch_line(_, with: branch_regex))
}

pub fn parse_commits_log(commits_log: String) -> Result(List(Commit), GitError) {
  let assert Ok(commit_regex) = regex.from_string("^(\\w+) (.+)$")

  case commits_log {
    "" -> Ok([])
    _ ->
      commits_log
      |> string.split("\n")
      |> list.map(parse_commit_line(_, with: commit_regex))
      |> result.all()
  }
}

fn parse_branch_line(branch_line: String, with branch_regex: Regex) {
  let matches = regex.scan(with: branch_regex, content: branch_line)
  case matches {
    [Match(_, [Some(branch_name)])] -> Ok(Branch(name: branch_name))
    _ -> Error(GitParsingError(content: branch_line, parse_type: BranchLog))
  }
}

fn parse_commit_line(commit_line: String, with commit_regex: Regex) {
  let matches = regex.scan(with: commit_regex, content: commit_line)
  case matches {
    [Match(_, [Some(commit_hash), Some(commit_message)])] ->
      Ok(Commit(hash: commit_hash, message: commit_message))
    _ -> Error(GitParsingError(content: commit_line, parse_type: CommitLog))
  }
}
