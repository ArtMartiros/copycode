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
        textDetection.performRequest(cgImage: image.toCGImage) {[weak self] (results, _) in
            guard let sself = self else { return }
            let bitmap = image.bitmap
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            completion(bitmap, wordsRectangles)
        }
    }

    func performRequest(image: CGImage, retina: Bool, completion: @escaping TextCompletion) {
        textDetection.performRequest(cgImage: image) {[weak self] (results, error) in
            Timer.stop(text: "VNTextObservation Finded")
            guard let sself = self else { return }
            let bitmap = NSBitmapImageRep(cgImage: image)

            let restorer = LetterRestorer(bitmap: bitmap)
            let wordRecognizer = WordRecognizer(in: bitmap)
            let blockCreator = BlockCreator(in: bitmap)
            Timer.stop(text: "Bitmap Created")
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            wordsRectangles.toJSON().shouldPrint()
            Timer.stop(text: "WordRectangles Converted")
            if Settings.enableFirebase {
                GlobalValues.shared.wordRectangles = wordsRectangles
            }

            let blocks = blockCreator.create(from: wordsRectangles)

            let gridBlocks = sself.filterGrids(blocks)
            Timer.stop(text: "BlockCreator created")

            let blocksWithTypes = gridBlocks.compactMap { [weak self] in
                self?.detectTypeWithUpdatedLeading(in: bitmap, from: $0, retina: retina)
                }.reduce([], +)
            Timer.stop(text: "TypeConverter Updated Type ")

            let restoredBlocks = blocksWithTypes.map { restorer.restore($0) }
            Timer.stop(text: "LetterRestorer restored")

            let completedBlocks = restoredBlocks.map { wordRecognizer.recognize($0) }
            Timer.stop(text: "WordRecognizer Recognize")
//            let value = CodableHelper.encode(blocks[1])
//            print(value)
//            for block in restoredBlocks {
//                if case .grid( _) = block.typography {
//                    let value = CodableHelper.encode(block)
//                    print(value)
//                }
//            }
//                        sself.printAllCustomLetters(from: restoredBlocks)
            completion(bitmap, completedBlocks, error)
        }
    }

    func completedBlocks(from words: [SimpleWord], with bitmap: NSBitmapImageRep, retina: Bool) {
        let restorer = LetterRestorer(bitmap: bitmap)
        let wordRecognizer = WordRecognizer(in: bitmap)
        let blockCreator = BlockCreator(in: bitmap)
        if Settings.enableFirebase {
            GlobalValues.shared.wordRectangles = words
        }

        let blocks = blockCreator.create(from: words)

        let gridBlocks = filterGrids(blocks)
        Timer.stop(text: "BlockCreator created")
        gridBlocks[0].toJSON().shouldPrint()

        let blocksWithTypes = gridBlocks.compactMap { [weak self] in
            self?.detectTypeWithUpdatedLeading(in: bitmap, from: $0, retina: retina)
            }.reduce([], +)
        Timer.stop(text: "TypeConverter Updated Type ")

        let restoredBlocks = blocksWithTypes.map { restorer.restore($0) }
        Timer.stop(text: "LetterRestorer restored")
        for block in restoredBlocks {
            if case .grid( _) = block.typography {
//                printAllCustomLetters(from: [block])
                block.toJSON().shouldPrint()
            }
        }
        _ = restoredBlocks.map { wordRecognizer.recognize($0) }

    }

    private func filterGrids(_ blocks: [SimpleBlock]) -> [SimpleBlock] {
        guard Settings.filterBlock else { return blocks }
       return blocks.filter {
            switch $0.typography {
            case .grid: return true
            default: return false
            }
        }
    }

    private func detectTypeWithUpdatedLeading(in bitmap: NSBitmapImageRep, from block: SimpleBlock, retina: Bool) -> [SimpleBlock] {

        guard Settings.filterBlock else { return [block] }
        switch block.typography {

        case .grid(let grid):
            if Settings.showGrid { return [grid.getTestBlock(from: block)] }

            var typeConverter = TypeConverter(in: bitmap, grid: grid, type: .onlyLow)
            let blockWithLow = typeConverter.convert(block)
            let updater = LeadingAndBlockUpdater(grid: grid, isRetina: retina)
            let splittedBlocks = updater.update(block: blockWithLow)
            return splittedBlocks.compactMap {
                if case .grid(let grid) = $0.typography {

                    typeConverter = TypeConverter(in: bitmap, grid: grid, type: .all)
                    return typeConverter.convert($0)
                }
                return nil
            }

        default: return []

        }
    }
}

extension TextRecognizerManager {
    fileprivate func printAllCustomLetters(from blocks: [SimpleBlock]) {
        let oneBlock = blocks.filter {
            if case .grid = $0.typography { return true } else { return false }
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
        letters.toJSON().shouldPrint()
    }
}
