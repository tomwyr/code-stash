/// Invokes callback function with the provided object and returns the original
/// object unmodified.
pub fn relay(object: a, run callback: fn(a) -> Nil) -> a {
  callback(object)
  object
}
