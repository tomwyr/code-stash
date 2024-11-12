import Testing

@testable import GitBranchCleaner

final class GitClientTests {
  final class GetLocalOnlyBranches: GitClientSuite {
    @Test("runs expected git commands")
    func gitCommands() async throws {
      runner.defaultAnswer = ""

      _ = try client.getLocalOnlyBranches()

      let expectedArgs = [
        "branch",
        "branch -r",
      ]

      #expect(runner.commandArgs == expectedArgs)
    }

    @Test("returns empty list when all local branches are in origin")
    func allBranchesInOrigin() async throws {
      runner.answers = [
        "branch": """
          feature-a
        * main
          refactor-a
        """,
        "branch -r": """
          origin/feature-a
          origin/feature-b
          origin/main
          origin/refactor-a
          origin/refactor-b
        """,
      ]

      let branches = try client.getLocalOnlyBranches()

      #expect(branches == [])
    }

    @Test("returns all branches when none is in origin")
    func noBranchInOrigin() async throws {
      runner.answers = [
        "branch": """
          feature-a
        * main
          refactor-a
        """,
        "branch -r": """
          origin/feature-b
          origin/feature-c
          origin/master
          origin/refactor-b
          origin/refactor-c
        """,
      ]

      let branches = try client.getLocalOnlyBranches()

      let expectedBranches = [
        Branch(name: "feature-a"),
        Branch(name: "main"),
        Branch(name: "refactor-a"),
      ]

      #expect(branches == expectedBranches)
    }

    @Test("returns only branches that are not in origin")
    func someBranchesInOrigin() async throws {
      runner.answers = [
        "branch": """
          feature-a
        * main
          refactor-a
        """,
        "branch -r": """
          origin/feature-a
          origin/feature-b
          origin/master
          origin/refactor-b
          origin/refactor-c
        """,
      ]

      let branches = try client.getLocalOnlyBranches()

      let expectedBranches = [
        Branch(name: "main"),
        Branch(name: "refactor-a"),
      ]

      #expect(branches == expectedBranches)
    }
  }

  final class HasCommonAncestor: GitClientSuite {
    @Test("runs expected git commands")
    func expectedArgs() async throws {
      runner.defaultAnswer = ""

      _ = try client.hasCommonAncestor(
        branch: Branch(name: "feature-a"),
        with: Branch(name: "main"),
        notDeeperThan: 5
      )

      let expectedArgs = [
        "log \(formatArg) feature-a -n 5 --",
        "log \(formatArg) main -n 5 --",
      ]

      #expect(runner.commandArgs == expectedArgs)
    }

    @Test("finds common ancestor when commit histories are identical")
    func identicalHistory() async throws {
      runner.answers = [
        "log \(formatArg) feature-a -n 5 --": """
        cf6709acf Commit 5

        c8960b278 Commit 4

        3aa5dc837 Commit 3

        8d5029677 Commit 2

        ba3b86561 Commit 1

        """,
        "log \(formatArg) main -n 5 --": """
        cf6709acf Commit 5

        c8960b278 Commit 4

        3aa5dc837 Commit 3

        8d5029677 Commit 2

        ba3b86561 Commit 1

        """,
      ]

      let hasCommentAncestor = try client.hasCommonAncestor(
        branch: Branch(name: "feature-a"),
        with: Branch(name: "main"),
        notDeeperThan: 5
      )

      #expect(hasCommentAncestor)
    }

    @Test("finds common ancestor when commit histories are partially common")
    func commonHistory() async throws {
      runner.answers = [
        "log \(formatArg) feature-a -n 5 --": """
        cf6709acf Commit 5

        c8960b278 Commit 4

        3aa5dc837 Commit 3

        8d5029677 Commit 2

        ba3b86561 Commit 1

        """,
        "log \(formatArg) main -n 5 --": """
        efde9be63 Commit 7

        6e02ddb52 Commit 6

        3aa5dc837 Commit 3

        8d5029677 Commit 2

        ba3b86561 Commit 1

        """,
      ]

      let hasCommentAncestor = try client.hasCommonAncestor(
        branch: Branch(name: "feature-a"),
        with: Branch(name: "main"),
        notDeeperThan: 5
      )

      #expect(hasCommentAncestor)
    }

    @Test("finds common ancestor when common commits have also descriptions")
    func commitsWithDescriptions() async throws {
      runner.answers = [
        "log \(formatArg) feature-a -n 5 --": """
        cf6709acf Commit 5

        c8960b278 Commit 4

        3aa5dc837 Commit 3

        8d5029677 Commit 2
          * Change C

          * Change B

        ba3b86561 Commit 1
          * Change A

        """,
        "log \(formatArg) main -n 5 --": """
        cf6709acf Commit 7

        c8960b278 Commit 6

        3aa5dc837 Commit 3

        8d5029677 Commit 2
          * Change C

          * Change B

        ba3b86561 Commit 1
          * Change A

        """,
      ]

      let hasCommentAncestor = try client.hasCommonAncestor(
        branch: Branch(name: "feature-a"),
        with: Branch(name: "main"),
        notDeeperThan: 5
      )

      #expect(hasCommentAncestor)
    }

    @Test("doesn't find common ancestor when commit histories are different")
    func differentHistory() async throws {
      runner.answers = [
        "log \(formatArg) feature-a -n 5 --": """
        2863c301e Commit 5

        5750b6a58 Commit 4

        c6ca1028e Commit 3

        283fd92b0 Commit 2

        260c0b201 Commit 1

        """,
        "log \(formatArg) main -n 5 --": """
        3be8bbe51 Commit 10

        e258e1a3c Commit 9

        7d5bc0e1f Commit 8

        3b2e01c8b Commit 7

        c3697926c Commit 6

        """,
      ]

      let hasCommentAncestor = try client.hasCommonAncestor(
        branch: Branch(name: "feature-a"),
        with: Branch(name: "main"),
        notDeeperThan: 5
      )

      #expect(!hasCommentAncestor)
    }

    @Test("doesn't find common ancestor when only commits hashes are different")
    func differentCommitHashes() async throws {
      runner.answers = [
        "log \(formatArg) feature-a -n 5 --": """
        eb77d6f7e Commit 5

        c98d71ce8 Commit 4

        5783d39f2 Commit 3

        8c9a57f9b Commit 2

        91c752506 Commit 1

        """,
        "log \(formatArg) main -n 5 --": """
        1e3011fe9 Commit 5

        0c5d2c002 Commit 4

        fdea9ce31 Commit 3

        ac6f50220 Commit 2

        6d19c7356 Commit 1

        """,
      ]

      let hasCommentAncestor = try client.hasCommonAncestor(
        branch: Branch(name: "feature-a"),
        with: Branch(name: "main"),
        notDeeperThan: 5
      )

      #expect(!hasCommentAncestor)
    }
  }

  final class DiffBranches: GitClientSuite {
    @Test("runs expected git commands")
    func expectedArgs() async throws {
      runner.defaultAnswer = ""

      _ = try client.diffBranches(
        startingFrom: Branch(name: "feature-a"),
        presentIn: Branch(name: "main")
      )

      let expectedArgs = [
        "log \(formatArg) main..feature-a",
        "log \(formatArg) feature-a..main",
      ]

      #expect(runner.commandArgs == expectedArgs)
    }

    @Test("returns empty diff when commit histories are identical")
    func identicalHistory() async throws {
      runner.answers = [
        "log \(formatArg) main..feature-a": "",
        "log \(formatArg) feature-a..main": "",
      ]

      let branchDiff = try client.diffBranches(
        startingFrom: Branch(name: "feature-a"),
        presentIn: Branch(name: "main")
      )

      let expectedDiff = BranchDiff(
        base: BranchSlice(branch: Branch(name: "feature-a"), commits: []),
        target: BranchSlice(branch: Branch(name: "main"), commits: [])
      )

      #expect(branchDiff == expectedDiff)
    }

    @Test("returns diff with commits only in base branch when base is ahead of target history")
    func commitsOnlyInBase() async throws {
      runner.answers = [
        "log \(formatArg) main..feature-a": """
        b126c6ea1 Commit 5

        1720a95ad Commit 4

        ca4cabf2c Commit 3

        d6c67b1f9 Commit 2

        a3117be73 Commit 1

        """,
        "log \(formatArg) feature-a..main": "",
      ]

      let branchDiff = try client.diffBranches(
        startingFrom: Branch(name: "feature-a"),
        presentIn: Branch(name: "main")
      )

      let expectedDiff = BranchDiff(
        base: BranchSlice(
          branch: Branch(name: "feature-a"),
          commits: [
            Commit(hash: "b126c6ea1", summary: "Commit 5"),
            Commit(hash: "1720a95ad", summary: "Commit 4"),
            Commit(hash: "ca4cabf2c", summary: "Commit 3"),
            Commit(hash: "d6c67b1f9", summary: "Commit 2"),
            Commit(hash: "a3117be73", summary: "Commit 1"),
          ]
        ),
        target: BranchSlice(branch: Branch(name: "main"), commits: [])
      )

      #expect(branchDiff == expectedDiff)
    }

    @Test(
      "returns diff with commits only in target branch when target is ahead of base history")
    func commitsOnlyInTarget() async throws {
      runner.answers = [
        "log \(formatArg) main..feature-a": "",
        "log \(formatArg) feature-a..main": """
        b126c6ea1 Commit 5

        1720a95ad Commit 4

        ca4cabf2c Commit 3

        d6c67b1f9 Commit 2

        a3117be73 Commit 1

        """,
      ]

      let branchDiff = try client.diffBranches(
        startingFrom: Branch(name: "feature-a"),
        presentIn: Branch(name: "main")
      )

      let expectedDiff = BranchDiff(
        base: BranchSlice(branch: Branch(name: "feature-a"), commits: []),
        target: BranchSlice(
          branch: Branch(name: "main"),
          commits: [
            Commit(hash: "b126c6ea1", summary: "Commit 5"),
            Commit(hash: "1720a95ad", summary: "Commit 4"),
            Commit(hash: "ca4cabf2c", summary: "Commit 3"),
            Commit(hash: "d6c67b1f9", summary: "Commit 2"),
            Commit(hash: "a3117be73", summary: "Commit 1"),
          ]
        )
      )

      #expect(branchDiff == expectedDiff)
    }

    @Test(
      "returns diff with commits in base and target when recent histories of the branches differ"
    )
    func commitsInBaseAndTarget() async throws {
      runner.answers = [
        "log \(formatArg) main..feature-a": """
        ebe89c627 Commit 10

        d24b77cf6 Commit 9

        59d0c47c9 Commit 8

        da3fa9d47 Commit 7

        8b5cceb0b Commit 6

        """,
        "log \(formatArg) feature-a..main": """
        b126c6ea1 Commit 5

        1720a95ad Commit 4

        ca4cabf2c Commit 3

        d6c67b1f9 Commit 2

        a3117be73 Commit 1

        """,
      ]

      let branchDiff = try client.diffBranches(
        startingFrom: Branch(name: "feature-a"),
        presentIn: Branch(name: "main")
      )

      let expectedDiff = BranchDiff(
        base: BranchSlice(
          branch: Branch(name: "feature-a"),
          commits: [
            Commit(hash: "ebe89c627", summary: "Commit 10"),
            Commit(hash: "d24b77cf6", summary: "Commit 9"),
            Commit(hash: "59d0c47c9", summary: "Commit 8"),
            Commit(hash: "da3fa9d47", summary: "Commit 7"),
            Commit(hash: "8b5cceb0b", summary: "Commit 6"),
          ]
        ),
        target: BranchSlice(
          branch: Branch(name: "main"),
          commits: [
            Commit(hash: "b126c6ea1", summary: "Commit 5"),
            Commit(hash: "1720a95ad", summary: "Commit 4"),
            Commit(hash: "ca4cabf2c", summary: "Commit 3"),
            Commit(hash: "d6c67b1f9", summary: "Commit 2"),
            Commit(hash: "a3117be73", summary: "Commit 1"),
          ]
        )
      )

      #expect(branchDiff == expectedDiff)
    }

    @Test("returns commits with descriptions when descriptions are present in histories")
    func commitsWithDescriptions() async throws {
      runner.answers = [
        "log \(formatArg) main..feature-a": """
        ebe89c627 Commit 6
          * Change G

          * Change F

        d24b77cf6 Commit 5

        59d0c47c9 Commit 4
          * Change E

        """,
        "log \(formatArg) feature-a..main": """
        b126c6ea1 Commit 3

        1720a95ad Commit 2
          * Change D

        a3117be73 Commit 1
          * Change C

          * Change B

          * Change A

        """,
      ]

      let branchDiff = try client.diffBranches(
        startingFrom: Branch(name: "feature-a"),
        presentIn: Branch(name: "main")
      )

      let expectedDiff = BranchDiff(
        base: BranchSlice(
          branch: Branch(name: "feature-a"),
          commits: [
            Commit(
              hash: "ebe89c627",
              summary: "Commit 6",
              description: "  * Change G\n\n  * Change F"
            ),
            Commit(
              hash: "d24b77cf6",
              summary: "Commit 5"
            ),
            Commit(
              hash: "59d0c47c9",
              summary: "Commit 4",
              description: "  * Change E"
            ),
          ]
        ),
        target: BranchSlice(
          branch: Branch(name: "main"),
          commits: [
            Commit(
              hash: "b126c6ea1",
              summary: "Commit 3"
            ),
            Commit(
              hash: "1720a95ad",
              summary: "Commit 2",
              description: "  * Change D"
            ),
            Commit(
              hash: "a3117be73",
              summary: "Commit 1",
              description: "  * Change C\n\n  * Change B\n\n  * Change A"
            ),
          ]
        )
      )

      #expect(branchDiff == expectedDiff)
    }
  }

  final class DeleteBranch: GitClientSuite {
    @Test("runs expected git commands")
    func expectedArgs() async throws {
      runner.defaultAnswer = ""

      _ = try client.deleteBranch(branch: Branch(name: "feature-a"))

      #expect(runner.commandArgs == ["branch -D feature-a"])
    }
  }
}

class GitClientSuite {
  var runner = TestGitRunner()
  var client = GitClient()

  let formatArg = GitCommands.formatArg

  init() {
    client = GitClient(commands: GitCommands(runner: runner))
  }
}
