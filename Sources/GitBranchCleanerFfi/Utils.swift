import Foundation

func runCatching<T: Encodable>(_ block: () throws -> T) -> UnsafeMutablePointer<CChar>? {
  do {
    return strdup(encodeData(try block()))
  } catch {
    return strdup(encodeError(error))
  }
}

func runCatching(_ block: () throws -> Void) -> UnsafeMutablePointer<CChar>? {
  runCatching {
    try block()
    return ""
  }
}

func decode<T: Decodable>(from input: UnsafePointer<CChar>, into: T.Type) throws -> T {
  let data = String(cString: input).data(using: .utf8)!
  return try JSONDecoder().decode(T.self, from: data)
}

func encode<T: Encodable>(from input: T) throws -> String {
  let data = try JSONEncoder().encode(input)
  return String(data: data, encoding: .utf8)!
}
