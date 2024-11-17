class GitParser {
  func parseBranchLog(data: String, branchType: BranchType) throws(GitError) -> [Branch] {
    try data.split(separator: "\n").map { line throws(GitError) in
      try parseBranchLine(data: String(line), branchType: branchType)
    }
  }

  func parseCommitsLog(data: String) throws(GitError) -> [Commit] {
    if data.isEmpty {
      return []
    }

    let regex = /(\w+) (.+)((?:\n+  .+)+)?/
    return data.matches(of: regex).map(\.output).map(parseCommitMatch)
  }

  private func parseBranchLine(data: String, branchType: BranchType) throws(GitError) -> Branch {
    let regex =
      switch branchType {
      case .local:
        /^(?:\*| ) (.+)$/
      case .remote:
        /^  (?:.+?\/)(.+)$/
      }
    let matches = data.matches(of: regex)

    if let match = matches.single {
      let (_, name) = match.output
      return Branch(name: String(name))
    } else {
      throw .parser(content: data, parse_type: .branchLog)
    }
  }

  private func parseCommitMatch(match: CommitMatch) -> Commit {
    let (_, hash, summary, rest) = match

    let description: String? =
      if let rest, rest.starts(with: "\n") {
        String(rest.trimmingPrefix("\n"))
      } else {
        nil
      }

    return Commit(hash: String(hash), summary: String(summary), description: description)
  }
}

public enum GitParseType: Sendable {
  case commitLog, branchLog
}

typealias CommitMatch = (Substring, Substring, Substring, Substring?)
