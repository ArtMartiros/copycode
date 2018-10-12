//
//  TextRecognizerManager.swift
//  CopyCode
//
//  Created by Артем on 25/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class TextRecognizerManager {
    typealias TextCompletion = (_ bitmap: NSBitmapImageRep, _ blocks: [CompletedBlock], _ error: Error?) -> Void
    typealias TestTextCompletion = (_ bitmap: NSBitmapImageRep, _ words: [SimpleWord]) -> Void

    private let textDetection: TextDetection
    private let rectangleConverter: RectangleConverter
    
    init() {
        self.textDetection = TextDetection()
        self.rectangleConverter = RectangleConverter()
    }
    
    func testPerformReques(image: NSImage, completion: @escaping TestTextCompletion) {
        textDetection.performRequest(cgImage: image.toCGImage) {[weak self] (results, error) in
            guard let sself = self else { return }
            let bitmap = image.bitmap
            PixelConverter.shared.setSize(size: bitmap.size, pixelSize: bitmap.pixelSize)
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            completion(bitmap, wordsRectangles)
        }
    }
    
    func performRequest(image: NSImage, completion: @escaping TextCompletion) {
        textDetection.performRequest(cgImage: image.toCGImage) {[weak self] (results, error) in
            Timer.stop(text: "VNTextObservation Finded")
            guard let sself = self else { return }
            let restorer = LetterRestorer()
            
            let bitmap = image.bitmap
            print(bitmap.pixelSize)
            PixelConverter.shared.setSize(size: bitmap.size, pixelSize: bitmap.pixelSize)
            let blockCreator = BlockCreator(in: bitmap)
            let typeConverter = TypeConverter(in: bitmap)
            let wordRecognizer = WordRecognizer(in: bitmap)
            
            Timer.stop(text: "Bitmap Created")
            
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            Timer.stop(text: "WordRectangles Converted")
            
            let blocks = blockCreator.create(from: wordsRectangles)
            Timer.stop(text: "LetterRestorer restored")
            let restoredBlocks = blocks.map { restorer.restore($0) }
            Timer.stop(text: "BlockCreator created")
            
            let blocksWithTypes = restoredBlocks.map { typeConverter.convert($0) }
            Timer.stop(text: "TypeConverter Updated Type ")
            
//            for block in blocksWithTypes {
//                if case .grid(let grid) = block.typography {
//                    let value = CodableHelper.encode(block)
//
//                    print(value)
//                }
//            }
//            sself.printAllCustomLetters(from: blocksWithTypes)
            let completedBlocks = blocksWithTypes.map { wordRecognizer.recognize($0) }
            Timer.stop(text: "WordRecognizer Recognize")
            completion(bitmap, completedBlocks, error)
        }
    }
    
    private func printAllCustomLetters(from blocks: [SimpleBlock]) {
        let oneBlock = blocks.filter {
            if case .grid = $0.typography {
                return true
            } else {
                return false
            }
            }[0]
        
        
        
        var letters: [LetterWithPosition<LetterRectangle>] = []
        for (lineIndex, line) in oneBlock.lines.enumerated() {
            var index = 0
            for (wordIndex, word) in line.words.enumerated() {
                for (letterIndex, letter) in word.letters.enumerated() {
                    if letter.type == .custom {
                        let position = LetterWithPosition(l: lineIndex, w: wordIndex,
                                                          c: letterIndex, lineCharCount: index, letter: letter)
                        letters.append(position)
                    }
                    index += 1
 
                }
            }
        }
//        let words = oneBlock.lines.map { line in
//            line.words.filter {
//                $0.type == .same(type: .allCustom)
//            }
//            }.reduce([], +)
//
//        let letters = words.map { $0.letters }.reduce([], +)
        let value = CodableHelper.encode(letters)
        
        print(value)
    }
}

struct LetterWithPosition<T: Rectangle>: Codable {
    let l: Int
    let w: Int
    let c: Int
    let lineCharCount: Int
    let letter: T
    
    init(l: Int, w: Int, c: Int, lineCharCount: Int, letter: T) {
        self.l = l
        self.w = w
        self.c = c
        self.lineCharCount = lineCharCount
        self.letter = letter
    }
    
    init(position: SimpleLetterPosition, letter: T) {
        self.init(l: position.l, w: position.w, c: position.c,
                  lineCharCount: position.lineCharCount, letter: letter)
    }
}
