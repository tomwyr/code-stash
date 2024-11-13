import Testing

@testable import GitBranchCleaner

class TestGitRunner: GitRunner {
  var commandArgs = [String]()

  var defaultAnswer: String? = nil
  var answers = [String: String]()
  var answerHandlers = [(String) -> String?]()

  func answerWith(handler: @escaping (String) -> String?) {
    answerHandlers.append(handler)
  }

  func run(with arguments: String...) throws -> String {
    let joinedArgs = arguments.joined(separator: " ")
    commandArgs.append(joinedArgs)
    let answer =
      answerHandlers.compactMap { $0(joinedArgs) }.first ?? answers[joinedArgs] ?? defaultAnswer
    guard let answer else {
      Issue.record("No answer was registered for the following args: \(joinedArgs)")
      return ""
    }
    return answer
  }
}
