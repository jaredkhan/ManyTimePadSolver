//
//  ConsoleIO.swift
//  ManyTimePadSolver
//
//  Created by Jared Khan on 23/10/2016.
//  Copyright © 2016 Jared Khan. All rights reserved.
//

import Foundation
class ConsoleIO {
    enum LineAction {
        case edit
        case cancel
        case advance(Int)
    }
    
    enum EditAction {
        case guess(String)
        case cancel
    }
    
    enum OutputStream {
        case error
        case standard
    }
    
    func write(_ message: String, to stream: OutputStream = .standard) {
        switch stream {
        case .standard:
            // Output with standard colour
            print("\u{001B}[;m\(message)")
        case .error:
            // Output with red (0;31m) colour
            fputs("\u{001B}[0;31m\(message)\n", stderr)
        }
    }
    
    func getLineNumber(maximum: Int) -> Int {
        print("Select a line number: ")
        while true {
            if let input = readLine() {
                if let index = Int(input) {
                    if index < maximum {
                        return index
                    }
                }
            }
        }
    }
    
    func getLineAction() -> LineAction {
        while true {
            let input = readLine()
            if let index = Int(input!) {
                return LineAction.advance(index)
            }
            else if let actionString = input {
                if actionString == "x" {
                    return LineAction.cancel
                } else if actionString == "" {
                    return LineAction.edit
                }
            }
        }
    }
    
    func getEditAction() -> EditAction {
        while true {
            let input = readLine()
            if let actionString = input {
                if actionString.count > 0 {
                    return EditAction.guess(actionString)
                } else {
                    return EditAction.cancel
                }
            }
        }
    }
}
