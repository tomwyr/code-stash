import git_branch_cleaner/finder
import git_runner.{run_test_git}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn runs_finder_test() {
  finder.find_branches_to_cleanup(git_runner: fn(_) { Ok("") })
}

pub fn finds_no_branches_for_single_branch_repo_test() {
  let git_runner =
    run_test_git(
      local_branches: ["  master"],
      remote_branches: ["  origin/HEAD -> origin/master"],
      log_limited: [
        "ffd7b8cad (HEAD -> master, origin/master, origin/HEAD) Commit 1",
        "afb0d60cb Commit 2", "ef0309adc Commit 3", "489f7827f Commit 4",
        "4ffda615a Commit 5",
      ],
    )

  let result = finder.find_branches_to_cleanup(git_runner: git_runner)

  result
  |> should.be_ok()
  |> should.equal([])
}
