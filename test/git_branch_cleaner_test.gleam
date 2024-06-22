import git_branch_cleaner/finder
import git_branch_cleaner/types.{Branch}
import git_runner.{run_test_git}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn finds_no_branches_for_single_branch_repo_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master"],
      remote_branches: ["origin/master"],
      log_limited: fn(_) {
        ["d34cd1061 Commit 3", "48ae1312c Commit 2", "e3bd998e5 Commit 1"]
      },
      log_diff: ignore_log_diff,
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([])
}

pub fn finds_no_branches_for_branch_not_merged_into_ref_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master", "feature"],
      remote_branches: ["origin/master"],
      log_limited: fn(branch) {
        case branch {
          "master" -> ["77776f5ae Commit 3", "2a6ceec75 Commit 1"]
          "feature" -> ["c2c8e45f8 Commit 2", "2a6ceec75 Commit 1"]
          _ -> panic
        }
      },
      log_diff: ignore_log_diff,
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([])
}

pub fn finds_branch_merged_into_ref_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master", "feature"],
      remote_branches: ["origin/master"],
      log_limited: fn(branch) {
        case branch {
          "master" -> ["d40d5be9a Commit 2", "629733525 Commit 1"]
          "feature" -> ["1d88768b9 Commit 2", "629733525 Commit 1"]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "master", "feature" -> ["d40d5be9a Commit 2"]
          "feature", "master" -> ["1d88768b9 Commit 2"]
          _, _ -> panic
        }
      },
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([Branch(name: "feature")])
}

pub fn finds_branch_with_multiple_commits_merged_into_ref_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master", "feature"],
      remote_branches: ["origin/master"],
      log_limited: fn(branch) {
        case branch {
          "master" -> [
            "6708db115 Commit 4\n  * Commit 3\n\n  * Commit 2",
            "3643c1bc4 Commit 1",
          ]
          "feature" -> [
            "41d41abf0 Commit 3", "be424315f Commit 2", "3643c1bc4 Commit 1",
          ]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "master", "feature" -> [
            "6708db115 Commit 4\n  * Commit 3\n\n  * Commit 2",
          ]
          "feature", "master" -> ["41d41abf0 Commit 3", "be424315f Commit 2"]
          _, _ -> panic
        }
      },
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([Branch(name: "feature")])
}

pub fn finds_no_branches_for_branch_merged_but_not_deleted_from_remote_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master", "feature"],
      remote_branches: ["origin/master", "origin/feature"],
      log_limited: fn(branch) {
        case branch {
          "master" -> [
            "dc7c13e21 Commit 4\n  * Commit 3\n\n  * Commit 2",
            "2a52f0971 Commit 1",
          ]
          "feature" -> [
            "0d51efa2a Commit 3", "5c7700098 Commit 2", "2a52f0971 Commit 1",
          ]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "master", "feature" -> [
            "dc7c13e21 Commit 4\n  * Commit 3\n\n  * Commit 2",
          ]
          "feature", "master" -> ["0d51efa2a Commit 3", "5c7700098 Commit 2"]
          _, _ -> panic
        }
      },
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([])
}

pub fn finds_multiple_branches_with_multiple_commits_merged_into_ref_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master", "feature-a", "feature-b"],
      remote_branches: ["origin/master"],
      log_limited: fn(branch) {
        case branch {
          "master" -> [
            "3fe43fbf7 Commit 4\n  * Commit 3\n\n  * Commit 2",
            "86d6dac4f Commit 7\n  * Commit 6\n\n  * Commit 5",
            "cfa717aed Commit 1",
          ]
          "feature-a" -> [
            "01ae1f5cf Commit 3", "e1d50ee17 Commit 2", "cfa717aed Commit 1",
          ]
          "feature-b" -> [
            "3951ac595 Commit 6", "88c8a31b9 Commit 5", "cfa717aed Commit 1",
          ]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "master", "feature-a" -> [
            "3fe43fbf7 Commit 4\n  * Commit 3\n\n  * Commit 2",
          ]
          "feature-a", "master" -> ["01ae1f5cf Commit 3", "e1d50ee17 Commit 2"]
          "master", "feature-b" -> [
            "3fe43fbf7 Commit 4\n  * Commit 3\n\n  * Commit 2",
            "86d6dac4f Commit 7\n  * Commit 6\n\n  * Commit 5",
          ]
          "feature-b", "master" -> ["3951ac595 Commit 6", "88c8a31b9 Commit 5"]
          _, _ -> panic
        }
      },
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([Branch("feature-a"), Branch("feature-b")])
}

pub fn finds_multiple_branches_with_single_commits_merged_into_ref_test() {
  let git_runner =
    run_test_git(
      local_branches: ["master", "feature-a", "feature-b"],
      remote_branches: ["origin/master"],
      log_limited: fn(branch) {
        case branch {
          "master" -> [
            "910ca29d7 Commit 3", "ca7d64d26 Commit 2", "e403d84ec Commit 1",
          ]
          "feature-a" -> ["066c13611 Commit 2", "e403d84ec Commit 1"]
          "feature-b" -> ["ece47178d Commit 3", "e403d84ec Commit 1"]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "master", "feature-a" -> ["910ca29d7 Commit 3", "ca7d64d26 Commit 2"]
          "feature-a", "master" -> ["066c13611 Commit 2"]
          "master", "feature-b" -> ["910ca29d7 Commit 3", "ca7d64d26 Commit 2"]
          "feature-b", "master" -> ["ece47178d Commit 3"]
          _, _ -> panic
        }
      },
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([Branch("feature-a"), Branch("feature-b")])
}

fn ignore_log_diff(_: String, _: String) {
  []
}
