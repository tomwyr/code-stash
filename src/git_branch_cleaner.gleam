import git/commands as git
import gleam/io
import gleam/list
import gleam/regex.{Match}
import gleam/result
import gleam/set
import gleam/string

pub fn main() {
  case find_branches_to_cleanup() {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}

fn get_lookup_max_depth() {
  25
}

fn get_reference_branch() {
  Branch(name: "master")
}

fn find_branches_to_cleanup() {
  let ref_branch = get_reference_branch()
  let max_depth = get_lookup_max_depth()

  use local_branches <- result.try(get_local_only_branches())
  use ref_local_sub_branches <- result.try(
    local_branches
    |> filter_branches_sharing_ancestor(
      with: ref_branch,
      not_deeper_than: max_depth,
    ),
  )

  use branch_diffs <- result.map(
    ref_local_sub_branches
    |> list.map(diff_branches(starting_from: _, present_in: ref_branch))
    |> result.all(),
  )

  branch_diffs
  |> list.filter(keeping: is_base_merged_in_target)
  |> list.map(fn(diff) { diff.base.branch })
}

fn get_local_only_branches() {
  use local_branches <- result.try(
    git.local_branches()
    |> result.map_error(GitCommandError)
    |> result.map(parse_branch_log(_, Local)),
  )
  use remote_branches <- result.try(
    git.remote_branches()
    |> result.map_error(GitCommandError)
    |> result.map(parse_branch_log(_, Remote)),
  )

  set.from_list(local_branches)
  |> set.difference(set.from_list(remote_branches))
  |> set.to_list()
  |> result.all()
}

fn filter_branches_sharing_ancestor(
  branches: List(Branch),
  with base: Branch,
  not_deeper_than max_depth: Int,
) {
  let slice_for_branch = fn(branch: Branch) {
    use branch_log <- result.try(
      git.log_limited(of: branch.name, limit: max_depth)
      |> result.map_error(GitCommandError),
    )
    use commits <- result.map(parse_commits_log(branch_log))
    BranchSlice(branch: branch, commits: commits)
  }

  use branch_slices <- result.try(
    branches
    |> list.map(slice_for_branch)
    |> result.all(),
  )
  use base_slice <- result.map(slice_for_branch(base))

  let base_commits = set.from_list(base_slice.commits)
  let intersects_base = fn(slice: BranchSlice) {
    slice.commits
    |> list.any(set.contains(in: base_commits, this: _))
  }

  branch_slices
  |> list.filter(intersects_base)
  |> list.map(fn(slice) { slice.branch })
}

fn parse_branch_log(branch_log: String, branch_type: BranchType) {
  let pattern = case branch_type {
    Local -> "^(?:\\*| ) (.+)$"
    Remote -> "^  (?:.+?\\/)(.+)$"
  }
  let assert Ok(branch_regex) = regex.from_string(pattern)

  let parse_branch_line = fn(branch_line: String) {
    let matches = regex.scan(with: branch_regex, content: branch_line)
    case matches {
      [Match(content: branch_name, ..)] -> Ok(Branch(name: branch_name))
      _ -> Error(GitParsingError(content: branch_line, parse_type: BranchLog))
    }
  }

  branch_log
  |> string.split("\n")
  |> list.map(parse_branch_line)
}

fn diff_branches(starting_from base: Branch, present_in target: Branch) {
  use base_only_commits <- result.try(
    git.log_diff(from: target.name, to: base.name)
    |> result.map_error(GitCommandError)
    |> result.try(parse_commits_log),
  )
  use target_only_commits <- result.map(
    git.log_diff(from: base.name, to: target.name)
    |> result.map_error(GitCommandError)
    |> result.try(parse_commits_log),
  )

  BranchDiff(
    base: BranchSlice(branch: base, commits: base_only_commits),
    target: BranchSlice(branch: target, commits: target_only_commits),
  )
}

fn parse_commits_log(commits_log: String) {
  let assert Ok(commit_regex) =
    regex.from_string("^(\\w+) (?:\\(.+?\\) )?(.+)$")

  let parse_log_line = fn(commit_line: String) {
    let matches = regex.scan(with: commit_regex, content: commit_line)
    case matches {
      [Match(content: commit_hash, ..), Match(content: commit_message, ..), ..] ->
        Ok(Commit(hash: commit_hash, message: commit_message))
      _ -> Error(GitParsingError(content: commit_line, parse_type: CommitLog))
    }
  }

  commits_log
  |> string.split("\n")
  |> list.map(parse_log_line)
  |> result.all()
}

fn is_base_merged_in_target(branch_diff: BranchDiff) {
  let merge_commit_message =
    branch_diff.base.commits
    |> list.map(fn(commit) { commit.message })
    |> list.fold("", fn(acc, message) { acc <> "\n\n" <> message })

  branch_diff.target.commits
  |> list.any(fn(commit) { commit.message == merge_commit_message })
}

type Commit {
  Commit(hash: String, message: String)
}

type Branch {
  Branch(name: String)
}

type BranchSlice {
  BranchSlice(branch: Branch, commits: List(Commit))
}

type BranchDiff {
  BranchDiff(base: BranchSlice, target: BranchSlice)
}

type BranchType {
  Local
  Remote
}

type CleanupBranchesError {
  GitCommandError(error: git.ShellError)
  GitParsingError(content: String, parse_type: GitParseType)
}

type GitParseType {
  CommitLog
  BranchLog
}
