import git/commands as git
import gleam/io
import gleam/list
import gleam/regex.{Match}
import gleam/result
import gleam/set
import gleam/string
import utils

pub fn main() {
  case find_branches_to_cleanup() {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}

fn find_branches_to_cleanup() {
  let ref_branch = get_reference_branch()
  let max_depth = get_lookup_max_depth()

  use local_branches <- result.map(get_local_only_branches())

  let local_branches_from_ref =
    filter_branches_with_common_base(
      from: local_branches,
      branching_off: ref_branch,
      not_deeper_than: max_depth,
    )

  use branch_diffs <- result.map(
    local_branches_from_ref
    |> list.map(diff_branches(starting_from: _, present_in: ref_branch))
    |> utils.group_results(),
  )

  branch_diffs
  |> list.filter(keeping: base_merged_in_target)
  |> list.map(fn(diff) { diff.base.branch })
}

fn get_lookup_max_depth() -> Int {
  25
}

fn get_reference_branch() -> Branch {
  Branch(name: "master")
}

fn get_local_only_branches() {
  use local_branches <- result.try(
    git.local_branches()
    |> result.map(parse_branch_log(_, Local)),
  )
  use remote_branches <- result.map(
    git.remote_branches()
    |> result.map(parse_branch_log(_, Remote)),
  )

  set.from_list(local_branches)
  |> set.difference(set.from_list(remote_branches))
  |> set.to_list()
}

fn filter_branches_with_common_base(
  from branches: List(Branch),
  branching_off base: Branch,
  not_deeper_than max_depth: Int,
) {
  todo
}

fn parse_branch_log(branch_log: String, branch_type: BranchType) {
  let pattern = case branch_type {
    Local -> "^(?:\\*| ) (.+)$"
    Remote -> "^  (?:.+?\\/)(.+)$"
  }
  let assert Ok(commit_regex) = regex.from_string(pattern)

  let scan_result_to_branch = fn(matches: List(regex.Match)) {
    let assert [Match(content: branch_name, ..)] = matches
    Branch(name: branch_name)
  }

  branch_log
  |> string.split("\n")
  |> list.map(regex.scan(with: commit_regex, content: _))
  |> list.map(scan_result_to_branch)
}

fn diff_branches(starting_from base: Branch, present_in target: Branch) {
  use base_only_commits <- result.try(
    git.log_diff(from: target.name, to: base.name)
    |> result.map(parse_commits),
  )
  use target_only_commits <- result.map(
    git.log_diff(from: base.name, to: target.name)
    |> result.map(parse_commits),
  )

  BranchDiff(
    base: BranchSlice(branch: base, commits: base_only_commits),
    target: BranchSlice(branch: target, commits: target_only_commits),
  )
}

fn parse_commits(from commits_log: String) -> List(Commit) {
  let assert Ok(commit_regex) = regex.from_string("^(.+?) (.+)$")

  let scan_result_to_commit = fn(matches: List(regex.Match)) {
    let assert [
      Match(content: commit_hash, ..),
      Match(content: commit_message, ..),
      ..
    ] = matches
    Commit(hash: commit_hash, message: commit_message)
  }

  commits_log
  |> string.split("\n")
  |> list.map(regex.scan(with: commit_regex, content: _))
  |> list.map(scan_result_to_commit)
}

fn base_merged_in_target(branch_diff: BranchDiff) -> Bool {
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

pub type Branch {
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
