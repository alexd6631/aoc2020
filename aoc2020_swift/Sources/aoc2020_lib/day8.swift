//
//  day8.swift
//  aoc2020_lib
//
//  Created by Alexandre Delattre on 08/12/2020.
//

import Foundation

public enum Day8 {
    public static func main() throws {
        let input = try String(contentsOfFile: "day8.txt", encoding: .utf8)
        let instructions = try parseInstructions(input)

        print(compute1(instructions))
        print(compute2(instructions)!)
    }

    static func compute1(_ instructions:  [Instruction]) -> Int {
        runInstructions(instructions).1
    }

    static func compute2(_ instructions:  [Instruction]) -> Int? {
        let jumps: [Int] = instructions.enumerated().compactMap { (i, inst) in
            if case .jmp = inst.type { return i } else { return nil }
        }

        let nops: [Int] = instructions.enumerated().compactMap { (i, inst) in
            if case .nop = inst.type { return i } else { return nil }
        }

        let res = findTerminating(jumps.lazy.map { jIndex in
            var newInstructions = instructions
            newInstructions[jIndex].type = .nop
            return newInstructions
        }) ?? findTerminating(nops.lazy.map { nIndex in
            var newInstructions = instructions
            newInstructions[nIndex].type = .jmp
            return newInstructions
        })

        return res
    }

    static func findTerminating<S: Sequence>(_ instructions:  S) -> Int? where S.Element == [Instruction] {
        instructions
            .map { runInstructions($0) }
            .first { $0.0 }?.1
    }

    static func runInstructions(_ instructions:  [Instruction]) -> (Bool, Int) {
        var cpu = Cpu(acc: 0, pc: 0)
        return cpu.runInstructions(instructions)
    }

    static func parseInstructions(_ input: String) throws -> [Instruction] {
        try input.splitLines().map { line in
            let parts = line.components(separatedBy: .whitespaces)
            
            guard let opType = Instruction.OpType.from(string: parts[0]),
                  let n = Int(parts[1]) else { throw Errors.unparseableInput(line) }

            return Instruction(type: opType, n: n)
        }
    }

    struct Instruction {
        enum OpType {
            case nop
            case acc
            case jmp

            static func from(string: String) -> OpType? {
                switch string{
                case "nop":
                    return .nop
                case "acc":
                    return .acc
                case "jmp":
                    return .jmp
                default:
                    return nil
                }
            }
        }

        var type: OpType
        let n: Int
    }

    struct Cpu {
        var acc: Int
        var pc: Int

        mutating func execute(_ instruction: Instruction) {
            switch instruction.type {
            case .nop:
                pc += 1
            case .acc:
                acc += instruction.n
                pc += 1
            case .jmp:
                pc += instruction.n
            }
        }

        mutating func runInstructions(_ instructions:  [Instruction]) -> (Bool, Int) {
            var visited = [Bool](repeating: false, count: instructions.count)

            while pc < instructions.count {
                if visited[pc] { return (false, acc) }
                visited[pc] = true

                execute(instructions[pc])
            }

            return (true, acc)
        }
    }
}
