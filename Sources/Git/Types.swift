import ShellOut

struct Branch: Hashable {
  let name: String
}

enum BranchType {
  case local, remote
}

struct BranchSlice {
  let branch: Branch
  let commits: [Commit]
}

struct BranchDiff {
  let base: BranchSlice
  let target: BranchSlice
}

struct Commit: Hashable {
  let hash: String
  let summary: String
  let description: String?
}

enum GitParseType {
  case commitLog, branchLog
}

enum GitError: Error {
  case command(ShellOutError)
  case parser(content: String, parse_type: GitParseType)
  case other(Error)
}
