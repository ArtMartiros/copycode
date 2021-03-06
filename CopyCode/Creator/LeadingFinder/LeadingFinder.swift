//
//  LeadingFinder.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingFinder {

    private let mostAccurateFinder = LeadingMostAccurateFinder()

    func find(_ block: Block<LetterRectangle>) -> Leading? {
        let newBlock = block.withOutAnomaly()
        let distanceFinder = LeadingDistanceFinder(block: newBlock)
        let startPointGenerator = LeadingStartPointGenerator()
        let spaceFinder = LeadingSpaceFinder(block: newBlock)

        guard let range = distanceFinder.find() else { return nil }

        let point = newBlock.simpleMaxLine().frame.topY
        let points = startPointGenerator.generate(from: point)
        let leadingErrors = points
            .map { spaceFinder.find(in: range, startPoint: $0)}
            .reduce([], +)
        return mostAccurateFinder.find(from: leadingErrors)
    }
}
