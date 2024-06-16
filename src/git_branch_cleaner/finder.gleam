import git_branch_cleaner/git/git
import git_branch_cleaner/types.{
  type Branch, type BranchDiff, type GitError, type GitRunner, Branch,
  BranchDiff,
}
import git_branch_cleaner/utils/listx
import gleam/list
import gleam/result

pub fn find_branches_to_cleanup(
  git_runner git_runner: GitRunner,
) -> Result(List(Branch), GitError) {
  use local_branches <- result.try(git.get_local_only_branches(
    using: git_runner,
  ))
  use local_to_ref_branch_diffs <- result.map(diff_branches_against_ref(
    local_branches,
    git_runner,
  ))

  local_to_ref_branch_diffs
  |> list.filter(keeping: is_base_merged_in_target)
  |> list.map(fn(diff) { diff.base.branch })
}

fn diff_branches_against_ref(
  local_branches: List(Branch),
  git_runner: GitRunner,
) {
  let ref_branch = get_reference_branch()
  let max_depth = get_lookup_max_depth()

  use ref_sub_branches <- result.try(
    local_branches
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

fn is_base_merged_in_target(branch_diff: BranchDiff) {
  let merge_commit_message =
    branch_diff.base.commits
    |> list.map(fn(commit) { commit.message })
    |> list.fold("", fn(acc, message) { acc <> "\n\n" <> message })

  branch_diff.target.commits
  |> list.any(fn(commit) { commit.message == merge_commit_message })
}

fn get_lookup_max_depth() {
  25
}

fn get_reference_branch() {
  Branch(name: "master")
}
