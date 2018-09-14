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
    private let preliminaryLetterWidthDetection = TrackingPreliminaryLetterWidthDetection()
    
    func find(from word: Word<LetterRectangle>) -> SimpleSuccess<TrackingRange> {
        let frames = fixedQuotesGaps(from: word)
        return find(gaps: frames)
    }
    
    //бывает такое что кавычки показаны как разные буквы, убираем гапы между кавычками
    private func fixedQuotesGaps(from word: Word<LetterRectangle>) -> [CGRect] {
        var gaps: [CGRect] = word.gaps.map { $0.frame }
        var alreadyRemovedCount = 0
        
        word.letters.forEachPairWithIndex { (left, right, index) in
            let completeWidthBetweenTwoLetter = right.frame.rightX - left.frame.leftX
            let isQuotes = word.frame.height / completeWidthBetweenTwoLetter >= 2.5
            if isQuotes {
                gaps.remove(at: index - alreadyRemovedCount)
                alreadyRemovedCount += 1
            }
        }
        return gaps
        
    }
    
   private func find(gaps: [CGRect]) -> SimpleSuccess<TrackingRange> {
        guard gaps.count > 1 else { return  .failure }
        let preliminaryAverageSize = preliminaryLetterWidthDetection.detect(gaps: gaps)

        let bigWidths = gaps.mapPair { abs($0.leftX - $1.rightX) }
        //минимальная ширина от левого края одного гапа до правого края следующего за ним гапа
        let minBigWidth = bigWidths.sorted { $0 < $1 }[0]
        let (lettersCount, _) = getCountAndMaxWidth(gaps, preliminaryAverageSize: preliminaryAverageSize)
        
        guard let firstGap = getCutedFirstGap(from: gaps, minBigWidth: minBigWidth),
            let lastGap = getCutedLastGap(from: gaps, minBigWidth: minBigWidth)
            else { return .failure }
        
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

    private func getCountAndMaxWidth(_ gaps: [CGRect], preliminaryAverageSize: CGFloat) -> (lettersCount: Int, maxWidth: CGFloat) {
        var biggestLetterWidth: CGFloat = 0
        var additionCount = 0
        gaps.forEach {
            let rate = $0.width / preliminaryAverageSize
            if rate > kLetterWidthRate { additionCount += 1 }
            else if rate > 2.8 { additionCount += 2 }
        }
        var widths: [CGFloat] = []
        gaps.forEachPair {
            let width = abs($0.rightX - $1.leftX)
            widths.append(width)
            if let number = additionalNumberIfStuck(width: width, preliminaryAverageSize: preliminaryAverageSize) {
                additionCount += number
            } else {
                biggestLetterWidth = max(biggestLetterWidth, width)
            }
        }
        let lettersCount = gaps.count - 1 + additionCount
        return (lettersCount, biggestLetterWidth)
    }
    
    ///если находит слипшуюся буквуб то тогда учитывает ее при подсчете
    private func additionalNumberIfStuck(width: CGFloat, preliminaryAverageSize: CGFloat) -> Int? {
        let rate = width / preliminaryAverageSize
        guard rate >= kLetterWidthRate else { return nil }
        let number = Int(rate.rounded()) - 1
        return number == 0 ? nil : number
    }
    
    private func getCutedFirstGap(from gaps: [CGRect], minBigWidth: CGFloat) -> CGRect? {
        guard gaps.count > 1 else { return gaps.first }
        return getCutedGap(outer: gaps[0], inner: gaps[1], minBigWidth: minBigWidth, edge: .minXEdge)
    }
    
    private func getCutedLastGap(from gaps: [CGRect], minBigWidth: CGFloat) -> CGRect? {
        let count = gaps.count
        guard count > 1 else { return gaps.first }
        let penultimate = gaps[count - 2]
        let last = gaps[count - 1]
        return getCutedGap(outer: last, inner: penultimate, minBigWidth: minBigWidth, edge: .maxXEdge)
    }
    
    private func getCutedGap(outer: CGRect, inner: CGRect, minBigWidth: CGFloat,
                             edge: CGRectEdge) -> CGRect? {
        let width = outer.width + minWidthBetween(left: outer, right: inner)
        
        if width < minBigWidth {
            return outer
        } else {
            let difference = width - minBigWidth
            guard difference <= outer.width else { return nil }
            let divider = outer.divided(atDistance: difference, from: edge)
            return divider.remainder
        }
    }
    
    func minWidthBetween(left: CGRect, right: CGRect) -> CGFloat {
        let distance1 = abs(left.leftX - right.rightX)
        let distance2 = abs(left.rightX - right.leftX)
        let distance = min(distance1, distance2)
        return distance
    }
    
    func maxWidthBetween(left: CGRect, right: CGRect) -> CGFloat {
        let distance1 = abs(left.leftX - right.rightX)
        let distance2 = abs(left.rightX - right.leftX)
        let distance = max(distance1, distance2)
        return distance
    }
    
    ///находит разницу между макс шириной между гапами и кастомной шириной
    private func getDiffernce(left: CGRect, right: CGRect, width: CGFloat) -> CGFloat {
        let distance = maxWidthBetween(left: left, right: right)
        let difference = distance - width
        return difference
    }
}
