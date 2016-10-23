//
//  xor.swift
//  ManyTimePadSolver
//
//  Created by Jared Khan on 01/10/2016.
//  Copyright © 2016 Jared Khan. All rights reserved.
//

import Foundation

class XORUtil {
    /**
     Creates an array of UInt8s from a hex representation
     */
    static func intArrayFrom(hexString: String) -> [UInt8] {
        var result = [UInt8]()
        var remainingHexString = hexString
        
        while remainingHexString.characters.count >= 2 {
            let range = remainingHexString.startIndex ..< remainingHexString.characters.index(remainingHexString.startIndex, offsetBy: 2)
            let firstTwo = remainingHexString[range]
            let ASCIICode = UInt8(strtoul(firstTwo, nil, 16)) // convert the two char hex string to an int
            result.append(ASCIICode)
            remainingHexString = String(remainingHexString.characters.dropFirst(2))
        }
        return result
    }
    
    static func XORArrays(arr1: [UInt8], arr2: [UInt8]) -> [UInt8]{
        var result = [UInt8]()
        let bound = min(arr1.count, arr2.count)
        for j in 0 ..< bound {
            result.append(arr1[j] ^ arr2[j]) // XORing happens here
        }
        return result
    }
    
    static func hexStringFrom(intArray: [UInt8]) -> String {
        return intArray.map({String(format:"%2x", $0)}).joined()
    }
    
    static func encrypt(_ plaintext: String, with hexKey: String) -> String {
        let ptInts = [UInt8](plaintext.utf8)
        let keyInts = intArrayFrom(hexString: hexKey)
        let ciphertextInts = XORArrays(arr1: ptInts, arr2: keyInts)
        return hexStringFrom(intArray: ciphertextInts)
    }
}

// Check if an integer corresponds to an alphabetical character
extension UInt8 {
    func isAlpha() -> Bool {
        return ((self >= 65 && self <= 90) || (self >= 97 && self <= 122))
    }
    
    func isDigit() -> Bool {
        return (self >= 48 && self <= 57)
    }
    
    func isCommonPunctuation() -> Bool {
        let common = ".,'\"?!(): "
        let commonCodes = [UInt8](common.utf8)
        return commonCodes.contains(self)
    }
    
    func isCommonCharacter() -> Bool {
        return (self.isAlpha() || self.isDigit() || self.isCommonPunctuation())
    }
}

extension Character {
    func unicodeScalarCodePoint() -> UInt8
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return UInt8(scalars[scalars.startIndex].value)
    }
}

















