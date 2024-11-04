import Testing

@testable import GitBranchCleaner

class TestGitRunner: GitRunner {
  var commandArgs = [String]()
  var answers = [String: String]()
  var defaultAnswer: String? = nil

  func run(with arguments: String...) throws -> String {
    let joinedArgs = arguments.joined(separator: " ")
    commandArgs.append(joinedArgs)
    guard let answer = answers[joinedArgs] ?? defaultAnswer else {
      Issue.record("No answer was registered for the following args: \(joinedArgs)")
      return ""
    }
    return answer
  }
}
