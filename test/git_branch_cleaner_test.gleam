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
        [
          "ef0309adc Commit 3", "489f7827f Commit 2",
          "4ffda615a Commit 1",
        ]
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
          "master" -> [
            "ef0309adc Commit 3", "4ffda615a Commit 1",
          ]
          "feature" -> ["489f7827f Commit 2", "4ffda615a Commit 1"]
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
          "master" -> [
            "489f7827f Commit 2", "4ffda615a Commit 1",
          ]
          "feature" -> ["489f7827f Commit 2", "4ffda615a Commit 1"]
          _ -> panic
        }
      },
      log_diff: fn(base, target) {
        case base, target {
          "feature", "master" -> ["489f7827f Commit 2"]
          "master", "feature" -> ["489f7827f Commit 2"]
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
