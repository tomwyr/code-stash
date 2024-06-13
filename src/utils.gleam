import gleam/result

pub fn group_results(list: List(Result(a, b))) -> Result(List(a), List(b)) {
  let #(oks, errors) = result.partition(list)
  case errors {
    [] -> Ok(oks)
    _ -> Error(errors)
  }
}
