//
//  TrackingPosInfoFinder.swift
//  CopyCode
//
//  Created by Артем on 02/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

/// Дает массив trackings для слов в одной линии с начальной и конечной точкой в которых есть эти trackings
struct TrackingPosInfoFinder {
    typealias SplittedWords = (biggestWord: Word<LetterRectangle>, otherWords: [Word<LetterRectangle>])
    
    private let trackingFinder = TrackingFinder()
    private let checker = TrackingChecker()
    
    func find(from lineWords: [SimpleWord]) -> [TrackingPosInfo] {
        var posInfos: [TrackingPosInfo] = []
        
        guard !lineWords.isEmpty else { return [] }
        
        let (biggestWord, otherWords) = separateBiggestWordFromOthers(lineWords)
        let trackings = trackingFinder.findTrackings(from: biggestWord)
        
        var filteredTrackings = trackings
        let sortedWords = otherWords.sortedFromLeftToRight()
        for (index, word) in sortedWords.enumerated() {
            let wordGaps = word.fixedGapsWithOutside
            print("****************************W: \(index)*************************")
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
                let results = find(from: new)
                posInfos.append(contentsOf: results)
                break
            } else {
                filteredTrackings = newTrackings
                if index == sortedWords.count - 1 {
                    let startX = min(sortedWords[0].frame.leftX, biggestWord.frame.leftX )
                    let lastX = max(word.frame.rightX, biggestWord.frame.rightX)
                    let posInfo = TrackingPosInfo(startX: startX, lastKnowX: lastX, trackings: filteredTrackings)
                    posInfos.append(posInfo)
                }
                
            }
        }
        
        if sortedWords.isEmpty {
            let posInfo = TrackingPosInfo(startX: biggestWord.frame.leftX, lastKnowX: biggestWord.frame.rightX,
                                          trackings: filteredTrackings)
            posInfos.append(posInfo)
        }
        
        return posInfos
    }
    
    private func separateBiggestWordFromOthers(_ words: [SimpleWord]) -> SplittedWords {
        var sortedWords = words.sorted { $0.frame.width > $1.frame.width }
        let biggestWord = sortedWords.remove(at: 0)
        return (biggestWord, sortedWords )
    }
    
    struct TrackingPosInfo {
        let startX: CGFloat
        let lastKnowX: CGFloat
        let trackings: [Tracking]
    }
    
}







