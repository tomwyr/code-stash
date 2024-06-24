import git_branch_cleaner/types.{type BranchDiff, type Commit, BranchDiff}
import gleam/list
import gleam/option
import gleam/result

pub fn is_base_merged_in_target(branch_diff: BranchDiff) -> Bool {
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
