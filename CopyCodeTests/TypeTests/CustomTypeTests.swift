//
//  CustomTypeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 03/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class CustomTypeTests: XCTestCase {


    func testSc2() {
        
        let bitmap = Scene.sc2.image.bitmap
        
        let typeConverter = TypeConverter(in: bitmap)
        let block = Scene.sc2.getGridBlock(self)
        
        for (lineIndex, line) in block.lines.enumerated() {
            
            let newLine = typeConverter.convert(line, typography: block.typography)
            let letters = newLine.words.map { $0.letters.map { $0.type } }.reduce([], +)
            print("Letters coun: \(letters.count)")
            let rightLetterTypes =  Scene.sc2.getLetterTypes(for: lineIndex)
            for (letterIndex, letter) in letters.enumerated() {
                let rightLetter = rightLetterTypes[letterIndex]
                XCTAssertEqual(letter, rightLetter, "Line: \(lineIndex), letter: \(letterIndex)")
            }
        }
        
    }

    func testSc1() {
        startTest(scene: .sc1)
    }
    
    func startTest(scene: Scene) {
        let bitmap = scene.image.bitmap
        
        let typeConverter = TypeConverter(in: bitmap)
        let block = scene.getGridBlock(self)
        
        for (lineIndex, line) in block.lines.enumerated() where lineIndex > 0 {
            
            let newLine = typeConverter.convert(line, typography: block.typography)
            let letters = newLine.words.map { $0.letters.map { $0.type } }.reduce([], +)
            print("Letters coun: \(letters.count)")
            let rightLetterTypes = scene.getLetterTypes(for: lineIndex)
            for (letterIndex, letter) in letters.enumerated() {
                let rightLetter = rightLetterTypes[letterIndex]
                XCTAssertEqual(letter, rightLetter, "Line: \(lineIndex), letter: \(letterIndex)")
            }
        }
    }

}
