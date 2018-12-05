//
//  PositionInfoFinder.swift
//  CopyCode
//
//  Created by Артем on 02/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension TrackingInfoFinder {
    /// Дает массив trackings для слов в одной линии с начальной и конечной точкой в которых есть эти trackings
    struct PositionInfoFinder {
        private let trackingFinder = TrackingFinder()
        private let checker = TrackingChecker()
        private let samenessChecker = WordHeightSamenessChecker()
        // swiftlint:disable nesting
        typealias IndexesAndTrackings = (indexes: SortedArray<Int>, trackings: [Tracking])

        func find(from lineWords: [SimpleWord]) -> [PositionInfo] {
            var posInfos: [PositionInfo] = []

            guard !lineWords.isEmpty else { return [] }
            let biggestWordIndex = lineWords.getBiggestWordIndex(excluded: [])
            let biggestWord = lineWords[biggestWordIndex]
            let biggestWordHeight = biggestWord.frame.height

            let trackings = trackingFinder.findTrackings(from: biggestWord)
            //слова "до" в обратном порядке
            let beforeBiggestWordArray = lineWords[0..<biggestWordIndex].enumerated().reversed()
            let before = getFittedTrackingsWithIndexes(words: beforeBiggestWordArray, with: trackings, wordHeight: biggestWordHeight)
            //слова "после", нужен именно такой порядок .enumerated().notReversed()[..<] потому что нужен индекс элемента
            let afterBiggestWordArray = Array(lineWords.enumerated().notReversed()[(biggestWordIndex + 1)..<lineWords.count])
            let after = getFittedTrackingsWithIndexes(words: afterBiggestWordArray, with: before.trackings, wordHeight: biggestWordHeight)

            var fittingWordsIndexes = SortedArray<Int>()
            fittingWordsIndexes.formUnion([biggestWordIndex] + after.indexes + before.indexes)

            let startX = lineWords[fittingWordsIndexes.first!].frame.leftX
            let lastX = lineWords[fittingWordsIndexes.last!].frame.rightX

            let posInfo = PositionInfo(startX: startX, lastKnowX: lastX, trackings: after.trackings)
            posInfos.append(posInfo)
            chunkBySequence(words: lineWords, usedIndexes: fittingWordsIndexes)
                .forEach { posInfos += find(from: $0) }

            return posInfos
        }

        private func getFittedTrackingsWithIndexes(words: [(offset: Int, element: SimpleWord)],
                                                   with trackings: [Tracking],
                                                   wordHeight: CGFloat) -> IndexesAndTrackings {
            var filteredTrackings = trackings
            var fittingWordsIndexes = SortedArray<Int>()
            guard !filteredTrackings.isEmpty else { return (fittingWordsIndexes, filteredTrackings) }

            for (index, word) in words {
                //если первое слово слишком маленькое, то тогда прерываем
                if index == 0 && !samenessChecker.check(wordHeight, with: word) {
                   break
                }

                if word.isQuoteWord(trackingWidth: filteredTrackings[0].width) {
                    continue
                }

                print("****************************W: \(index)*************************")
                let fittingTrackings = fitting(filteredTrackings, to: word)
                guard !fittingTrackings.isEmpty else { break }

                fittingWordsIndexes.insert(index)
                filteredTrackings = fittingTrackings
            }

            return (fittingWordsIndexes, filteredTrackings)
        }

        private func fitting(_ trackings: [Tracking], to word: SimpleWord) -> [Tracking] {
            let wordGaps = word.corrrectedGapsWithOutside()
            return trackings.filter {
                print("\n\n")
                guard let gaps = Gap.updatedOutside(wordGaps, with: $0.width), checker.check(gaps, with: $0).result
                    else { return false }
                return true
            }
        }

        private func chunkBySequence(words: [SimpleWord], usedIndexes: SortedArray<Int>) -> [[SimpleWord]] {
            var wordsArray = [[SimpleWord]]()
            if let first = usedIndexes.first, first != 0 {
                let array = Array(words[0..<usedIndexes.first!])
                wordsArray.append(array)
            }

            if let last = usedIndexes.last, last + 1 < words.count {
                let array = Array(words[(usedIndexes.last! + 1)..<words.count])
                wordsArray.append(array)
            }
            return wordsArray
        }
    }

    struct PositionInfo {
        let startX: CGFloat
        let lastKnowX: CGFloat
        let trackings: [Tracking]
    }

    struct WordHeightSamenessChecker {
        private let kErrorPercentRate: CGFloat = 35
        func check(_ first: CGFloat, with second: CGFloat) -> Bool {
          return EqualityChecker.check1(of: first, with: second, errorPercentRate: kErrorPercentRate)
        }

        func check(_ first: CGFloat, with word: SimpleWord) -> Bool {
            return check(first, with: word.frame.height)
        }
    }
}

extension Array where Element == SimpleWord {
    func getBiggestWordIndex(excluded: Set<Int>) -> Int {
        var biggestWordIndex = 0
        var biggestWidth: CGFloat = 0

        for (index, word) in enumerated() where !excluded.contains(index) {
            let width = word.frame.width
            if  width > biggestWidth {
                biggestWidth = width
                biggestWordIndex = index
            }
        }
        return biggestWordIndex
    }
}
