import git_branch_cleaner/common/types.{
  type BranchCleanerConfig, BranchCleanerConfig, BranchNamePrefix,
  DefaultMergeMessage, Local, SquashAndMerge, SquashedCommitsMessage,
}

pub fn default() -> BranchCleanerConfig {
  BranchCleanerConfig(
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
