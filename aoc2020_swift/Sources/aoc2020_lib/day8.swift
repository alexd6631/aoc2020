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

        let res = findTerminated(jumps.lazy.map { jIndex in
            var newInstructions = instructions
            newInstructions[jIndex].type = .nop
            return newInstructions
        }) ?? findTerminated(nops.lazy.map { nIndex in
            var newInstructions = instructions
            newInstructions[nIndex].type = .jmp
            return newInstructions
        })

        return res
    }

    enum ProgramStatus {
        case loop
        case terminated
    }

    static func findTerminated<S: Sequence>(_ instructions:  S) -> Int? where S.Element == [Instruction] {
        instructions.map {
            runInstructions($0)
        }.first {
            $0.0 == .terminated
        }?.1
    }

    static func runInstructions(_ instructions:  [Instruction]) -> (ProgramStatus, Int) {
        var cpu = Cpu(acc: 0, pc: 0)
        var visited = Set<Int>(arrayLiteral: 0)

        while true {
            cpu.execute(instructions[cpu.pc])
            if visited.contains(cpu.pc) {
                return (.loop, cpu.acc)
            }
            visited.insert(cpu.pc)
            if cpu.pc >= instructions.count {
                return (.terminated, cpu.acc)
            }
        }
    }

    static func parseInstructions(_ input: String) throws -> [Instruction] {
        try input.splitLines().map { line in
            let parts = line.components(separatedBy: .whitespaces)
            let opType: Instruction.OpType
            guard let n = Int(parts[1]) else { throw Errors.unparseableInput(line) }
            switch parts[0]{
            case "nop":
                opType = .nop
            case "acc":
                opType = .acc
            case "jmp":
                opType = .jmp
            default:
                throw Errors.unparseableInput(line)
            }
            return Instruction(type: opType, n: n)
        }
    }

    struct Instruction {
        enum OpType {
            case nop
            case acc
            case jmp
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
    }
}
