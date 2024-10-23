import ShellOut

struct Branch: Hashable {
  let name: String
}

enum BranchType {
  case local, remote
}

struct Commit: Hashable {
  let hash: String
  let summary: String
  let description: String?
}

struct BranchSlice {
  let branch: Branch
  let commits: [Commit]
}

struct BranchDiff {
  let base: BranchSlice
  let target: BranchSlice
}

enum GitParseType {
  case commitLog, branchLog
}

enum GitError: Error {
  case command(error: ShellOutError)
  case parser(content: String, parse_type: GitParseType)
  case unknown(cause: Error)
}
