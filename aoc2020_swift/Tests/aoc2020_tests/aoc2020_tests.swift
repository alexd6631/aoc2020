import XCTest
import class Foundation.Bundle
@testable import aoc2020_lib

final class aoc2020_TestsDay1: XCTestCase {
    func testCompute() throws {
        let input: [UInt] = [
            1721,
            979,
            366,
            299,
            675,
            1456
        ]

        XCTAssertEqual(Day1.compute1(numbers: input), 514579)
        XCTAssertEqual(Day1.compute2(numbers: input), 241861950)
    }
}


final class aoc2020_TestsDay5: XCTestCase {
    func testGetSeatId() throws {
        let inputs = [
            "FBFBBFFRLR",
            "BFFFBBFRRR",
            "FFFBBBFRRR",
            "BBFFBBFRLL"
        ]

        let outputs = inputs.map(Day5.getSeatId(for:))

        XCTAssertEqual(outputs, [
            357, 567, 119, 820
        ])
    }
}


final class aoc2020_TestsDay6: XCTestCase {
    func testDay6() throws {
        let input = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

        let data = Day6.parseInput(input)
        XCTAssertEqual(Day6.compute1(data), 11)
        XCTAssertEqual(Day6.compute2(data), 6)
    }
}



final class aoc2020_TestsDay7: XCTestCase {
    func testDay7() throws {
        
    }
}
