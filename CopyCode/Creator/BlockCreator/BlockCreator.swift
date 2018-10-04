//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

protocol BlockCreatorProtocol {
    associatedtype Child: Rectangle
    func create(from rectangles: [Word<Child>]) -> [Block<Child>]
}

final class BlockCreator: BlockCreatorProtocol {
    
    private let missingElementsRestorer: MissingElementsRestorer
    private let leadingFinder = LeadingFinder()
    private let blockSplitter = BlockSplitter()
    private let trackingInfoFinder = TrackingInfoFinder()
    private let blockPreparator: BlockPreparator
    
    init(digitalColumnCreator: DigitColumnSplitter, elementsRestorer: MissingElementsRestorer) {
        self.blockPreparator = BlockPreparator(digitalColumnSplitter: digitalColumnCreator)
        self.missingElementsRestorer = elementsRestorer
    }
    
    func create(from rectangles: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {
        let blocks = blockPreparator.initialPrepare(from: rectangles)
        Timer.stop(text: "BlockCreator Initial Created")
        let trackingUpdatedBlocks = blocksUpdatedAfterTracking(blocks)
        Timer.stop(text: "BlockCreator Tracking Created")
        let leadingUpdatedBlocks = blocksUpdatedAfterLeading(trackingUpdatedBlocks)
        Timer.stop(text: "BlockCreator Leading Created")
        let restoredBlocks = leadingUpdatedBlocks.map { missingElementsRestorer.restore($0) }
        Timer.stop(text: "BlockCreator Restored")
        return Settings.includeMissingChars ? restoredBlocks : leadingUpdatedBlocks
    }
    
    private func blocksUpdatedAfterTracking(_ blocks: [Block<LetterRectangle>]) -> [Block<LetterRectangle>] {
        let newBlocks = blocks.map {
            let infos = trackingInfoFinder.find(from: $0)
            return blockSplitter.splitAndUpdate($0, by: infos)
            }.reduce([SimpleBlock](),+)
        return newBlocks
    }
    
    private func blocksUpdatedAfterLeading(_ blocks: [Block<LetterRectangle>]) -> [Block<LetterRectangle>] {
        var newBlocks: [Block<LetterRectangle>] = []
        for block in blocks {
            let leading = leadingFinder.find(block)
            let newBlock = Block.updateTypography(block, with: leading)
            newBlocks.append(newBlock)
        }
        return newBlocks
    }
    
}

extension BlockCreator {
    convenience init(in bitmap: NSBitmapImageRep) {
        let recognizer = WordRecognizer(in: bitmap)
        let columnDetection = DigitColumnDetection(recognizer: recognizer)
        let columnMerger = DigitColumnMerger()
        let columnCreator = DigitColumnSplitter(columnDetection: columnDetection, columnMerger: columnMerger)
        let restorer = MissingElementsRestorer(bitmap: bitmap)
        self.init(digitalColumnCreator: columnCreator, elementsRestorer: restorer)
    }
}
