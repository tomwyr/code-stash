import gleam/option.{type Option}

pub type Branch {
  Branch(name: String)
}

pub type BranchSlice {
  BranchSlice(branch: Branch, commits: List(Commit))
}

pub type BranchDiff {
  BranchDiff(base: BranchSlice, target: BranchSlice)
}

pub type BranchType {
  Local
  Remote
}

pub type Commit {
  Commit(hash: String, summary: String, description: Option(String))
}

pub type GitRunner =
  fn(List(String)) -> Result(String, ShellError)

pub type GitError {
  GitCommandError(error: ShellError)
  GitParsingError(content: String, parse_type: GitParseType)
}

pub type GitParseType {
  CommitLog
  BranchLog
}

pub type ShellError =
  #(Int, String)
