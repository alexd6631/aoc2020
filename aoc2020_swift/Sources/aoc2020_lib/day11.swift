//
//  day11.swift
//  aoc2020_lib
//
//  Created by Alexandre Delattre on 11/12/2020.
//

import Foundation

public enum Day11 {

    public static func main() throws {
        let input = try String(contentsOfFile: "day11.txt", encoding: .utf8)
        let grid = try parseGrid(from: input)

        print(compute1(grid: grid))
        print(compute2(grid: grid))
    }

    static func compute1(grid: Grid) -> Int {
        stabilize(grid: grid, stepFn: { $0.step() }).occupiedCount()
    }

    static func compute2(grid: Grid) -> Int {
        stabilize(grid: grid, stepFn: { $0.step2() }).occupiedCount()
    }

    static func stabilize(grid: Grid, stepFn: (inout Grid) -> ()) -> Grid {
        var current = grid
        while true {
            let next = current .. stepFn
            if next == current { return current }
            current = next
        }
    }


    static func parseGrid(from input: String) throws -> Grid {
        let data: [[Grid.Item]] = try input
            .splitLines()
            .map { line in try line.map(parseItem) }
        
        return Grid(data: data)
    }

    private static func parseItem(_ char: Character) throws -> Grid.Item {
        switch char {
        case "L":
            return Grid.Item.empty
        case "#":
            return Grid.Item.occupied
        case ".":
            return Grid.Item.floor
        default:
            throw Errors.unparseableInput(char.description)
        }
    }
    

    struct Grid : Equatable, CustomStringConvertible {
        enum Item {
            case empty
            case occupied
            case floor
        }
        var data: [[Item]]

        var rowRange: Range<Int> {
            data.indices
        }

        var colRange: Range<Int> {
            data[0].indices
        }

        func getItem(row: Int, col: Int) -> Item {
            guard let row = data[safe: row],
                  let item = row[safe: col] else { return .floor }
            return item
        }

        var description: String {
            data.map { row in
                row.map { item in
                    switch item {
                    case .empty:
                        return "L"
                    case .occupied:
                        return "#"
                    case .floor:
                        return "."
                    }
                }.joined()
            }.joined(separator: "\n")
        }
    }
}

private extension Day11.Grid {
    private func isOccupied(row: Int, col: Int) -> UInt8 {
        getItem(row: row, col: col) == .occupied ? 1 : 0
    }

    func occupiedNeighbors(row: Int, col: Int) -> UInt8 {
        var occupied: UInt8 = 0
        for dr in -1 ... 1 {
            for dc in -1 ... 1 {
                if (dr, dc) != (0, 0) {
                    occupied += isOccupied(row: row + dr, col: col + dc)
                }
            }
        }
        return occupied
    }

    func occupiedCount() -> Int {
        var occupied = 0
        for row in rowRange {
            for col in colRange {
                occupied += Int(isOccupied(row: row, col: col))
            }
        }
        return occupied
    }

    mutating func stepGrid(nextFn: (Int, Int) -> Item) {
        var newData = data
        for row in rowRange {
            for col in colRange {
                newData[row][col] = nextFn(row, col)
            }
        }
        data = newData
    }

    mutating func step() {
        stepGrid(nextFn: self.nextState(row:col:))
    }

    private func nextState(row: Int, col: Int) -> Item {
        let current = getItem(row: row, col: col)
        let neighbors = occupiedNeighbors(row: row, col: col)

        switch (current, neighbors) {
        case (.empty, 0):
            return .occupied
        case (.occupied, let n) where n >= 4:
            return .empty
        case (let state, _):
            return state
        }
    }
}

private extension Day11.Grid {
    private func isVisiblyOccupied(row: Int, col: Int, dr: Int, dc: Int) -> UInt8 {
        var row = row
        var col = col
        while true {
            row += dr
            col += dc
            if rowRange.contains(row) && colRange.contains(col) {
                switch getItem(row: row, col: col) {
                case .occupied:
                    return 1
                case .empty:
                    return 0
                default:
                    break
                }
            } else {
                return 0
            }
        }
    }

    func visiblyOccupiedNeighbors(row: Int, col: Int) -> UInt8 {
        var occupied: UInt8 = 0
        for dr in -1 ... 1 {
            for dc in -1 ... 1 {
                if (dr, dc) != (0, 0) {
                    occupied += isVisiblyOccupied(row: row, col: col, dr: dr, dc: dc)
                }
            }
        }
        return occupied
    }

    mutating func step2() {
        stepGrid(nextFn: self.nextState2(row:col:))
    }

    private func nextState2(row: Int, col: Int) -> Item {
        let current = getItem(row: row, col: col)
        let neighbors = visiblyOccupiedNeighbors(row: row, col: col)

        switch (current, neighbors) {
        case (.empty, 0):
            return .occupied
        case (.occupied, let n) where n >= 5:
            return .empty
        case (let state, _):
            return state
        }
    }

}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
