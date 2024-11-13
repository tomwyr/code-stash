import Testing

@testable import GitBranchCleaner

final class GitBranchCleanerTests {
  final class FindBranchesToCleanup: GitBranchCleanerSuite {
    @Test("passes config values as expected arguments to git commands")
    func passingConfig() throws {
      try testFindBranchesToCleanup(
        localBranches: """
          * ref
            feature
          """,
        log: [
          "ref": "e963c21d1 Commit 1",
          "feature": "e963c21d1 Commit 1",
        ],
        logDiff: [
          "ref..feature": "",
          "feature..ref": "",
        ],
        config: .init(
          branchMaxDepth: 7,
          refBranchName: "ref"
        ),
        expectCommands: [
          "branch",
          "branch -r",
          "log \(formatArg) feature -n 7 --",
          "log \(formatArg) ref -n 7 --",
          "log \(formatArg) ref..feature",
          "log \(formatArg) feature..ref",
        ]
      )
    }

    @Test("finds no branches when there's only ref branch in the repository")
    func onlyRefInRepo() throws {
      try testFindBranchesToCleanup(
        localBranches: """
          * main
          """,
        expect: []
      )
    }

    @Test("finds no branches when local branch is not merged into ref branch")
    func noBranchesInRef() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          e2286db93 Commit 2

          88be3f666 Commit 1

          """,
          "feature": """
          b960e0b25 Commit 3

          88be3f666 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          e2286db93 Commit 2

          """,
          "main..feature": """
          b960e0b25 Commit 3

          """,
        ],
        expect: []
      )
    }

    @Test("finds single branch when it's merged into ref branch")
    func branchInRef() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          e2286db93 Commit 2

          88be3f666 Commit 1

          """,
          "feature": """
          b960e0b25 Commit 2

          88be3f666 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          e2286db93 Commit 2

          """,
          "main..feature": """
          b960e0b25 Commit 2

          """,
        ],
        expect: ["feature"]
      )
    }

    @Test("finds no branches when merged branches are deeper than the max allowed depth")
    func branchExceedingMaxDepth() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          ad1bb03c2 Commit 6

          93e3fa587 Commit 5

          b84b3f6a1 Commit 4

          cafe21ab5 Commit 3

          f6b3cd8e6 Commit 2

          """,
          "feature": """
          e2286db93 Commit 2

          88be3f666 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          ad1bb03c2 Commit 6

          93e3fa587 Commit 5

          b84b3f6a1 Commit 4

          cafe21ab5 Commit 3

          f6b3cd8e6 Commit 2

          """,
          "main..feature": """
          e2286db93 Commit 2

          """,
        ],
        config: .init(branchMaxDepth: 5),
        expect: []
      )
    }

    @Test("finds branch when its depth is equal to the max allowed depth")
    func branchMatchingMaxDepth() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          ad1bb03c2 Commit 5

          93e3fa587 Commit 4

          b84b3f6a1 Commit 3

          f6b3cd8e6 Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          e2286db93 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          ad1bb03c2 Commit 5

          93e3fa587 Commit 4

          b84b3f6a1 Commit 3

          f6b3cd8e6 Commit 2

          """,
          "main..feature": """
          e2286db93 Commit 2

          """,
        ],
        config: .init(branchMaxDepth: 5),
        expect: ["feature"]
      )
    }

    @Test("finds single branch with multiple commits merged into ref")
    func branchWithMultipleCommits() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          b84b3f6a1 Commit 3

          e2286db93 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          """,
          "main..feature": """
          b84b3f6a1 Commit 3

          e2286db93 Commit 2

          """,
        ],
        expect: ["feature"]
      )
    }

    @Test("finds no branches when branch is merged into ref but not deleted from remote")
    func branchNotRemovedFromRemote() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        remoteBranches: """
            origin/feature
          """,
        log: [
          "main": """
          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          b84b3f6a1 Commit 3

          e2286db93 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          """,
          "main..feature": """
          b84b3f6a1 Commit 3

          e2286db93 Commit 2

          """,
        ], expect: []
      )
    }

    @Test("finds multiple branches with multiple commits merged into ref")
    func branchesWithMultipleCommits() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
            refactor
          """,
        log: [
          "main": """
          ed581222a Commit 7
            * Commit 6

            * Commit 5

          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          b84b3f6a1 Commit 3

          e2286db93 Commit 2

          f6b3cd8e6 Commit 1

          """,
          "refactor": """
          69bcf48d4 Commit 6

          a6050e369 Commit 5

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          ed581222a Commit 7
            * Commit 6

            * Commit 5

          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          """,
          "main..feature": """
          b84b3f6a1 Commit 3

          e2286db93 Commit 2

          """,
          "refactor..main": """
          ed581222a Commit 7
            * Commit 6

            * Commit 5

          93e3fa587 Commit 4
            * Commit 3

            * Commit 2

          """,
          "main..refactor": """
          69bcf48d4 Commit 6

          a6050e369 Commit 5

          """,
        ],
        expect: ["feature", "refactor"]
      )
    }

    @Test("finds multiple branches with single commits merged into ref")
    func branchesWithSingleCommit() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
            refactor
          """,
        log: [
          "main": """
          ed581222a Commit 3

          93e3fa587 Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          af79d79e3 Commit 2

          f6b3cd8e6 Commit 1

          """,
          "refactor": """
          f0c0f8a16 Commit 3

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          ed581222a Commit 3

          93e3fa587 Commit 2

          """,
          "main..feature": """
          af79d79e3 Commit 2

          """,
          "refactor..main": """
          ed581222a Commit 3

          93e3fa587 Commit 2

          """,
          "main..refactor": """
          f0c0f8a16 Commit 3

          """,
        ],
        expect: ["feature", "refactor"]
      )
    }

    @Test("finds multiple branches with common commit history and merged into ref")
    func branchesWithCommonHistory() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
            refactor
          """,
        log: [
          "main": """
          ed581222a Commit 6
            * Commit 4

            * Commit 2

          e9f05c3d2 Commit 5
            * Commit 3

            * Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          c1fff91c6 Commit 3

          441d6916f Commit 2

          f6b3cd8e6 Commit 1

          """,
          "refactor": """
          6a3db1aec Commit 4

          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          ed581222a Commit 6
            * Commit 4

            * Commit 2

          e9f05c3d2 Commit 5
            * Commit 3

            * Commit 2

          """,
          "main..feature": """
          c1fff91c6 Commit 3

          441d6916f Commit 2

          """,
          "refactor..main": """
          ed581222a Commit 6
            * Commit 4

            * Commit 2

          e9f05c3d2 Commit 5
            * Commit 3

            * Commit 2

          """,
          "main..refactor": """
          6a3db1aec Commit 4

          5e4bfc7f1 Commit 2

          """,
        ],
        expect: ["feature", "refactor"]
      )
    }

    @Test("finds multiple branches that are stacked on top of each other and merged into ref")
    func branchesStackedOnEachOther() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
            refactor
          """,
        log: [
          "main": """
          39ef8dcf9 Commit 4
            * Commit 3

            * Commit 2

          c9a4ac2e8 Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
          "refactor": """
          6a3db1aec Commit 3

          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          39ef8dcf9 Commit 4
            * Commit 3

            * Commit 2

          c9a4ac2e8 Commit 2

          """,
          "main..feature": """
          5e4bfc7f1 Commit 2

          """,
          "refactor..main": """
          39ef8dcf9 Commit 4
            * Commit 3

            * Commit 2

          c9a4ac2e8 Commit 2

          """,
          "main..refactor": """
          6a3db1aec Commit 3

          5e4bfc7f1 Commit 2

          """,
        ],
        expect: ["feature", "refactor"]
      )
    }

    @Test("finds branch merged into ref when branch was merged with default message")
    func branchWithDefaultMergeMessage() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          39ef8dcf9 Merge branch 'feature'

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          39ef8dcf9 Merge branch 'feature'

          """,
          "main..feature": """
          5e4bfc7f1 Commit 2

          """,
        ],
        config: .init(branchMergeMatchers: [.defaultMergeMessage]),
        expect: ["feature"]
      )
    }

    @Test("finds branch merged into ref when merge message was prefixed with branch name")
    func branchWithPrefixMergeMessage() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          39ef8dcf9 feature Merge Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          39ef8dcf9 feature Merge Commit 2

          """,
          "main..feature": """
          5e4bfc7f1 Commit 2

          """,
        ],
        config: .init(branchMergeMatchers: [.branchNamePrefix]),
        expect: ["feature"]
      )
    }

    @Test(
      "finds branch merged into ref when merge message was prefixed with last path of the branch name"
    )
    func branchWithPrefixMergeMessageAndSubpath() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature/id-123
          * main
          """,
        log: [
          "main": """
          39ef8dcf9 id-123 Merge Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature/id-123": """
          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature/id-123..main": """
          39ef8dcf9 id-123 Merge Commit 2

          """,
          "main..feature/id-123": """
          5e4bfc7f1 Commit 2

          """,
        ],
        config: .init(branchMergeMatchers: [.branchNamePrefix]),
        expect: ["feature/id-123"]
      )
    }

    @Test(
      "finds no branches when merge message was prefixed with branch name but prefix matcher isn't used"
    )
    func branchWithPrefixMergeMessageAndDifferent() throws {
      try testFindBranchesToCleanup(
        localBranches: """
            feature
          * main
          """,
        log: [
          "main": """
          39ef8dcf9 feature Merge Commit 2

          f6b3cd8e6 Commit 1

          """,
          "feature": """
          5e4bfc7f1 Commit 2

          f6b3cd8e6 Commit 1

          """,
        ],
        logDiff: [
          "feature..main": """
          39ef8dcf9 feature Merge Commit 2

          """,
          "main..feature": """
          5e4bfc7f1 Commit 2

          """,
        ],
        config: .init(branchMergeMatchers: [.defaultMergeMessage]),
        expect: []
      )
    }
  }
}

class GitBranchCleanerSuite {
  var runner = TestGitRunner()
  var cleaner = GitBranchCleaner()

  let formatArg = GitCommands.formatArg

  init() {
    cleaner = GitBranchCleaner(gitClient: GitClient(commands: GitCommands(runner: runner)))
  }

  func testFindBranchesToCleanup(
    localBranches: String? = "",
    remoteBranches: String? = "",
    log: [String: String]? = [:],
    logDiff: [String: String]? = [:],
    config: GitBranchCleanerConfig = GitBranchCleanerConfig(),
    expectCommands commands: [String]? = nil,
    expect branches: [String]? = nil
  ) throws {
    //runner.defaultAnswer = ""

    if let localBranches {
      runner.answers["branch"] = localBranches
    }
    if let remoteBranches {
      runner.answers["branch -r"] = remoteBranches
    }
    if let log {
      runner.answerWith { args in
        if let branch = self.parseAsLog(args: args) {
          log[branch]
        } else {
          nil
        }
      }
    }
    if let logDiff {
      runner.answerWith { args in
        if let (base, target) = self.parseAsLogDiff(args: args) {
          logDiff["\(base)..\(target)"]
        } else {
          nil
        }
      }
    }

    let result = try cleaner.findBranchesToCleanup(for: config)

    if let branches {
      #expect(result.map(\.name) == branches)
    }
    if let commands {
      #expect(runner.commandArgs == commands)
    }
  }

  private func parseAsLog(args: String) -> String? {
    let regex = /log --format=\"%h %s%n%w\(0,2,2\)%b\" (.+) -n \d+ --/
    guard let match = args.wholeMatch(of: regex) else {
      return nil
    }
    let (_, branch) = match.output
    return String(branch)
  }

  private func parseAsLogDiff(args: String) -> (String, String)? {
    let regex = /log --format=\"%h %s%n%w\(0,2,2\)%b\" (.+)\.\.(.+)/
    guard let match = args.wholeMatch(of: regex) else {
      return nil
    }
    let (_, base, target) = match.output
    return (String(base), String(target))
  }
}
