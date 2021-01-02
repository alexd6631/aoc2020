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


public struct LazyInspectSequence<Base: Sequence>: LazySequenceProtocol {
    let base: Base
    let block: (Base.Element) -> ()

    public struct Iterator: IteratorProtocol {
        var base: Base.Iterator
        let block: (Base.Element) -> ()
        mutating public func next() -> Base.Element? {
            let next = base.next()
            if let next = next {
                block(next)
            }
            return next
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator(), block: block)
    }
}

public extension LazySequenceProtocol {
    func inspect(_ block: @escaping (Element) -> ()) -> LazyInspectSequence<Self> {
        LazyInspectSequence(base: self, block: block)
    }
}

public extension Sequence {
    func inspect(_ block: @escaping (Element) -> ()) -> Self {
        forEach(block)
        return self
    }
}

infix operator ..

func ..<T>(value: T, f: (inout T) -> ()) -> T {
    var copy = value
    f(&copy)
    return copy
}
