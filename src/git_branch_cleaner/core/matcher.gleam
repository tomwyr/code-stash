import git_branch_cleaner/common/types.{
  type BranchCleanerConfig, type BranchDiff, type BranchMergeMatcher,
  type Commit, BranchNamePrefix, DefaultMergeMessage, SquashedCommitsMessage,
}
import git_branch_cleaner/common/utils
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn is_base_merged_in_target(
  of branch_diff: BranchDiff,
  matching config: BranchCleanerConfig,
) -> Bool {
  config.branch_merge_matchers
  |> list.map(get_matcher_function)
  |> list.any(utils.call(_, with: branch_diff))
}

fn get_matcher_function(matcher: BranchMergeMatcher) {
  case matcher {
    DefaultMergeMessage -> has_default_merge_message
    BranchNamePrefix -> has_branch_name_prefix
    SquashedCommitsMessage -> has_squashed_commits_message
  }
}

fn has_default_merge_message(branch_diff: BranchDiff) -> Bool {
  let merge_message = "Merge branch '" <> branch_diff.base.branch.name <> "'"
  branch_diff.target.commits
  |> list.any(fn(commit) { commit.summary == merge_message })
}

fn has_branch_name_prefix(branch_diff: BranchDiff) -> Bool {
  let prefix = string.lowercase(branch_diff.base.branch.name)
  branch_diff.target.commits
  |> list.map(fn(commit) { string.lowercase(commit.summary) })
  |> list.any(string.starts_with(_, prefix))
}

fn has_squashed_commits_message(branch_diff: BranchDiff) -> Bool {
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
