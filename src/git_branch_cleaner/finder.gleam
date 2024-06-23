import git_branch_cleaner/git/git
import git_branch_cleaner/types.{
  type Branch, type BranchDiff, type Commit, type GitError, type GitRunner,
  Branch, BranchDiff,
}
import git_branch_cleaner/utils/listx
import gleam/list
import gleam/option
import gleam/result

pub fn find_branches_to_cleanup(
  using git_runner: GitRunner,
) -> Result(List(Branch), GitError) {
  use local_branches <- result.try(git.get_local_only_branches(
    using: git_runner,
  ))
  use local_to_ref_branch_diffs <- result.map(diff_branches_against_ref(
    local_branches,
    using: git_runner,
  ))

  local_to_ref_branch_diffs
  |> list.filter(keeping: is_base_merged_in_target)
  |> list.map(fn(diff) { diff.base.branch })
}

fn diff_branches_against_ref(
  local_branches: List(Branch),
  using git_runner: GitRunner,
) {
  let ref_branch = get_reference_branch()
  let max_depth = get_lookup_max_depth()

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

fn is_base_merged_in_target(branch_diff: BranchDiff) -> Bool {
  case branch_diff.base.commits {
    [] -> False
    [single] -> has_single_commit_merged_in_target(single, branch_diff)
    many -> has_many_commits_merged_in_target(many, branch_diff)
  }
}

fn has_single_commit_merged_in_target(commit: Commit, branch_diff: BranchDiff) {
  branch_diff.target.commits
  |> list.map(fn(commit) { commit.summary })
  |> list.contains(commit.summary)
}

fn has_many_commits_merged_in_target(
  commits: List(Commit),
  branch_diff: BranchDiff,
) {
  let base_merge_commit_description =
    commits
    |> list.map(fn(commit) { "  * " <> commit.summary })
    |> list.reduce(fn(prev, next) { prev <> "\n\n" <> next })
    |> result.unwrap("")

  let target_commit_descriptions =
    branch_diff.target.commits
    |> list.map(fn(commit) { commit.description })
    |> option.values()

  target_commit_descriptions
  |> list.contains(base_merge_commit_description)
}

fn get_lookup_max_depth() {
  25
}

fn get_reference_branch() {
  Branch(name: "master")
}
