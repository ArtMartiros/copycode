//
//  TrackingPreliminaryLetterWidthDetection.swift
//  CopyCode
//
//  Created by Артем on 07/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension TrackingDistanceFinder {
    struct TrackingPreliminaryLetterWidthDetection {
        
        func detect(gaps: [CGRect]) -> CGFloat {
            let sortedGaps = gaps.sorted { $0.leftX < $1.leftX  }
            let smallestGap = sortedGaps[0]
            let chunckedArrayOfDictionaries = sortedGaps.chunkForSorted { $0.width == $1.width }
            var updatedRange = rangeOfNearest(from: gaps, smallestGap: smallestGap)
            
            for array in chunckedArrayOfDictionaries {
                //находит ближайшие элементы к образцовому элементу
                let sortedArray = array
                    .sorted { findClosestDistance($0, second: smallestGap) < findClosestDistance($1, second: smallestGap) }
                for gapItem in sortedArray {
                    if gapItem.leftX != smallestGap.leftX {
                        if let newRange = getUpdatedRange(gapItem, smallestItem: smallestGap, distance: updatedRange) {
                            updatedRange = updatedRange.clamped(to: newRange)
                            //                        print("updatedRange \(updatedRange)")
                            //                        print("newRange \(newRange)")
                            //                        print("*****************\n")
                        }
                    }
                }
            }
            
            let mediumValue = (updatedRange.lowerBound + updatedRange.upperBound) / 2
            return mediumValue
        }
        
        private func rangeOfNearest(from gaps: [CGRect], smallestGap: CGRect ) -> TrackingRange {
            var nearGaps = gaps.sorted {
                findClosestDistance($0, second: smallestGap) < findClosestDistance($1, second: smallestGap)
            }
            //FIXME
            //может быть слипшиеся исправь
            let gapToCheck = nearGaps[1]
            
            let distance1 = abs(gapToCheck.leftX - smallestGap.rightX)
            let distance2 = abs(gapToCheck.rightX - smallestGap.leftX)
            let rangeFromNearestGap = rangeOf(one: distance1, two: distance2)
            return rangeFromNearestGap
        }
        
        private func findClosestDistance(_ first: CGRect, second: CGRect ) -> CGFloat {
            let one = abs(first.leftX - second.leftX)
            let two = abs(first.rightX - second.leftX)
            let three = abs(first.leftX - second.rightX)
            let four = abs(first.rightX - second.rightX)
            return min(min(one, two), min(three, four))
        }
        
        
        /// уточняет дистанцию range для того чтобы построить длину от smallestItem до item
        private func getUpdatedRange(_ item: CGRect, smallestItem: CGRect, distance range: TrackingRange) -> TrackingRange? {
            let firstWidth = abs(smallestItem.leftX - item.rightX)
            let secondWidth = abs(smallestItem.leftX - item.leftX)
            let smallWidth = min(firstWidth, secondWidth)
            let bigWidth = max(firstWidth, secondWidth)
            
            let smallestValue = range.upperBound == 0 ? 0 : smallWidth / range.upperBound
            let biggestValue = range.lowerBound == 0 ? 0 : bigWidth / range.lowerBound
            
            guard smallestValue < biggestValue else { return nil }
            
            let integers = (smallestValue...biggestValue).integers
            guard let first = integers.first, let last = integers.last else { return nil }
            
            let upperBound = bigWidth / CGFloat(first)
            let lowerBound = smallWidth / CGFloat(last)
            return lowerBound...upperBound
        }
    }
    
}
