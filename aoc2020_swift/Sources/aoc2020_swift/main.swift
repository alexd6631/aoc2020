import Foundation
import aoc2020_lib

let problems = [
    ("Day 1", Day1.main),
    ("Day 4", Day4.main),
    ("Day 5", Day5.main),
    ("Day 6", Day6.main),
    ("Day 7", Day7.main),
]

let runAll = true

if runAll {
    problems.forEach { (label, fn) in
        runMain(label, fn)
    }
} else {
    let (label, fn) = problems.last!
    runMain(label, fn)
}
