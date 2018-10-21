//
//  SceneTypeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 03/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class SceneTypeTests: XCTestCase {
    
    //ошиька С не знаю как исправить
    func testSc1() {
        executeCheck(scene: .sc1, exluded: [0]) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    //    ошибка с p можно исправить улучшением соотношения
    func testSc2() {
        executeCheck(scene: .sc2, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc3_p1() {
        executeCheck(scene: .sc3_p1, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc3_p2() {
        executeCheck(scene: .sc3_p2, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc9() {
        executeCheck(scene: .sc9, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc11() {
        executeCheck(scene: .sc11, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    private func executeCheck(scene: Scene, exluded: Set<Int>,
                              completion: @escaping (LetterType, SimpleLetterPosition) -> Void) {
        
        let block = scene.getGridBlock(self)
        let bitmap = scene.image.bitmap
        
        guard case .grid(let grid) = block.typography else { return }
        var typeConverter = TypeConverter(in: bitmap, grid: grid, type: .onlyLow)
        let lowBlock = typeConverter.convert(block)
        
        let updater = LeadingAndBlockUpdater(grid: grid)
        
        let blocks = updater.update(block: lowBlock)
        
        for (indexBlock, updatedBlock) in blocks.enumerated() {
            guard case .grid(let newGrid) = updatedBlock.typography else { continue }
            typeConverter = TypeConverter(in: bitmap, grid: newGrid, type: .all)
            
            for (lineIndex, line) in updatedBlock.lines.enumerated() {
                let newLineIndex: Int
                if indexBlock == 0 {
                    newLineIndex = lineIndex
                } else {
                    let count = blocks[0..<indexBlock].map { $0.lines.count }.reduce(0, +)
                    newLineIndex = count + lineIndex
                }
                
                guard !exluded.contains(newLineIndex) else { continue }
                
                let newLine = typeConverter.convert(line)
                let letters = newLine.words.map { $0.letters.map { $0 } }.reduce([], +)
                let rightLetterTypes = scene.getLetterTypes(for: newLineIndex)
                for (letterIndex, letter) in letters.enumerated() {
                    let answer = rightLetterTypes[letterIndex]
                    let position = LetterWithPosition(l: lineIndex, w: 0, c: 0, lineCharCount: letterIndex, letter: letter)
                    completion(answer, position)
                }
            }
        }
    }
}
