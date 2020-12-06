import Foundation
import Algorithms

public enum Day1 {
    public static func main() throws {
        let numbers = try parseInput(readFileLines("day1.txt"))
        
        print(compute1(numbers: numbers)!)
        print(compute2(numbers: numbers)!)
    }

    static func compute1(numbers: [UInt]) -> UInt? {
        compute(numbers: numbers, count: 2)
    }

    static func compute2(numbers: [UInt]) -> UInt? {
        compute(numbers: numbers, count: 3)
    }

    static func compute(numbers: [UInt], count: Int, target: UInt = 2020) -> UInt? {
        numbers
            .combinations(ofCount: count)
            .first { $0.sum() == target }?
            .product()
    }

    static func parseInput(_ lines: [String]) throws -> [UInt] {
        try lines.map {
            guard let i = UInt($0) else {
                throw Errors.unparseableInput($0)
            }
            return i
        }
    }
}
