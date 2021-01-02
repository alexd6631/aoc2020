//
//  day12.swift
//  aoc2020_lib
//
//  Created by Alexandre Delattre on 31/12/2020.
//

import Foundation


public enum Day12 {

    struct Ship {
        var x: Int16 = 0
        var y: Int16 = 0
        var orientation: Cardinal = .east

        mutating func apply(move: Move) {
            switch move.kind {
            case .absolute(let cardinal):
                apply(cardinalMove: cardinal, value: move.value)
            case .rotate(let dir):
                rotate(direction: dir, value: move.value)
            case .forward:
                forward(value: move.value)
            }
        }

        mutating func apply(cardinalMove: Cardinal, value: UInt) {
            switch cardinalMove {
            case .north:
                y += Int16(value)
            case .south:
                y -= Int16(value)
            case .east:
                x += Int16(value)
            case .west:
                x -= Int16(value)
            }
        }

        mutating func rotate(direction: Move.Rotate, value: UInt) {
            let incr: Int
            switch direction {
            case .left:
                incr = Int(value) / 90
            case .right:
                incr = -(Int(value) / 90)
            }

            var newRawValue = (orientation.rawValue + incr) % 4
            if newRawValue < 0 { newRawValue += 4 }

            orientation = Cardinal(rawValue: newRawValue)!
        }

        mutating func forward(value: UInt) {
            apply(cardinalMove: orientation, value: value)
        }

        func manhattan() -> UInt16 {
            x.magnitude + y.magnitude
        }
    }

    enum Cardinal: Int {
        case east
        case north
        case west
        case south
    }

    struct Move {
        enum Rotate {
            case left
            case right
        }
        enum Kind {
            case absolute(Cardinal)
            case rotate(Rotate)
            case forward
        }
        let kind: Kind
        let value: UInt
    }

    public static func main() throws {
        let input = try String(contentsOfFile: "day12.txt", encoding: .utf8)
        let moves = try input.splitLines().map(parseMove(s:))


        print(compute1(moves: moves))
    }

    static func compute1(moves: [Move]) -> UInt16 {
        moves.reduce(Ship()) { ship, move in
            ship..{ $0.apply(move: move) }
        }.manhattan()
    }

    static func parseMove(s: String) throws -> Move {
        let kind: Move.Kind
        switch s.first! {
        case "N":
            kind = .absolute(.north)
        case "S":
            kind = .absolute(.south)
        case "W":
            kind = .absolute(.west)
        case "E":
            kind = .absolute(.east)
        case "L":
            kind = .rotate(.left)
        case "R":
            kind = .rotate(.right)
        case "F":
            kind = .forward
        default:
            throw Errors.unparseableInput(s)
        }
        guard let value = UInt(s.dropFirst()) else {
            throw Errors.unparseableInput(s)
        }
        return Move(kind: kind, value: value)
    }
}
