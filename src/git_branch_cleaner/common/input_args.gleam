import argv
import gleam/list

pub fn all() -> List(String) {
  argv.load().arguments
}

pub fn verbose() -> Bool {
  argv.load().arguments |> list.contains("-v")
}
