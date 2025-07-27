import git_branch_cleaner/common/types.{
  type GitBranchCleanerConfig, BranchNamePrefix, DefaultMergeMessage,
  GitBranchCleanerConfig, Local, SquashAndMerge, SquashedCommitsMessage,
}

pub fn default() -> GitBranchCleanerConfig {
  GitBranchCleanerConfig(
    branch_max_depth: 25,
    ref_branch_name: "master",
    ref_branch_type: Local,
    merge_strategy: SquashAndMerge,
    branch_merge_matchers: [
      DefaultMergeMessage,
      BranchNamePrefix,
      SquashedCommitsMessage,
    ],
  )
}
