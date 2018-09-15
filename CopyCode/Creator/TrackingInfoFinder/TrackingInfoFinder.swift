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
    private let kBugRate = 0.15
    
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
        let trackingInfo: TrackingInfo
        let trackings = findTrackings(from: line)
        if !trackings.isEmpty {
            let infos = trackings
                .map { findTrackingInfo(in: lines, startIndex: currentLineIndex, with: $0) }
                .sorted { $0.endIndex > $1.endIndex}
            trackingInfo = infos[0]
        } else {
            trackingInfo = TrackingInfo(tracking: nil, startIndex: currentLineIndex, endIndex: currentLineIndex)
        }
        return trackingInfo
    }
    
    private func sumSequenceOfNil(_ trackingInfos: [TrackingInfo]) -> [TrackingInfo] {
        let infos = trackingInfos.reduce([TrackingInfo]()) { (result, info) -> [TrackingInfo] in
            var newResult = result
            if let lastInfo = result.last, lastInfo.tracking == nil, info.tracking == nil {
                let newInfo = TrackingInfo(tracking: nil, startIndex: lastInfo.startIndex, endIndex: info.endIndex)
                newResult.removeLast()
                newResult.append(newInfo)
            } else {
                newResult.append(info)
            }
            return newResult
        }
        return infos
    }
   

   private func findTrackings(from line: SimpleLine) -> [Tracking] {
        let splitted = splitWords(in: line)
        let result = distanceFinder.find(from: splitted.biggestWord)
        guard case .success(let range) = result else { return [] }
        let biggestWordGaps = splitted.biggestWord.gaps.map { $0.frame }
        let trackings = startPointFinder.find(in: biggestWordGaps, with: range)
        let filteredTrackings = trackings.filter { checkGaps(splitted.otherWords, with: $0) }
        return filteredTrackings
    }
    
    private func findTrackingInfo(in lines: [SimpleLine], startIndex: Int,
                                  with tracking: Tracking) -> TrackingInfo {
        var lastIndex = startIndex
        for (index, line) in lines.enumerated() where startIndex < index{
//            print("Bukaki startLine: \(startIndex), currentLine \(index)")
//            print("Bukaki width: \(tracking.width), startPoint \(tracking.startPoint)")
            let gapsInRange = checkGaps(line.words, with: tracking)
            
//            print("Bukaki \n\n")
            guard gapsInRange else { break }
            lastIndex = index
        }
//        print("Bukaki \n\n\n *************FINISH**************")
        let trackingInfo = TrackingInfo(tracking: tracking, startIndex: startIndex, endIndex: lastIndex)
        return trackingInfo
    }
    
    private func shouldStartSearching(in currentIndex: Int, with infos: [TrackingInfo] ) -> Bool {
        if let endIndex = infos.last?.endIndex {
            return currentIndex == endIndex + 1
        } else {
            return currentIndex == 0
        }
    }
    

    private func checkGaps(_ words: [Word<LetterRectangle>], with tracking: Tracking) -> Bool {
        let arrayOfGaps = words.map { $0.gaps.map {$0.frame } }
        var positiveCount: Int = 0
        var negativeCount: Int = 0
        
        for gaps in arrayOfGaps {
            let result = checker.checkWithCounts(gaps, with: tracking)
            positiveCount += result.positive
            negativeCount += result.negative
        }
        
        let result = check(positive: positiveCount, negative: negativeCount)
//        print("Bukaki result: \(result), pos: \(positiveCount), neg: \(negativeCount)")
        return result
    }
    
    
 
    
    private func check(positive: Int, negative: Int) -> Bool {
        guard negative != 0 else { return true }
        let positive = Double(positive)
        let negative = Double(negative)
        
        return (negative / positive) < kBugRate
    }
    
    private func splitWords(in line: SimpleLine) -> SplittedWords {
        var sortedWords = line.words.sorted { $0.frame.width > $1.frame.width }
        let biggestWord = sortedWords.remove(at: 0)
        return (biggestWord, sortedWords )
    }

}






