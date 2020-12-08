import Foundation
import Algorithms

public enum Day7 {
    public static func main() throws {
        let input = try String(contentsOfFile: "day7.txt", encoding: .utf8)
        let rules = try parseInput(input)

        print(compute1(rules: rules))
        print(compute2(rules: rules))
    }

    static func compute1(rules: Rules) -> Int {
        rules.bags.lazy.filter {
            rules.check(bag: $0, contains: "shiny gold")
        }.count
    }

    static func compute2(rules: Rules) -> Int {
        rules.bagCount(bag: "shiny gold")
    }

    static func parseInput(_ input: String) throws -> Rules {
        let rulesList = try input.splitLines().map { try parseLine($0) }
        let bags = rulesList.map { $0.bag }
        let rules = Dictionary(uniqueKeysWithValues: rulesList.lazy.map { ($0.bag, $0.contains) })
        return Rules(bags: bags, rules: rules)
    }

    static func parseLine(_ line: String) throws -> Rule {
        let parts = line.components(separatedBy: "contain")
        var bag = parts[0].trimmingCharacters(in: .whitespaces)
        var end = parts[1].trimmingCharacters(in: .whitespaces)

        bag.removeLast(5)
        end.removeLast()

        let rulesString = end.components(separatedBy: ", ")

        let contains = try rulesString.compactMap { r -> (Int, String)? in
            let parts = r.components(separatedBy: .whitespaces)

            guard parts.count == 4 else { return nil }
            guard let count = Int(parts[0]) else {
                throw Errors.unparseableInput(r)
            }
            let bag = "\(parts[1]) \(parts[2])"
            return (count, bag)
        }
        return Rule(bag: bag, contains: contains)
    }


    struct Rule {
        let bag: String
        let contains: [(Int, String)]
    }

    struct Rules {
        let bags: [String]
        let rules: [String: [(Int, String)]]


        func check(bag: String, contains other: String) -> Bool {
            if bag == other { return true }
            let r = rules[bag]!

            return r.contains { (_, subBag) in
                self.check(bag: subBag, contains: other)
            }
        }

        func bagCount(bag: String) -> Int {
            guard let r = rules[bag] else { return 0 }

            return r.lazy.map { (count, subBag) in
                count + count * bagCount(bag: subBag)
            }.sum()
        }
    }
}
