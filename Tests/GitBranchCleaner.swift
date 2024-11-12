import Testing

@testable import GitBranchCleaner

final class GitBranchCleanerTests {
  final class FindBranchesToCleanup: GitBranchCleanerSuite {
    @Test("passes config values as expected arguments to git commands")
    func passingConfig() async throws {
      runner.answers = [
        "branch": """
          ref
          feature
        """,
        "branch -r": "",
        "log \(formatArg) ref -n 7 --": "",
        "log \(formatArg) feature -n 7 --": "",
      ]

      let config = GitBranchCleanerConfig(
        branchMaxDepth: 7,
        refBranchName: "ref"
      )
      _ = try cleaner.findBranchesToCleanup(for: config)

      let expectedCommands = [
        "branch",
        "branch -r",
        "log \(formatArg) feature -n 7 --",
        "log \(formatArg) ref -n 7 --",
      ]

      #expect(runner.commandArgs == expectedCommands)
    }

    @Test("finds no branches when there's only ref branch in the repository")
    func onlyRefInRepo() async throws {
      runner.answers = [
        "branch": """
        * main
        """,
        "branch -r": "",
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [])
    }

    @Test("finds no branches when local branch is not merged into ref branch")
    func noBranchesInRef() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        e2286db93 Commit 2

        88be3f666 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        b960e0b25 Commit 3

        88be3f666 Commit 1

        """,
        "log \(formatArg) feature..main": """
        e2286db93 Commit 2

        """,
        "log \(formatArg) main..feature": """
        b960e0b25 Commit 3

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [])
    }

    @Test("finds single branch when it's merged into ref branch")
    func branchInRef() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        e2286db93 Commit 2

        88be3f666 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        b960e0b25 Commit 2

        88be3f666 Commit 1

        """,
        "log \(formatArg) feature..main": """
        e2286db93 Commit 2

        """,
        "log \(formatArg) main..feature": """
        b960e0b25 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature")])
    }

    @Test("finds no branches when merged branches are deeper than the max allowed depth")
    func branchExceedingMaxDepth() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 5 --": """
        ad1bb03c2 Commit 6

        93e3fa587 Commit 5

        b84b3f6a1 Commit 4

        cafe21ab5 Commit 3

        f6b3cd8e6 Commit 2

        """,
        "log \(formatArg) feature -n 5 --": """
        e2286db93 Commit 2

        88be3f666 Commit 1

        """,
        "log \(formatArg) feature..main": """
        ad1bb03c2 Commit 6

        93e3fa587 Commit 5

        b84b3f6a1 Commit 4

        cafe21ab5 Commit 3

        f6b3cd8e6 Commit 2

        """,
        "log \(formatArg) main..feature": """
        e2286db93 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(
        branchMaxDepth: 5,
        refBranchName: "main"
      )
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [])

    }

    @Test("finds branch when its depth is equal to the max allowed depth")
    func branchMatchingMaxDepth() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 5 --": """
        ad1bb03c2 Commit 5

        93e3fa587 Commit 4

        b84b3f6a1 Commit 3

        f6b3cd8e6 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 5 --": """
        e2286db93 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        ad1bb03c2 Commit 5

        93e3fa587 Commit 4

        b84b3f6a1 Commit 3

        f6b3cd8e6 Commit 2

        """,
        "log \(formatArg) main..feature": """
        e2286db93 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(
        branchMaxDepth: 5,
        refBranchName: "main"
      )
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature")])
    }

    @Test("finds single branch with multiple commits merged into ref")
    func branchWithMultipleCommits() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        b84b3f6a1 Commit 3

        e2286db93 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        """,
        "log \(formatArg) main..feature": """
        b84b3f6a1 Commit 3

        e2286db93 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature")])
    }

    @Test("finds no branches when branch is merged into ref but not deleted from remote")
    func branchNotRemovedFromRemote() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": """
          origin/feature
        """,
        "log \(formatArg) main -n 25 --": """
        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        b84b3f6a1 Commit 3

        e2286db93 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        """,
        "log \(formatArg) main..feature": """
        b84b3f6a1 Commit 3

        e2286db93 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [])
    }

    @Test("finds multiple branches with multiple commits merged into ref")
    func branchesWithMultipleCommits() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
          refactor
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        ed581222a Commit 7
          * Commit 6

          * Commit 5

        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        b84b3f6a1 Commit 3

        e2286db93 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) refactor -n 25 --": """
        69bcf48d4 Commit 6

        a6050e369 Commit 5

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        ed581222a Commit 7
          * Commit 6

          * Commit 5

        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        """,
        "log \(formatArg) main..feature": """
        b84b3f6a1 Commit 3

        e2286db93 Commit 2

        """,
        "log \(formatArg) refactor..main": """
        ed581222a Commit 7
          * Commit 6

          * Commit 5

        93e3fa587 Commit 4
          * Commit 3

          * Commit 2

        """,
        "log \(formatArg) main..refactor": """
        69bcf48d4 Commit 6

        a6050e369 Commit 5

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature"), Branch(name: "refactor")])
    }

    @Test("finds multiple branches with single commits merged into ref")
    func branchesWithSingleCommit() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
          refactor
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        ed581222a Commit 3

        93e3fa587 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        af79d79e3 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) refactor -n 25 --": """
        f0c0f8a16 Commit 3

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        ed581222a Commit 3

        93e3fa587 Commit 2

        """,
        "log \(formatArg) main..feature": """
        af79d79e3 Commit 2

        """,
        "log \(formatArg) refactor..main": """
        ed581222a Commit 3

        93e3fa587 Commit 2

        """,
        "log \(formatArg) main..refactor": """
        f0c0f8a16 Commit 3

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature"), Branch(name: "refactor")])
    }

    @Test("finds multiple branches with common commit history and merged into ref")
    func branchesWithCommonHistory() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
          refactor
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        ed581222a Commit 6
          * Commit 4

          * Commit 2

        e9f05c3d2 Commit 5
          * Commit 3

          * Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        c1fff91c6 Commit 3

        441d6916f Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) refactor -n 25 --": """
        6a3db1aec Commit 4

        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        ed581222a Commit 6
          * Commit 4

          * Commit 2

        e9f05c3d2 Commit 5
          * Commit 3

          * Commit 2

        """,
        "log \(formatArg) main..feature": """
        c1fff91c6 Commit 3

        441d6916f Commit 2

        """,
        "log \(formatArg) refactor..main": """
        ed581222a Commit 6
          * Commit 4

          * Commit 2

        e9f05c3d2 Commit 5
          * Commit 3

          * Commit 2

        """,
        "log \(formatArg) main..refactor": """
        6a3db1aec Commit 4

        5e4bfc7f1 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature"), Branch(name: "refactor")])
    }

    @Test("finds multiple branches that are stacked on top of each other and merged into ref")
    func branchesStackedOnEachOther() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
          refactor
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        39ef8dcf9 Commit 4
          * Commit 3

          * Commit 2

        c9a4ac2e8 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) refactor -n 25 --": """
        6a3db1aec Commit 3

        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        39ef8dcf9 Commit 4
          * Commit 3

          * Commit 2

        c9a4ac2e8 Commit 2

        """,
        "log \(formatArg) main..feature": """
        5e4bfc7f1 Commit 2

        """,
        "log \(formatArg) refactor..main": """
        39ef8dcf9 Commit 4
          * Commit 3

          * Commit 2

        c9a4ac2e8 Commit 2

        """,
        "log \(formatArg) main..refactor": """
        6a3db1aec Commit 3

        5e4bfc7f1 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(refBranchName: "main")
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature"), Branch(name: "refactor")])
    }

    @Test("finds branch merged into ref when branch was merged with default message")
    func branchWithDefaultMergeMessage() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        39ef8dcf9 Merge branch 'feature'

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        39ef8dcf9 Merge branch 'feature'

        """,
        "log \(formatArg) main..feature": """
        5e4bfc7f1 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(
        refBranchName: "main",
        branchMergeMatchers: [.defaultMergeMessage]
      )
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature")])
    }

    @Test("finds branch merged into ref when merge message was prefixed with branch name")
    func branchWithPrefixMergeMessage() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        39ef8dcf9 feature Merge Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        39ef8dcf9 feature Merge Commit 2

        """,
        "log \(formatArg) main..feature": """
        5e4bfc7f1 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(
        refBranchName: "main",
        branchMergeMatchers: [.branchNamePrefix]
      )
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature")])
    }

    @Test(
      "finds branch merged into ref when merge message was prefixed with last path of the branch name"
    )
    func branchWithPrefixMergeMessageAndSubpath() async throws {
      runner.answers = [
        "branch": """
          feature/id-123
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        39ef8dcf9 id-123 Merge Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature/id-123 -n 25 --": """
        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature/id-123..main": """
        39ef8dcf9 id-123 Merge Commit 2

        """,
        "log \(formatArg) main..feature/id-123": """
        5e4bfc7f1 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(
        refBranchName: "main",
        branchMergeMatchers: [.branchNamePrefix]
      )
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [Branch(name: "feature/id-123")])
    }

    @Test(
      "finds no branches when merge message was prefixed with branch name but prefix matcher isn't used"
    )
    func branchWithPrefixMergeMessageAndDifferent() async throws {
      runner.answers = [
        "branch": """
          feature
        * main
        """,
        "branch -r": "",
        "log \(formatArg) main -n 25 --": """
        39ef8dcf9 feature Merge Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature -n 25 --": """
        5e4bfc7f1 Commit 2

        f6b3cd8e6 Commit 1

        """,
        "log \(formatArg) feature..main": """
        39ef8dcf9 feature Merge Commit 2

        """,
        "log \(formatArg) main..feature": """
        5e4bfc7f1 Commit 2

        """,
      ]

      let config = GitBranchCleanerConfig(
        refBranchName: "main",
        branchMergeMatchers: [.defaultMergeMessage]
      )
      let branches = try cleaner.findBranchesToCleanup(for: config)

      #expect(branches == [])
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
}
