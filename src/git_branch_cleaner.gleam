import gleam/io
import gleam/list
import gleam/result
import utils

pub fn main() {
  case find_branches_to_cleanup() {
    Ok(_) -> io.println("ok")
    Error(_) -> io.println_error("err")
  }
}

fn find_branches_to_cleanup() {
  let ref_branch = get_reference_branch()
  let local_branches = get_local_only_branches()

  use branch_diffs <- result.map(local_branches
    |> list.map(diff_branches(starting_from: _, present_in: ref_branch))
    |> utils.group_results()
  )

  branch_diffs
  |> list.filter(keeping: base_merged_in_target)
  |> list.map(fn(diff) { diff.base.branch })
}

fn get_reference_branch() -> Branch {
  Branch(name: "master")
}

fn get_local_only_branches() {
  todo
}

fn parse_branch_log(branch_log: String, branch_type: BranchType) {
  todo
}

fn diff_branches(starting_from base: Branch, present_in target: Branch) {
  todo
}

fn parse_commits(from commits_log: String) -> List(Commit) {
  todo
}

fn base_merged_in_target(branch_diff: BranchDiff) -> Bool {
  todo
}

type Commit {
  Commit(hash: String, message: String)
}

pub type Branch {
  Branch(name: String)
}

type BranchSlice {
  BranchSlice(branch: Branch, commits: List(Commit))
}

type BranchDiff {
  BranchDiff(base: BranchSlice, target: BranchSlice)
}

type BranchType {
  Local
  Remote
}
