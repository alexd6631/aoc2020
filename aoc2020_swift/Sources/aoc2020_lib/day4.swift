//
// Created by Alexandre Delattre on 04/12/2020.
//

import Foundation

public enum Day4 {
    public static func main() throws {
        let passports = parseInput(input: try String(contentsOfFile: "day4.txt", encoding: .utf8))

        let nComplete = passports.lazy.filter { $0.hasAllFields() }.count
        print("Part 1: \(nComplete)")

        let nValids = passports.lazy.filter { $0.isValid() }.count
        print("Part 2: \(nValids)")
    }

    fileprivate struct Passport {
        let data: [String: String]

        func hasAllFields() -> Bool {
            requiredFields.allSatisfy { data.keys.contains($0) }
        }

        func isValid() -> Bool {
            hasAllFields()
                && validByr()
                && validIyr()
                && validEyr()
                && validHgt()
                && validHcl()
                && validEcl()
                && validPid()
        }

        private func validDate(key: String, in range: ClosedRange<Int>) -> Bool {
            guard let date = data[key],
                  let dateInt = Int(date) else { return false }
            return range.contains(dateInt)
        }

        func validByr() -> Bool {
            validDate(key: "byr", in: 1920...2002)
        }

        func validIyr() -> Bool {
            validDate(key: "iyr", in: 2010...2020)
        }

        func validEyr() -> Bool {
            validDate(key: "eyr", in: 2020...2030)
        }

        func validHgt() -> Bool {
            guard let hgt = data["hgt"],
                  let hgtInt = Int(hgt.dropLast(2)) else { return false }
            if hgt.hasSuffix("cm") {
                return (150...193).contains(hgtInt)
            } else if hgt.hasSuffix("in") {
                return (59...76).contains(hgtInt)
            } else {
                return false
            }
        }

        func validHcl() -> Bool {
            guard let hcl = data["hcl"],
                  hcl.count == 7,
                  hcl.first! == "#" else { return false }

            return hcl.dropFirst().allSatisfy {
                digits.contains($0) || alphas.contains($0)
            }
        }

        func validEcl() -> Bool {
            guard let ecl = data["ecl"] else { return false }
            return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(ecl)
        }

        func validPid() -> Bool {
            guard let pid = data["pid"],
                  pid.count == 9 else { return false }

            return pid.allSatisfy {
                digits.contains($0)
            }
        }
    }

    private static let requiredFields = [
        "byr",
        "iyr",
        "eyr",
        "hgt",
        "hcl",
        "ecl",
        "pid"
    ]

    private static let alphas: ClosedRange<Character> = ("a"..."f")
    private static let digits: ClosedRange<Character> = ("0"..."9")

    private static func parseInput(input: String) -> [Passport] {
        input.components(separatedBy: "\n\n").map { passport in
            let parts = passport.components(separatedBy: .whitespacesAndNewlines)
            return Passport(data: Dictionary(uniqueKeysWithValues: parts.lazy.map { pair in
                let parts = pair.components(separatedBy: ":")
                return (parts[0], parts[1])
            }))
        }
    }


}

