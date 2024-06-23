import gleam/list
import gleam/option.{None, Some}
import gleam/result

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
  let apply_fitler = fn(elem: a) {
    case predicate(elem) {
      Ok(True) -> Ok(Some(elem))
      Ok(False) -> Ok(None)
      Error(error) -> Error(error)
    }
  }

  list.try_map(list, apply_fitler) |> result.map(option.values)
}
