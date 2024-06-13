import shellout

pub type GitError =
  #(Int, String)

pub fn log_diff(
  from base_branch: String,
  to target_branch: String,
) -> Result(String, GitError) {
  exec_git(with: ["log", "--oneline", base_branch, target_branch])
}

pub fn local_branches() -> Result(String, GitError) {
  exec_git(with: ["branch"])
}

pub fn remote_branches() -> Result(String, GitError) {
  exec_git(with: ["branch", "-r"])
}

fn exec_git(with arguments: List(String)) -> Result(String, GitError) {
  shellout.command(run: "git", with: arguments, in: ".", opt: [])
}
