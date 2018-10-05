//
//  sc2_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc2_letter = [
    0: "private let trackingInfoFinder = TrackingInfoFinder()",
    1: "private let blockPreparator: BlockPreparator",
    2: "init(digitalColumnCreator: DigitColumnSplitter, elementsRestorer: MissingElementsRestorer) {",
    3: "self.blockPreparator = BlockPreparator(digitalColumnSplitter: digitalColumnCreator)",
    4: "self.missingElementsRestorer = elementsRestorer",
    5: "}",
    6: "func create(from rectangles: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {",
    7: "let blocks = blockPreparator.initialPrepare(from: rectangles)",
    8: "Timer.stop(text: \"BlockCreator Initial Created\")",
    9: "let trackingUpdatedBlocks = blocksUpdatedAfterTracking(blocks)",
    10: "Timer.stop(text: \"BlockCreator Tracking Created\")",
    11: "let leadingUpdatedBlocks = blocksUpdatedAfterLeading(trackingUpdatedBlocks)",
    12: "Timer.stop(text: \"BlockCreator Leading Created\")",
    13: "let restoredBlocks = leadingUpdatedBlocks.map { missingElementsRestorer.restore($0) }",
    14: "Timer.stop(text: \"BlockCreator Restored\")",
    15: "return restoredBlocks",
    16: "}",
    17: "private func blocksUpdatedAfterTracking(_ blocks: [Block<LetterRectangle>]) -> [Block<LetterRectangle>] {",
    18: "let newBlocks = blocks.map {",
    19: "let infos = trackingInfoFinder.find(from: $0)",
    20: "return blockSplitter.splitAndUpdate($0, by: infos)",
    21: "}.reduce([SimpleBlock](),+)",
    22: "return newBlocks",
    23: "}"
]
