class Logger {
  let level: LogLevel

  init(verbose: Bool) {
    self.level = verbose ? .debug : .info
  }

  func log(_ level: LogLevel, _ message: () -> String) {
    if skipLog(level: level) {
      return
    }

    switch level {
    case .debug:
      print("[debug] \(message())")
    case .info:
      print(message())
    }
  }

  private func skipLog(level: LogLevel) -> Bool {
    level.rawValue < self.level.rawValue
  }
}

enum LogLevel: Int {
  case debug = 0
  case info = 1
}
