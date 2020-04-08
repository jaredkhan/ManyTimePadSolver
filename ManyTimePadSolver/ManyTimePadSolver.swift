//
//  ManyTimePadSolver.swift
//  ManyTimePadSolver
//
//  Created by Jared Khan on 23/10/2016.
//  Copyright © 2016 Jared Khan. All rights reserved.
//

import Foundation
class ManyTimePadSolver {
    let consoleIO = ConsoleIO()
    let ciphertexts: [String]
    var intArrays: [[UInt8]]
    let minCipherLength: Int
    var key: [UInt8]
    var XORMatrix: [[[UInt8]]]
    var results: [[UInt8]]
    
    init(ciphertexts givenCiphertexts: [String]) {
        ciphertexts = givenCiphertexts
        
        // Initialise intArrays
        intArrays = [[UInt8]]()
        for ciphertext in ciphertexts {
            intArrays.append(XORUtil.intArrayFrom(hexString: ciphertext))
        }
        
        //Initialise key
        minCipherLength = intArrays.map({$0.count}).min()!
        key = [UInt8](repeating: 0, count: minCipherLength)
        
        // Initialise xor matrix
        XORMatrix = [[[UInt8]]]()
        for _ in 0 ..< ciphertexts.count {
            XORMatrix.append([[UInt8]](repeating: [UInt8](), count: ciphertexts.count))
        }
        
        // Initialise result array
        results = [[UInt8]]()
        
        // GENERATE 2D ARRAY xors
        // Form: XORMatrix[a][b] is the xor of ciphertext[a] with ciphertext[b] (note symmetry)
        for (i, ct1) in intArrays.enumerated() {
            // XOR ciphertext with all others, store in xors[index]
            for j in (i + 1) ..< intArrays.count {
                let ct2 = intArrays[j]
                let result = XORUtil.XORArrays(arr1: ct1, arr2: ct2)
                
                XORMatrix[i][j]=result
                XORMatrix[j][i]=result
            }
        }
    }
    
    
    // apply the given key to the given cipherText
    static func applyKey(_ ciphertext: [UInt8], key: [UInt8]) -> [UInt8]{
        var resultInts = [UInt8]()
        for (i, int) in key.enumerated() {
            if (i < ciphertext.count) {
                resultInts.append(int ^ ciphertext[i])
            }
        }
        return resultInts
    }
    
    // Take an integer array of unicode scalar code points and print the string
    func stringFromIntArray(_ arr: [UInt8], offset: Int) -> String {
        
        var charArray = [Character]()
        for (i, int) in arr.enumerated() {
            if key[i + offset] == 0 {
                // The key hasn't been set at this location
                // Output placeholder rather than confusing encrypted character
                charArray.append("•")
            } else {
                charArray.append(Character(UnicodeScalar(Int(int))!))
            }
        }
        return String(charArray)
    }
    
    // apply a single character guess
    func applyGuess(_ characterIndex: Int, ciphertextIndex: Int, guess: Character) {
        let ASCIICode = guess.unicodeScalarCodePoint()
        let newKeyElement = ASCIICode ^ intArrays[ciphertextIndex][characterIndex]
        key[characterIndex] = newKeyElement
        // apply key to all relevant points in the resultArrays
        for i in 0 ..< results.count {
            let newResultElement = intArrays[i][characterIndex] ^ key[characterIndex]
            results[i][characterIndex] = newResultElement
        }
    }
    
    // apply a string guess
    func applyGuess(characterIndex: Int, ciphertextIndex: Int, guess: String) {
        var guess = guess
        var characterIndex = characterIndex
        while guess.count > 0 {
            applyGuess(characterIndex, ciphertextIndex: ciphertextIndex, guess: guess.first!)
            guess = String(guess.dropFirst())
            characterIndex = characterIndex + 1
        }
    }
    
    // Output a single result array, given its index
    func outputResult(_ index: Int, offset: Int) {
        let remaining = Array(results[index].dropFirst(offset))
        if index < results.count {
            print("\(stringFromIntArray(remaining, offset: offset))\n");
            // REPORT the bug: passing an array slice here causes a segmentation fault
        }
    }
    
    // Output all the result arrays, numbered
    func outputResults() {
        for (i, result) in results.enumerated() {
            print("\(i): \(stringFromIntArray(result, offset: 0))\n")
        }
    }
    
    // The interactive mode entered for users to make guesses
    func interactiveMode() {
        
        // Analyse for spaces
        for (i, XORList) in XORMatrix.enumerated() {
            // filter down list of candidates for spaces
            var isSpaceCandidate = [Bool](repeating: true, count: minCipherLength)
            for (j, XOR) in XORList.enumerated() {
                if (i != j) {
                    for (k, candidate) in isSpaceCandidate.enumerated() {
                        if candidate{
                            if !XOR[k].isAlpha() {
                                // The XOR resulted in a non alphabetical character.
                                // If a space belonged in this position then alphabetical
                                // characters would remain alphabetical.
                                // This is a property of the ASCII value of the space character
                                isSpaceCandidate[k] = false
                            }
                        }
                    }
                }
            }
            // apply knowledge to key
            for (j, candidate) in isSpaceCandidate.enumerated() {
                if candidate {
                    // If we got to here then assume this is a space
                    // (false positives possible when it so happens that the xors all result in alphas,
                    // false negs happen when not all adjacent characters are alpha)
                    // space decimal code is 32
                    key[j] = 32 ^ intArrays[i][j]
                }
            }
        }
        
        // Setup result array with new knowledge
        for intArray in intArrays {
            results.append(ManyTimePadSolver.applyKey(intArray, key: key))
        }
        
        // Enter interactive mode and take guesses
        overviewMode: while true { // Keep overview mode alive
            outputResults()
            let line = consoleIO.getLineNumber(maximum: results.count)
            var offset = 0
            lineMode: while true { // Keep line mode alive
                
                outputResult(line, offset: offset)
                consoleIO.write("Press enter to edit or type a number to advance along the string")
                
                let lineAction = consoleIO.getLineAction()
                
                switch lineAction {
                case .cancel:
                    continue overviewMode
                case .advance(let x):
                    offset = offset + x
                    continue lineMode
                case .edit:
                    editMode: while true {
                        outputResult(line, offset: offset)
                        print("Type a guess or press enter to cancel")
                        let editAction = consoleIO.getEditAction()
                        switch editAction {
                        case .cancel:
                            continue lineMode
                        case .guess(let str):
                            applyGuess(characterIndex: offset, ciphertextIndex: line, guess: str)
                            continue overviewMode
                        }
                    }
                }
            }
        }
    }
}
