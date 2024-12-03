import Foundation

func encodeSuccess(_ value: Encodable) -> String {
  do {
    let data = try encode(from: value)
    return #"{"success": \#(data)}"#
  } catch {
    return ResultEncodingError(value).encoded()
  }
}

func encodeError(_ value: Error) -> String {
  do {
    let data =
      if case let value as Encodable = value {
        try encode(from: value)
      } else {
        String(describing: value)
      }
    return #"{"error": \#(data)}"#
  } catch {
    return ResultEncodingError(value).encoded()
  }
}

struct ResultEncodingError {
  let value: Any

  init(_ value: Any) {
    self.value = value
  }

  func encoded() -> String {
    let resultValue = String(describing: value)
    return #"{"error": {"type": "ResultEncodingError", "result": \#(resultValue)}}"#
  }
}
