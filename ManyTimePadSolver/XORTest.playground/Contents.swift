//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let test = [UInt8]("👶🏻".utf8)

let text = [UInt8]("hello!!!".utf8)
let cipher = [UInt8]("goodbye!".utf8)

var encrypted = [UInt8]()

// encrypt bytes
for (index, number) in text.enumerated() {
    encrypted.append(number ^ cipher[index])
}

var decrypted = [UInt8]()

// decrypt bytes
for (index, number) in encrypted.enumerated() {
    decrypted.append(number ^ cipher[index])
}

String(bytes: decrypted, encoding: .utf8) // hello!!!


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
        return intArray.map({String(format:"%02x", $0)}).joined()
    }
    
    static func encrypt(_ plaintext: String, with hexKey: String) -> String {
        let ptInts = [UInt8](plaintext.utf8)
        let keyInts = intArrayFrom(hexString: hexKey)
        let ciphertextInts = XORArrays(arr1: ptInts, arr2: keyInts)
        return hexStringFrom(intArray: ciphertextInts)
    }
    
    static func encryptAll(_ plaintexts: [String], with hexKey: String) -> [String] {
        return plaintexts.map({encrypt($0, with: hexKey)})
    }
}

let plaintexts = [
    "The secret recipe is: Flour, Water, MSG",
    "Please don't tell anyone the following secret",
    "The secret password is 1234",
    "Nobody should see this message",
    "I am going to tell you something very important"
]

dump(XORUtil.encryptAll(plaintexts, with: "5e3ecd6fdde3bfd9ba037a5bd819537c7cba92b56b2b0a01d6"))