import git_branch_cleaner/git/commands
import git_branch_cleaner/git/parsers
import gleam/set

import gleam/result

import git_branch_cleaner/types.{
  type Branch, type BranchDiff, type GitError, BranchDiff, BranchSlice,
  GitCommandError, Local, Remote,
}

pub fn get_local_only_branches() -> Result(List(Branch), GitError) {
  use local_branches <- result.try(get_local_branches())
  use remote_branches <- result.try(get_remote_branches())

  set.from_list(local_branches)
  |> set.difference(set.from_list(remote_branches))
  |> set.to_list()
  |> result.all()
}

pub fn diff_branches(
  starting_from base: Branch,
  present_in target: Branch,
) -> Result(BranchDiff, GitError) {
  use base_only_commits <- result.try(get_commits_diff(from: target, to: base))
  use target_only_commits <- result.map(get_commits_diff(from: base, to: target))

  BranchDiff(
    base: BranchSlice(branch: base, commits: base_only_commits),
    target: BranchSlice(branch: target, commits: target_only_commits),
  )
}

pub fn has_common_ancestor(
  branch branch: Branch,
  with other: Branch,
  not_deeper_than max_depth: Int,
) -> Result(Bool, GitError) {
  use branch_slice <- result.try(get_branch_slice(
    of: branch,
    not_deeper_than: max_depth,
  ))
  use other_slice <- result.map(get_branch_slice(
    of: other,
    not_deeper_than: max_depth,
  ))

  let branch_commits = set.from_list(branch_slice.commits)
  let other_commits = set.from_list(other_slice.commits)

  !set.is_disjoint(branch_commits, other_commits)
}

fn get_branch_slice(of branch: Branch, not_deeper_than max_depth: Int) {
  use branch_log <- result.try(
    commands.log_limited(of: branch.name, limit: max_depth)
    |> result.map_error(GitCommandError),
  )
  use commits <- result.map(parsers.parse_commits_log(branch_log))
  BranchSlice(branch: branch, commits: commits)
}

fn get_local_branches() {
  commands.local_branches()
  |> result.map_error(GitCommandError)
  |> result.map(parsers.parse_branch_log(_, Local))
}

fn get_remote_branches() {
  commands.remote_branches()
  |> result.map_error(GitCommandError)
  |> result.map(parsers.parse_branch_log(_, Remote))
}

fn get_commits_diff(from base: Branch, to target: Branch) {
  commands.log_diff(from: target.name, to: base.name)
  |> result.map_error(GitCommandError)
  |> result.try(parsers.parse_commits_log)
}
