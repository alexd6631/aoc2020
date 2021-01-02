//
//  day9.swift
//  aoc2020_lib
//
//  Created by Alexandre Delattre on 09/12/2020.
//

import Foundation
import Algorithms

public enum Day9 {
    public static func main() throws {
        let input = try String(contentsOfFile: "day9.txt", encoding: .utf8)

        let numbers: [Int] = try input.splitLines().map {
            guard let i = Int($0) else { throw Errors.unparseableInput($0) }
            return i
        }

        let res = compute1(numbers: numbers)!
        print(res)

        print(compute2(numbers: numbers, target: res))
    }

    static func compute1(numbers: [Int]) -> Int? {
        numbers.dropFirst(25).enumerated().first { (index, n) in
            let before = numbers[index..<index+25]
            return !hasPair(target: n, in: before)
        }?.element
    }

    static func compute2(numbers: [Int], target: Int) -> Int {
        let indices = (0..<numbers.count)
        let range = indices.combinations(ofCount: 2)
            .lazy
            .map { numbers[$0[0]...$0[1]] }
            .first { $0.sum() == target }!

        return range.min()! + range.max()!
    }

    static func hasPair(target: Int, in numbers: ArraySlice<Int>) -> Bool {
        numbers.combinations(ofCount: 2).contains { $0[0] + $0[1] == target }
    }
}
