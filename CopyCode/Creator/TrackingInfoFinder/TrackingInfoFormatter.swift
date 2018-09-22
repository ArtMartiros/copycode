//
//  TrackingInfoFormatter.swift
//  CopyCode
//
//  Created by Артем on 26/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingInfoFormatter {
    private let kErrorPercentRate: CGFloat = 2
    
    func chunkTrackingInfo(_ infos: [TrackingInfo], block: SimpleBlock) -> [[TrackingInfo]] {
        var arrayOfInfos: [[TrackingInfo]] = []
        var usedIndexes = Set<Int>()
        
        for (index, info) in infos.enumerated() where !usedIndexes.contains(index) {
            var chunk = [info]
            usedIndexes.insert(index)
            
            subLoop: for (subIndex, subInfo) in infos.enumerated() where !usedIndexes.contains(subIndex) {
                //если e текущего трекинг отсутствует тогда прерываем цепь
                let relationType = getRelation(between: info, and: subInfo)
                switch relationType {
                case .failure(let failType):
                    switch failType {
                    case .missingCurrent:
                        break subLoop
                        
                    case .missingNext, .differentTracking:
                        guard !isBlocked(current: info, and: subInfo, in: block) else { break subLoop }
                        continue subLoop
                    }
                    
                case .success:
                    let range = (index + 1)..<subIndex
                    let infosBetween = arrayIn(range: range, from: infos, exlude: usedIndexes)
                    let passedType = isPassed(internal: infosBetween, between: info, and: subInfo, block: block)
                    switch passedType {
                    case .intersected:
                        break subLoop
                        
                    case .passedBy:
                        chunk.append(subInfo)
                        usedIndexes.insert(subIndex)
                        
                    case .rebundandAtTop(let newForbidden):
                        var newInfo = info
                        newInfo.forbiddens.merge(newForbidden) { (_, new) in new }
                        chunk.removeFirst()
                        chunk.insert(newInfo, at: 0)
                        chunk.append(subInfo)
                        usedIndexes.insert(subIndex)
                        
                    case .rebundandAtBot(let newForbidden):
                        var newInfo = subInfo
                        newInfo.forbiddens.merge(newForbidden) { (_, new) in new }
                        chunk.append(newInfo)
                        usedIndexes.insert(subIndex)
                        
                    }
                }
            }
            arrayOfInfos.append(chunk)
            
        }
        
        return arrayOfInfos
    }
    
    private func isBlocked(current: TrackingInfo, and next: TrackingInfo, in block: SimpleBlock) -> Bool {
        guard let currentXrange = current.xRange(at: block, type: .allowed),
            let nextRangeX = next.xRange(at: block, type: .all) else { return true }
        
        guard currentXrange.intesected(with: nextRangeX) != nil else { return false }
        
        let result = findForbidden(for: current, in: nextRangeX, block: block)
        switch result {
        case .failure: return true
        case .success: return false
        }
    }
    
    private func arrayIn(range: Range<Int>, from infos: [TrackingInfo],
                         exlude exludeIndexes: Set<Int>) -> [TrackingInfo] {
        let indexes = Set(range).filter { !exludeIndexes.contains($0) }
        var newInfos: [TrackingInfo] = []
        
        for (index, info) in infos.enumerated() where indexes.contains(index) {
            newInfos.append(info)
        }
        return newInfos
    }
    
    private func isPassed(internal internalInfos: [TrackingInfo], between current: TrackingInfo,
                          and next: TrackingInfo, block: SimpleBlock) -> PassedType {
        
        guard !internalInfos.isEmpty else { return .passedBy }
        guard let currentXrange = current.xRange(at: block, type: .allowed),
            let nextXrange = next.xRange(at: block, type: .allowed) else { return .intersected }
        
        var types = Set<IntersectionType>()
        var forbiddens: Forbidden = [:]
        
        loop: for info in internalInfos {
            guard types.count < 2 else { return .intersected }
            guard let range = info.xRange(at: block, type: .all) else { continue }
            let result = isIntersect(info: info, current: currentXrange, or: nextXrange, block: block)
            switch result {
            case .noOne: continue loop
            case .both: return .intersected
            case .top:
                guard case .success(let forbidden) = findForbidden(for: current, in: range, block: block)
                    else { return .intersected }
                types.insert(result)
                forbiddens.merge(forbidden) { (old, new) in min(old, new) }

            case .bot:
                guard case .success(let forbidden) = findForbidden(for: next, in: range, block: block)
                    else { return .intersected }
                types.insert(result)
                forbiddens.merge(forbidden) { (old, new) in min(old, new) }
            }
        }
        
        guard types.count < 2 else { return .intersected }
        if let type = types.first {
            if case .top = type {
                return .rebundandAtTop(forbidden: forbiddens)
            } else {
                return .rebundandAtBot(forbidden: forbiddens)
            }
        }
        return .passedBy
    }

    ///сколько высот слова должно быть в ширине между словами, чтоб разделить линию
    private let kBreakLineRate: CGFloat = 6
    
    private func isIntersect(info: TrackingInfo, current: TrackingRange, or next: TrackingRange, block: SimpleBlock) -> IntersectionType {
        
        guard let range = info.xRange(at: block, type: .all) else { return .noOne }
        if current.intesected(with: range) != nil {
            return next.intesected(with: range) != nil ? .both : .top
        } else if next.intesected(with: range) != nil {
            return current.intesected(with: range) != nil ? .both : .bot
        }
        return .noOne
    }
    
    private func findForbidden(for info: TrackingInfo, in range: TrackingRange, block: SimpleBlock) -> SimpleSuccess<Forbidden> {
        var forbidden: Forbidden = [:]
        let indexes = info.findLineIndexes(from: block, in: range)
        for index in indexes {
            let words = block.lines[index].words
            for (wordIndex, word) in words.enumerated() {
                let wordRange = word.frame.leftX...word.frame.rightX
                guard wordRange.intesected(with: range) != nil else { continue }
                guard wordIndex != 0  else { return .failure }
                
                let previous = words[wordIndex - 1]
                
                let different =  word.frame.leftX - previous.frame.rightX
                let shouldBreak = different / word.frame.height > kBreakLineRate
                if shouldBreak  {
                    forbidden[index] = word.frame.leftX
                    break
                } else {
                    return .failure
                }
            }
        }
        return .success(forbidden)
    }
    
    private func getRelation(between current: TrackingInfo, and next: TrackingInfo) -> RelationType {
        guard let current = current.tracking else { return .failure(.missingCurrent) }
        guard let next = next.tracking else { return .failure(.missingNext) }
        
        guard EqualityChecker.check(of: current.width, with: next.width, errorPercentRate: kErrorPercentRate)
            else { return .failure(.differentTracking) }
        
        return .success
    }
}

extension TrackingInfoFormatter {
    enum IntersectionType {
        case top
        case bot
        case both
        case noOne
    }
    
    enum PassedType {
        case passedBy
        case intersected
        case rebundandAtTop(forbidden: [Int: CGFloat])
        case rebundandAtBot(forbidden: [Int: CGFloat])
    }
    
    enum RelationType {
        case failure(FailType)
        case success
        enum FailType {
            case missingCurrent
            case differentTracking
            case missingNext
        }
    }
}
