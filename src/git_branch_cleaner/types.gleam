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
  Commit(hash: String, message: String)
}

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
