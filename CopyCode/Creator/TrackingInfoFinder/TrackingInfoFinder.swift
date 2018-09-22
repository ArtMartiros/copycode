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
    private let distanceFinder = TrackingDistanceFinder()
    private let startPointFinder = TrackingStartPointFinder()
    private let checker = TrackingChecker()

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

        let posInfos = getTrackingPosInfos(from: line.words).sorted { $0.startX < $1.startX }
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
    
    func shoulRemoveLastForbidden(_ forbiddens: [Int: CGFloat], lines: [SimpleLine], lineIndex: Int) -> Bool {
        let previousIndex =  lineIndex - 1
        guard let forbiddenX = forbiddens[previousIndex] else { return false }
        let exist = lines[previousIndex].words.first { $0.frame.leftX < forbiddenX } != nil
        return !exist
    }
    
    
    //если раньше мы пропускали тракинг через линии пытаю=ясь найти самую дальнюю
    //теперь мы пропускаем как сперматазоидов скопом сначала через одну линию потмо через другую
    private func findTrackingInfo(in lines: [SimpleLine], startIndex: Int,
                                  forbiddens: [Int: CGFloat], trackings: [TrackingError]) -> TrackingInfo {
        var lineTrackings = trackings
        var lastIndex = startIndex
        var forbiddens = forbiddens
        
        lineLoop: for (lineIndex, line) in lines.enumerated() where startIndex < lineIndex {
            print("lineIndex \(lineIndex)\n\n")
            let words = line.words
            var wordTrackings = lineTrackings
            
            for (wordIndex, word) in words.enumerated() {
                print("wordIndex \(wordIndex)\n")
                let updatedTrackings = updateFilteredTrackingErrors(word, with: wordTrackings)
                if updatedTrackings.isEmpty {
                    if wordIndex == 0 && shoulRemoveLastForbidden(forbiddens, lines: lines, lineIndex: lineIndex) {
                        let previousIndex = lineIndex - 1
                        forbiddens.removeValue(forKey: previousIndex)
                        lastIndex -= 1
                        break lineLoop
                    }
                    
                    if checkIsException(word) {
                        forbiddens[lineIndex] = word.frame.leftX
                        break
                    } else {
                        if shoulRemoveLastForbidden(forbiddens, lines: lines, lineIndex: lineIndex) {
                            let previousIndex = lineIndex - 1
                            forbiddens.removeValue(forKey: previousIndex)
                            lastIndex -= 1
                        }
                        break lineLoop
                    }
                } else {
                    wordTrackings = updatedTrackings
                }
            }
            
            lineTrackings = wordTrackings
            lastIndex = lineIndex
        }
        
        guard !lineTrackings.isEmpty  else {
            return TrackingInfo(startIndex: startIndex, endIndex: startIndex)
        }
        
        let smallestErrorRate = lineTrackings.sorted { $0.errorRate < $1.errorRate }[0]
        let info = TrackingInfo(tracking: smallestErrorRate.tracking,
                                 forbiddens: forbiddens, startIndex: startIndex, endIndex: lastIndex)
        return info
    }
    
    private func updateFilteredTrackingErrors(_ word: SimpleWord,
                                              with trackingErrors: [TrackingError]) -> [TrackingError] {
        var updatedTrackings: [TrackingError] = []
        let wordGaps = word.fixedGapsWithOutside
        for trackingError in trackingErrors  {
            guard let gaps = Gap.updatedOutside(wordGaps, with: trackingError.tracking.width) else { continue }
            let result = checker.check(gaps, with: trackingError.tracking)
            if result.result {
                let newRate = trackingError.errorRate + result.errorRate
                let newTracking = TrackingError(tracking: trackingError.tracking, errorRate: newRate)
                updatedTrackings.append(newTracking)
            }
        }
        return updatedTrackings
    }
    
    private func checkIsException(_ word: SimpleWord) -> Bool {
        let result = distanceFinder.find(from: word)
        switch result {
        case .failure: return true
        case .success(let range):
            print(range)
         return false
        }
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
    struct TrackingPosInfo {
        let startX: CGFloat
        let lastKnowX: CGFloat
        let trackings: [Tracking]
    }
    
    struct TrackingError {
        let tracking: Tracking
        let errorRate: CGFloat
    }


    func getTrackingPosInfos(from lineWords: [SimpleWord]) -> [TrackingPosInfo] {
        var posInfos: [TrackingPosInfo] = []
        
        guard !lineWords.isEmpty else { return [] }
        
        let (biggestWord, otherWords) = separateBiggestWordFromOthers(lineWords)
        let result = distanceFinder.find(from: biggestWord)
        switch result {
        case .success(let range):
            let trackings = startPointFinder.find(in: biggestWord, with: range)
            var filteredTrackings = trackings
            let sortedWords = otherWords.sortedFromLeftToRight()
            for (index, word) in sortedWords.enumerated() {
                let wordGaps = word.fixedGapsWithOutside
                let newTrackings = filteredTrackings.filter {
                    guard let gaps = Gap.updatedOutside(wordGaps, with: $0.width) else { return false }
                    return  checker.check(gaps, with: $0).result
                }
                
                if newTrackings.isEmpty {
                    let startX = index == 0 ? biggestWord.frame.leftX : min(sortedWords[0].frame.leftX, biggestWord.frame.leftX)
                    let lastX = index == 0 ? biggestWord.frame.rightX : sortedWords[index - 1].frame.rightX
                    let posInfo = TrackingPosInfo(startX: startX, lastKnowX: lastX, trackings: filteredTrackings)
                    posInfos.append(posInfo)
                    
                    let new = Array(sortedWords[index..<sortedWords.count])
                    let results = getTrackingPosInfos(from: new)
                    posInfos.append(contentsOf: results)
                    break
                } else {
                    filteredTrackings = newTrackings
                    if index == sortedWords.count - 1 {
                        let startX = min(sortedWords[0].frame.leftX, biggestWord.frame.leftX )
                        let posInfo = TrackingPosInfo(startX: startX, lastKnowX: word.frame.rightX, trackings: filteredTrackings)
                        posInfos.append(posInfo)
                    }
                    
                }
            }
            
            if sortedWords.isEmpty {
                let posInfo = TrackingPosInfo(startX: biggestWord.frame.leftX, lastKnowX: biggestWord.frame.rightX,
                                              trackings: filteredTrackings)
                posInfos.append(posInfo)
            }
        case .failure:
            let posInfo = TrackingPosInfo(startX: biggestWord.frame.leftX, lastKnowX: biggestWord.frame.rightX, trackings: [])
            posInfos.append(posInfo)
            
            let lefterWords = otherWords.filter { $0.frame.leftX < biggestWord.frame.leftX }
            let results = getTrackingPosInfos(from: lefterWords)
            posInfos.append(contentsOf: results)
        }
        return posInfos
    }

}



