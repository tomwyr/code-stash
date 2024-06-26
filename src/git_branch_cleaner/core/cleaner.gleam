import git_branch_cleaner/common/types.{
  type Branch, type BranchCleanerConfig, type CleanupBranchesError,
  type GitRunner, BranchCleanerConfig, BranchesNotFound, BranchesNotRemoved,
  Local, RemoveGitError, SquashAndMerge,
}
import git_branch_cleaner/git/git
import git_branch_cleaner/utils/resultx
import gleam/list
import gleam/result
import gleam/set

pub fn get_default_config() -> BranchCleanerConfig {
  BranchCleanerConfig(
    branch_max_depth: 25,
    ref_branch_name: "master",
    ref_branch_type: Local,
    merge_strategy: SquashAndMerge,
  )
}

pub fn cleanup_branches(
  branches: List(Branch),
  using git_runner: GitRunner,
) -> Result(Nil, CleanupBranchesError) {
  validate_branches_exist(branches, using: git_runner)
  |> resultx.and(remove_branches(branches, using: git_runner))
  |> resultx.and(validate_branches_removed(branches, using: git_runner))
  |> result.replace(Nil)
}

fn validate_branches_exist(
  branches: List(Branch),
  using git_runner: GitRunner,
) -> Result(Nil, CleanupBranchesError) {
  use local_branches <- result.try(
    git.get_local_only_branches(git_runner)
    |> result.map_error(RemoveGitError),
  )

  let unknown_branches =
    set.from_list(branches)
    |> set.difference(set.from_list(local_branches))
    |> set.to_list()

  case unknown_branches {
    [] -> Ok(Nil)
    branches -> Error(BranchesNotFound(branches: branches))
  }
}

fn remove_branches(branches: List(Branch), using git_runner: GitRunner) {
  branches
  |> list.map(git.delete_branch(_, using: git_runner))
  |> result.all()
  |> result.replace(Nil)
  |> result.map_error(RemoveGitError)
}

fn validate_branches_removed(
  branches: List(Branch),
  using git_runner: GitRunner,
) {
  use local_branches <- result.try(
    git.get_local_only_branches(git_runner)
    |> result.map_error(RemoveGitError),
  )

  let not_removed_branches =
    set.from_list(branches)
    |> set.intersection(set.from_list(local_branches))
    |> set.to_list()

  case not_removed_branches {
    [] -> Ok(Nil)
    branches -> Error(BranchesNotRemoved(branches: branches))
  }
}
