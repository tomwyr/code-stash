import git_branch_cleaner/git/git
import git_branch_cleaner/merge_detector
import git_branch_cleaner/types.{
  type Branch, type BranchCleanerConfig, type GitError, type GitRunner, Branch,
  BranchCleanerConfig,
}
import git_branch_cleaner/utils/listx
import gleam/list
import gleam/result

pub fn find_branches_to_cleanup(
  for config: BranchCleanerConfig,
  using git_runner: GitRunner,
) -> Result(List(Branch), GitError) {
  use local_branches <- result.try(git.get_local_only_branches(
    using: git_runner,
  ))
  use local_to_ref_branch_diffs <- result.map(diff_branches_against_ref(
    local_branches,
    for: config,
    using: git_runner,
  ))

  local_to_ref_branch_diffs
  |> list.filter(keeping: merge_detector.is_base_merged_in_target)
  |> list.map(fn(diff) { diff.base.branch })
}

fn diff_branches_against_ref(
  local_branches: List(Branch),
  for config: BranchCleanerConfig,
  using git_runner: GitRunner,
) {
  let max_depth = config.branch_max_depth
  let ref_branch = Branch(config.ref_branch_name)

  use ref_sub_branches <- result.try(
    local_branches
    |> list.filter(fn(branch) { branch != ref_branch })
    |> listx.try_filter(git.has_common_ancestor(
      branch: _,
      with: ref_branch,
      not_deeper_than: max_depth,
      using: git_runner,
    )),
  )

  ref_sub_branches
  |> list.map(git.diff_branches(
    starting_from: _,
    present_in: ref_branch,
    using: git_runner,
  ))
  |> result.all()
}
