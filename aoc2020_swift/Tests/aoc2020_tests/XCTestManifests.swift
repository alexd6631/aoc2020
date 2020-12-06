import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(aoc2020_swiftTests.allTests),
    ]
}
#endif
