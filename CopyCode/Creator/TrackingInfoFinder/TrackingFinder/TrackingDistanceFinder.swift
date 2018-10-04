//
//  TrackingDistanceFinder.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingDistanceFinder {
    //если gap слишком большой
    private var kLetterWidthRate: CGFloat = 0.8
    //если две буквы слиплись
    private let kLetterWidthStuckRate: CGFloat = 1.4
    private let kMinimumAmountOfGapsIncludedOutside = 4
    private let preliminaryLetterWidthDetection = TrackingPreliminaryLetterWidthDetection()
    
    func find(from word: Word<LetterRectangle>) -> SimpleSuccess<TrackingRange> {
        let gaps = word.fixedGapsWithOutside
        guard gaps.count >= kMinimumAmountOfGapsIncludedOutside else { return .failure }
        let result = find(gaps: gaps)
        return result
    }
    
    private func find(gaps: [CGRect]) -> SimpleSuccess<TrackingRange> {
        let insidedGaps = Array(gaps[1..<gaps.count - 1])
        let preliminaryAverageSize = preliminaryLetterWidthDetection.detect(gaps: insidedGaps)
        
        let bigWidths = gaps.mapPair { abs($0.leftX - $1.rightX) }
        //минимальная ширина от левого края одного гапа до правого края следующего за ним гапа
        let minBigWidth = bigWidths.sorted { $0 < $1 }[0]
        
        guard let newGaps = Gap.updatedOutside(gaps, with: minBigWidth),
            let firstGap = newGaps.first,
            let lastGap = newGaps.last
            else { return .failure }

        let lettersCount = getCount(newGaps, with: preliminaryAverageSize)

        let count = CGFloat(lettersCount)
        let minDistance = abs(firstGap.rightX - lastGap.leftX) / count
        let maxDistance = abs(firstGap.leftX - lastGap.rightX) / count
        
        //дистанция не может быть меньше maxLetterWidth
        //        let start = max(minDistance, maxLetterWidth)
        //дистанция не может быть больше minBigWidth
        let end = min(maxDistance, minBigWidth)
        
        guard minDistance <= end + 1 else { return .failure }
        
        return .success(rangeOf(one: minDistance, two: maxDistance))
    }
    
    private func getCount(_ gaps: [CGRect], with preliminaryAverageSize: CGFloat) -> Int {
        var additionCount = 0
        gaps.forEach {
            let rate = $0.width / preliminaryAverageSize
            if rate > kLetterWidthRate { additionCount += 1 }
            else if rate > 2.8 { additionCount += 2 }
        }

        gaps.forEachPair {
            let width = abs($0.rightX - $1.leftX)
            if let number = additionalNumberIfStuck(width: width, preliminaryAverageSize: preliminaryAverageSize) {
                additionCount += number
            }
        }
        let lettersCount = gaps.count - 1 + additionCount
        return lettersCount
    }
    
    ///если находит слипшуюся буквуб то тогда учитывает ее при подсчете
    private func additionalNumberIfStuck(width: CGFloat, preliminaryAverageSize: CGFloat) -> Int? {
        let rate = width / preliminaryAverageSize
        guard rate >= kLetterWidthRate else { return nil }
        let number = Int(rate.rounded()) - 1
        return number == 0 ? nil : number
    }
}
