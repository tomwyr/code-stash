import gleam/result

/// Returns second result if the first is `Ok`, otherwise returns the first `Error`.
pub fn and(first: Result(a, b), second: Result(a, b)) -> Result(a, b) {
  first |> result.try(fn(_) { second })
}
