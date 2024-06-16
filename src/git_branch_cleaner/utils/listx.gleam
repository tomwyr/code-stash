import gleam/list

/// Returns a new list containing only the elements from the first list for
/// which the given functions returns `Ok(True)`.
/// 
/// If the function returns `Ok` for all elements in the list then a
/// list of the new values is returned.
///
/// If the function returns `Error` for any of the elements then it is
/// returned immediately. None of the elements in the list are processed after
/// one returns an `Error`.
pub fn try_filter(
  list: List(a),
  keeping predicate: fn(a) -> Result(Bool, b),
) -> Result(List(a), b) {
  list.try_map(list, fn(elem) {
    case predicate(elem) {
      Ok(_) -> Ok(elem)
      Error(error) -> Error(error)
    }
  })
}
