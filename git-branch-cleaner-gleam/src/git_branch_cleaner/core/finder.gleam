import git_branch_cleaner/common/types.{
  type Branch, type GitBranchCleanerConfig, type GitError, type GitRunner,
  Branch, GitBranchCleanerConfig,
}
import git_branch_cleaner/common/utils
import git_branch_cleaner/core/matcher
import git_branch_cleaner/git/git
import gleam/list
import gleam/result

pub fn find_branches_to_cleanup(
  for config: GitBranchCleanerConfig,
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
  |> list.filter(keeping: matcher.is_base_merged_in_target(
    of: _,
    matching: config,
  ))
  |> list.map(fn(diff) { diff.base.branch })
}

fn diff_branches_against_ref(
  local_branches: List(Branch),
  for config: GitBranchCleanerConfig,
  using git_runner: GitRunner,
) {
  let max_depth = config.branch_max_depth
  let ref_branch = Branch(config.ref_branch_name)

  use ref_sub_branches <- result.try(
    local_branches
    |> list.filter(fn(branch) { branch != ref_branch })
    |> utils.try_filter(git.has_common_ancestor(
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
