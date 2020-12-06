//
//  File.swift
//  
//
//  Created by Alexandre Delattre on 06/12/2020.
//

import Foundation
import Darwin

public func runMain(_ label: String, _ mainFn: () throws -> ()) {
    print("\(label) - started ")
    do {
        let startTime =  CFAbsoluteTimeGetCurrent()
        try mainFn()
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime

        print("\(label) - \(executionTime) seconds")
        print()
    } catch {
        fputs("\(label) - error: \(error.localizedDescription)\n", stderr)
    }
}
