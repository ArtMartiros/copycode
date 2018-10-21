//
//  TrackingInfoFinder.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingInfoFinder {
    typealias SplittedWords = (biggestWord: Word<LetterRectangle>, otherWords: [Word<LetterRectangle>])
    private let trackingFinder = TrackingFinder()
    private let posFinder = TrackingPosInfoFinder()
    private let checker = TrackingChecker()
    private let preliminaryChecker = PreliminaryTrackingChecker()

    func find(from block: Block<LetterRectangle>) -> [TrackingInfo] {
        var trackingInfos: [TrackingInfo] = []

        for (lineIndex, line) in block.lines.enumerated() {
            guard shouldStartSearching(in: lineIndex, with: trackingInfos)
                else { continue }
            let trackingInfo = completeFindTrackingInfo(in: line, with: lineIndex, lines: block.lines)
            trackingInfos.append(trackingInfo)
        }
        trackingInfos = sumSequenceOfNil(trackingInfos)
        return trackingInfos
    }

    private func completeFindTrackingInfo(in line: SimpleLine, with currentLineIndex: Int, lines: [SimpleLine]) -> TrackingInfo {

        var posInfos = posFinder.find(from: line.words)
        posInfos.sort { $0.startX < $1.startX }

        guard let posInfo = posInfos.first, !posInfo.trackings.isEmpty
            else { return TrackingInfo(startIndex: currentLineIndex, endIndex: currentLineIndex) }

        var forbiddens: [Int: CGFloat] = [:]
        if posInfos.count > 1 {
            forbiddens[currentLineIndex] = posInfos[1].startX
        }

        let trackings = posInfo.trackings.map { TrackingError(tracking: $0, errorRate: 0) }
        let trackingInfo = findTrackingInfo(in: lines, startIndex: currentLineIndex,
                                            forbiddens: forbiddens, trackings: trackings)

        return trackingInfo
    }

    private func findTrackingInfo(in lines: [SimpleLine], startIndex: Int, forbiddens: Forbidden,
                                  trackings: [TrackingError]) -> TrackingInfo {
        var lineTrackings = trackings
        var lastIndex = startIndex
        var forbiddens = forbiddens

        lineLoop: for (lineIndex, line) in lines.enumerated() where startIndex < lineIndex {
            print("lineIndex \(lineIndex)\n\n")
            let words = line.words
            var wordTrackings = lineTrackings

            wordLoop: for wordIndex in words.indices {
                print("wordIndex \(wordIndex)\n")

                let type = checkType(lines, lineIndex: lineIndex, wordIndex: wordIndex, with: wordTrackings)
                switch type {
                case .split: break lineLoop
                case .sum(updatedTrackings: let trackings): wordTrackings = trackings
                case .forbidden(x: let x):
                    forbiddens[lineIndex] = x
                    break wordLoop
                }
            }
            lineTrackings = wordTrackings
            lastIndex = lineIndex
        }

        let info = getTrackingInfo(from: lineTrackings, forbiddens: forbiddens, start: startIndex, end: lastIndex)

        return info
    }

    private func getTrackingInfo(from trackingErrors: [TrackingError], forbiddens: Forbidden,
                                 start: Int, end: Int) -> TrackingInfo {

        let trackings = trackingErrors.sorted { $0.errorRate < $1.errorRate }
        guard let smallestErrorRate = trackings.first else {
            return TrackingInfo(startIndex: start, endIndex: start)
        }

        return TrackingInfo(tracking: smallestErrorRate.tracking, forbiddens: forbiddens,
                            startIndex: start, endIndex: end)
    }

    private func updateFilteredTrackingErrors(_ word: SimpleWord,
                                              with trackingErrors: [TrackingError]) -> [TrackingError] {
        var updatedTrackings: [TrackingError] = []
        let wordGaps = word.fixedGapsWithOutside
        for trackingError in trackingErrors {
            let trackingWidth = trackingError.tracking.width
            guard preliminaryChecker.check(word, trackingWidth: trackingWidth),
                let gaps = Gap.updatedOutside(wordGaps, with: trackingWidth) else { continue }

            let result = checker.check(gaps, with: trackingError.tracking)
            if result.result {
                let newRate = trackingError.errorRate + result.errorRate
                let newTracking = TrackingError(tracking: trackingError.tracking, errorRate: newRate)
                updatedTrackings.append(newTracking)
            }
        }
        return updatedTrackings
    }

    private func sumSequenceOfNil(_ trackingInfos: [TrackingInfo]) -> [TrackingInfo] {
        let infos = trackingInfos.reduce([TrackingInfo]()) { (result, info) -> [TrackingInfo] in
            var newResult = result
            if let lastInfo = result.last, lastInfo.tracking == nil, info.tracking == nil {
                let newInfo = TrackingInfo(startIndex: lastInfo.startIndex, endIndex: info.endIndex)
                newResult.removeLast()
                newResult.append(newInfo)
            } else {
                newResult.append(info)
            }
            return newResult
        }
        return infos
    }

    private func shouldStartSearching(in currentIndex: Int, with infos: [TrackingInfo] ) -> Bool {
        if let endIndex = infos.last?.endIndex {
            return currentIndex == endIndex + 1
        } else {
            return currentIndex == 0
        }
    }

    private func separateBiggestWordFromOthers(_ words: [SimpleWord]) -> SplittedWords {
        var sortedWords = words.sorted { $0.frame.width > $1.frame.width }
        let biggestWord = sortedWords.remove(at: 0)
        return (biggestWord, sortedWords )
    }

}

extension TrackingInfoFinder {

    private func checkType(_ lines: [SimpleLine], lineIndex: Int, wordIndex: Int,
                           with trackings: [TrackingError]) -> TrackingAction {

        assert(lineIndex != 0, "TrackingInfoFinder lineIndex cannot be equal 0")
        assert(!trackings.isEmpty, "TrackingInfoFinder trackings cannot be empty")

        let line = lines[lineIndex]
        let word = line.words[wordIndex]
        let trackingErrors = updateFilteredTrackingErrors(word, with: trackings)

        guard trackingErrors.isEmpty else { return .sum(updatedTrackings: trackingErrors) }

        // Если нет результатов
        let previousTrackingWidth = trackings[0].tracking.width

        if wordIndex == 0 {
            guard !intersected(frame: word.frame, with: lines[lineIndex - 1].frame),
                let tracking = trackingFinder.findTrackings(from: word).first,
                !EqualityChecker.check(of: tracking.width, with: previousTrackingWidth, errorPercentRate: 3)
                else { return .split }

            let allOk = checkNextLine(in: lines, currentLineIndex: lineIndex, errors: trackings)
            return allOk ? .forbidden(x: word.frame.leftX) : .split

        } else {
            guard let tracking = trackingFinder.findTrackings(from: word).first
                else { return .forbidden(x: word.frame.leftX) }

            let similarTracking = EqualityChecker.check(of: tracking.width, with:
                previousTrackingWidth, errorPercentRate: 3)
            return similarTracking ? .split : .forbidden(x: word.frame.leftX)

        }

    }

    ///проверяет след линию на совпадение TrackingError но исключая слова с двумя и меньше символами
    func checkNextLine(in lines: [SimpleLine], currentLineIndex: Int, errors: [TrackingError]) -> Bool {
        let nextLineIndex = currentLineIndex + 1
        guard nextLineIndex != lines.count else { return false }

        let line = lines[nextLineIndex]
        for word in line.words {
            guard word.letters.count > 2 else { continue }
            return !updateFilteredTrackingErrors(word, with: errors).isEmpty
        }
        return false
    }

    private func getNextWordInSameLine(in line: SimpleLine, currentWordIndex: Int) -> SimpleWord? {
        let nextWordIndex = currentWordIndex + 1
        guard line.words.count > nextWordIndex else { return nil }
        return line.words[currentWordIndex]
    }

    private func intersected(frame: CGRect, with secondFrame: CGRect) -> Bool {
        let range = frame.leftX...frame.rightX
        let secondRange = secondFrame.leftX...secondFrame.rightX
        return range.intesected(with: secondRange) != nil
    }
}
protocol ErrorRateProtocol {
    var errorRate: CGFloat { get }
}
extension TrackingInfoFinder {
    struct TrackingError: ErrorRateProtocol {
        let tracking: Tracking
        let errorRate: CGFloat
    }

    enum TrackingAction {
        case sum(updatedTrackings: [TrackingError])
        case split
        case forbidden(x: CGFloat)
    }
}

struct PreliminaryTrackingChecker {

    private let maxRateHight: CGFloat = 1.8
    //чтобы исключить всякую хрень как логотипы
    func check(_ word: SimpleWord, trackingWidth: CGFloat) -> Bool {
        guard word.frame.height / trackingWidth < maxRateHight else { return false }

        for letter in word.letters {
            let width = letter.frame.width

            if width < trackingWidth ||
                EqualityChecker.check(of: width, with: trackingWidth, errorPercentRate: 10) {
                continue
            } else {
                let newWidth = (trackingWidth * 2)
                guard EqualityChecker.check(of: newWidth, with: width, errorPercentRate: 4) else {
                    return false
                }
            }
        }
        return true
    }
}
