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
          "feature" -> ["d40d5be9a Commit 2", "629733525 Commit 1"]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "master", "feature" -> ["d40d5be9a Commit 2"]
          "feature", "master" -> ["d40d5be9a Commit 2"]
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

fn ignore_log_diff(_: String, _: String) {
  []
}
