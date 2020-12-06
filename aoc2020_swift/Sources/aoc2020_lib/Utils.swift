//
//  File.swift
//  
//
//  Created by Alexandre Delattre on 05/12/2020.
//

import Foundation

public enum Errors: Swift.Error {
    case unparseableInput(String)
}

extension Sequence where Element: Numeric {
    func sum() -> Element {
        reduce(0, { $0 + $1 })
    }

    func product() -> Element {
        reduce(1, { $0 * $1 })
    }
}

func readFile(_ file: String) throws -> String {
    try String(contentsOfFile: file, encoding: .utf8)
}


func readFileLines(_ file: String) throws -> [String] {
    let data = try readFile(file)
    return data.splitLines()
}

extension Range where Bound: BinaryInteger {
    private var middle: Bound {
        (lowerBound + upperBound) / 2
    }
    func lowerHalf() -> Range {
        lowerBound ..< middle
    }
    func upperHalf() -> Range {
        middle ..< upperBound
    }
}


extension StringProtocol {
    func splitLines() -> [String] {
        components(separatedBy: .newlines).filter { !$0.isEmpty }
    }

    func splitDoubleLines() -> [String] {
        components(separatedBy: "\n\n").filter { !$0.isEmpty }
    }
}
