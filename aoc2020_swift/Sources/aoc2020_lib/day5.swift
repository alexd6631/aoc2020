import Foundation

public enum Day5 {
    enum Error: Swift.Error, Equatable {
        case invalidSpec(spec: String)
    }

    public static func main() throws {
        let seatSpecs = try validateSeatSpecs(readFileLines("day5.txt"))
        let seatIds = Set(seatSpecs.lazy.map(getSeatId(for:)))

        let min = seatIds.min()!
        let max = seatIds.max()!
        print("Part 1: \(max)")

        let missingSeat = (min ... max).first {
            !seatIds.contains($0)
        }!

        print("Part 2: \(missingSeat)")
    }

    static func validateSeatSpecs(_ lines: [String]) throws -> [String] {
        try lines.forEach {
            if $0.count != 10 {
                throw Error.invalidSpec(spec: $0)
            }
        }
        return lines
    }

    static func getSeatId(for spec: String) -> UInt {
        let rowSpec = spec.prefix(7)
        let colSpec = spec.suffix(3)

        let row = findInRange(128, rowSpec.map { $0 == "B" })
        let col = findInRange(8, colSpec.map { $0 == "R" })

        return row * 8 + col
    }
}

private func findInRange<S: Sequence>(_ max: UInt, _ specs: S) -> UInt where S.Element == Bool {
    let range = 0 ..< max

    return specs.reduce(range) { r, upper in
        upper ? r.upperHalf() : r.lowerHalf()
    }.lowerBound
}
