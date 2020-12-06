import Foundation
import Algorithms

public enum Day6 {

    public static func main() throws {
        let input = try String(contentsOfFile: "day6.txt", encoding: .utf8)

        let data = parseInput(input)
        print(compute1(data))
        print(compute2(data))
    }

    static func parseInput(_ input: String) -> [[String]] {
        input.splitDoubleLines().map { $0.splitLines() }
    }

    static func compute1(_ data: [[String]]) -> Int {
        data.lazy.map { uniqueAnswers($0).count }.sum()
    }

    static func uniqueAnswers(_ group: [String]) -> [Character] {
        group.lazy.flatMap { $0 }.uniqued()
    }

    static func compute2(_ data: [[String]]) -> Int {
        data.lazy.map { commonAnswers($0) }.sum()
    }

    static func commonAnswers(_ group: [String]) -> Int{
        let answers = uniqueAnswers(group)
        return answers.lazy.filter { answer in
            group.allSatisfy { $0.contains(answer) }
        }.count
    }
}
