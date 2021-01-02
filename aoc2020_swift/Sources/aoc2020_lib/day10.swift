//
//  day10.swift
//  aoc2020_lib
//
//  Created by Alexandre Delattre on 10/12/2020.
//

import Foundation


public enum Day10 {
    public static func main() throws {
        let input = try String(contentsOfFile: "day10.txt", encoding: .utf8)

        var numbers: [Int] = try input.splitLines().map {
            guard let i = Int($0) else { throw Errors.unparseableInput($0) }
            return i
        }
        numbers.sort()

        print(compute1(numbers))
        print(compute2(numbers))
    }

    static func compute1(_ numbers: [Int]) -> Int {
        var oneDiffs = 0
        var threeDiffs = 1
        var current = 0
        for n in numbers {
            let diff = n - current
            if diff == 1 { oneDiffs += 1 }
            if diff == 3 { threeDiffs += 1 }
            current = n
        }
        return oneDiffs * threeDiffs
    }

    static func compute2(_ numbers: [Int]) -> UInt64 {
        let numbers = Set(numbers) //SparseIntSet(numbers) //Set(numbers)
        let target = numbers.max()! + 3
        return recursiveMemoize { f, n in
            if n == target { return 1 }
            guard n == 0 || numbers.contains(n) else { return 0 }

            return f(n + 1) + f(n + 2) + f(n + 3)
        }(0)
    }
}

struct SparseIntSet {
    let min: Int
    let max: Int
    let array: [Bool]

    init(_ ints: [Int])  {
        let min = ints.first!
        let max = ints.last!

        var array = [Bool](repeating: false, count: max - min + 1)
        ints.forEach {
            array[$0 - min] = true
        }
        self.min = min
        self.max = max
        self.array = array
    }

    func contains(_ n: Int) -> Bool {
        guard min <= n && n <= max else {
            return false
        }
        return array[n - min]
    }
}

func recursiveMemoize<Input: Hashable, Output>(
    _ function: @escaping ((Input) -> Output, Input) -> Output
) -> (Input) -> Output {
    var storage = [Input: Output]()

    var f: ((Input) -> Output)?
    f = { input in
        if let cached = storage[input] {
            return cached
        }

        let result = function(f!, input)
        storage[input] = result
        return result
    }
    return f!
}
