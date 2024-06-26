import git_branch_cleaner/git/commands
import git_branch_cleaner/git/parsers
import gleam/set

import gleam/result

import git_branch_cleaner/common/types.{
  type Branch, type BranchDiff, type GitError, type GitRunner, BranchDiff,
  BranchSlice, GitCommandError, Local, Remote,
}

pub fn get_local_only_branches(
  using git_runner: GitRunner,
) -> Result(List(Branch), GitError) {
  use local_branches <- result.try(get_local_branches(git_runner))
  use remote_branches <- result.try(get_remote_branches(git_runner))

  set.from_list(local_branches)
  |> set.difference(set.from_list(remote_branches))
  |> set.to_list()
  |> result.all()
}

pub fn diff_branches(
  starting_from base: Branch,
  present_in target: Branch,
  using git_runner: GitRunner,
) -> Result(BranchDiff, GitError) {
  use base_only_commits <- result.try(get_commits_diff(
    from: target,
    to: base,
    using: git_runner,
  ))
  use target_only_commits <- result.map(get_commits_diff(
    from: base,
    to: target,
    using: git_runner,
  ))

  BranchDiff(
    base: BranchSlice(branch: base, commits: base_only_commits),
    target: BranchSlice(branch: target, commits: target_only_commits),
  )
}

pub fn has_common_ancestor(
  branch branch: Branch,
  with other: Branch,
  not_deeper_than max_depth: Int,
  using git_runner: GitRunner,
) -> Result(Bool, GitError) {
  use branch_slice <- result.try(get_branch_slice(
    of: branch,
    not_deeper_than: max_depth,
    using: git_runner,
  ))
  use other_slice <- result.map(get_branch_slice(
    of: other,
    not_deeper_than: max_depth,
    using: git_runner,
  ))

  let branch_commits = set.from_list(branch_slice.commits)
  let other_commits = set.from_list(other_slice.commits)

  !set.is_disjoint(branch_commits, other_commits)
}

pub fn delete_branch(
  branch: Branch,
  using git_runner: GitRunner,
) -> Result(Nil, GitError) {
  commands.delete_branch(branch.name, using: git_runner)
  |> result.replace(Nil)
  |> result.map_error(GitCommandError)
}

fn get_branch_slice(
  of branch: Branch,
  not_deeper_than max_depth: Int,
  using git_runner: GitRunner,
) {
  use branch_log <- result.try(
    commands.log_limited(of: branch.name, limit: max_depth, using: git_runner)
    |> result.map_error(GitCommandError),
  )
  use commits <- result.map(parsers.parse_commits_log(branch_log))
  BranchSlice(branch: branch, commits: commits)
}

fn get_local_branches(git_runner: GitRunner) {
  commands.local_branches(git_runner)
  |> result.map_error(GitCommandError)
  |> result.map(parsers.parse_branch_log(_, Local))
}

fn get_remote_branches(git_runner: GitRunner) {
  commands.remote_branches(git_runner)
  |> result.map_error(GitCommandError)
  |> result.map(parsers.parse_branch_log(_, Remote))
}

fn get_commits_diff(
  from base: Branch,
  to target: Branch,
  using git_runner: GitRunner,
) {
  commands.log_diff(from: base.name, to: target.name, using: git_runner)
  |> result.map_error(GitCommandError)
  |> result.try(parsers.parse_commits_log)
}
