//
//  BlockCreatorTests.swift
//  CopyCodeTests
//
//  Created by Артем on 30/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
@testable import CopyCode

class BlockCreatorTests: XCTestCase {
    let textManager = TextRecognizerManager()
    func testThing() {
        let image = NSImage(named: .init("picColumnDetectTest"))    
        image?.lockFocus()
        let bitMap = NSBitmapImageRep(data: image!.tiffRepresentation!)
        let testSize = bitMap!.size
        image?.draw(in: CGRect(origin: .zero, size: testSize))
        image?.unlockFocus()
        
        textManager.performRequest(image: image!) { (bitmap, rectangles, error) in
            
        }
    }
    
    func testDigitColumnRecognizer() {
        let image = NSImage(named: .init("picDigitColumnP2"))
        textManager.performRequest(image: image!) { (bitmap, results, error) in
            let recognizer = WordRecognizer(in: bitmap)
            for result in results.sorted(by: { $0.frame.bottomY > $1.frame.bottomY }) {
                let word = recognizer.recognize(result, with: .allUpper)
                print("Bukaki \(word.value)")
                //                let number = Int(word.value.prefix(2))
                //                XCTAssertTrue(number != nil, "❌ expect number, instead \(word.value)")
                let letterRecognizer = LetterRecognizer(bitmap, rectangle: result)
                for letter in result.letters {
                    let char = letterRecognizer.recognize(from: letter as! LetterRectangle, with: .upper)
                    print("🔔:" + char.value)
                    
                    let _ = 1
                }
                //                let word = wordRecognizer.recognize(result, with: .allUpper)
                //                let _ = 1
            }
            let _ = 1
        }
    }
    
}
