import Foundation
import aoc2020_lib

let problems = [
    ("Day 1", Day1.main),
    ("Day 4", Day4.main),
    ("Day 5", Day5.main),
    ("Day 6", Day6.main),
    ("Day 7", Day7.main),
    ("Day 8", Day8.main),
    ("Day 9", Day9.main),
    ("Day 10", Day10.main),
    ("Day 11", Day11.main),
    ("Day 12", Day12.main),
]

let runAll = false

if runAll {
    problems.forEach { (label, fn) in
        runMain(label, fn)
    }
} else {
    let (label, fn) = problems.last!
    runMain(label, fn)
}
