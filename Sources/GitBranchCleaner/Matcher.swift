extension BranchMergeMatcher {
  func matches(branchDiff: BranchDiff) -> Bool {
    switch self {
    case .defaultMergeMessage:
      hasDefaultMergeMessage(branchDiff)
    case .branchNamePrefix:
      hasBranchNamePrefix(branchDiff)
    case .squashedCommitsMessage:
      hasSquashedCommitsMessage(branchDiff)
    }
  }
}

extension BranchMergeMatcher {
  private func hasDefaultMergeMessage(_ branchDiff: BranchDiff) -> Bool {
    let mergeMessage = "Merge branch '" + branchDiff.base.branch.name + "'"
    return branchDiff.target.commits.contains { commit in commit.summary == mergeMessage }
  }
}

extension BranchMergeMatcher {
  private func hasBranchNamePrefix(_ branchDiff: BranchDiff) -> Bool {
    let prefix = extractPrefix(branchName: branchDiff.base.branch.name).lowercased()

    if prefix.isEmpty {
      return false
    }

    return branchDiff.target.commits
      .map { commit in commit.summary.lowercased() }
      .contains { summary in summary.starts(with: prefix) }
  }

  private func extractPrefix(branchName: String) -> String {
    let prefixRegex = /(?:.*\/)?(.+)/
    let matches = branchName.matches(of: prefixRegex)

    guard let match = matches.first else {
      return ""
    }
    let (_, prefix) = match.output
    return String(prefix)
  }
}

extension BranchMergeMatcher {
  private func hasSquashedCommitsMessage(_ branchDiff: BranchDiff) -> Bool {
    let commits = branchDiff.base.commits
    return if commits.isEmpty {
      false
    } else if let commit = commits.single {
      hasSingleCommitMergedInTarget(commit: commit, branchDiff: branchDiff)
    } else {
      hasManyCommitsMergedInTarget(commits: commits, branchDiff: branchDiff)
    }
  }

  private func hasSingleCommitMergedInTarget(commit: Commit, branchDiff: BranchDiff) -> Bool {
    branchDiff.target.commits.map(\.summary).contains(commit.summary)
  }

  private func hasManyCommitsMergedInTarget(commits: [Commit], branchDiff: BranchDiff) -> Bool {
    let baseMergeCommitDescription = commits.map { commit in "  * \(commit.summary)" }
      .joined(separator: "\n\n")
    let targetCommitDescriptions = branchDiff.target.commits.compactMap(\.description)
    return targetCommitDescriptions.contains(baseMergeCommitDescription)
  }
}
