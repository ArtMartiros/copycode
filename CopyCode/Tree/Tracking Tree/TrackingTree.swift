////
////  TrackingTree.swift
////  CopyCode
////
////  Created by Артем on 30/11/2018.
////  Copyright © 2018 Artem Martirosyan. All rights reserved.
////
//
//import Foundation
//
/////все изменения происходят здесь
/////всю инфу тоже беру потом отсюда
//class Test {
//    typealias TrackingError = TrackingInfoFinder.TrackingError
//    private let checker = TrackingChecker()
//    private let preliminaryChecker = PreliminaryTrackingChecker()
//    let block: SimpleBlock
//    let lineIndex: Int
//    var trackings: [TrackingError] = []
//
//    func passLine(at type: LineIndex) -> Bool {
//        let line = block.lines[lineIndex + type.rawValue]
//        return true
//    }
//
//    private func remainingErrors(after word: SimpleWord, errors: [TrackingError]) -> [TrackingError] {
//        var updatedTrackings: [TrackingError] = []
//        let wordGaps = word.corrrectedGapsWithOutside()
//        for trackingError in errors {
//            let trackingWidth = trackingError.tracking.width
//            guard preliminaryChecker.check(word, trackingWidth: trackingWidth),
//                let gaps = Gap.updatedOutside(wordGaps, with: trackingWidth) else { continue }
//
//            let result = checker.check(gaps, with: trackingError.tracking)
//            if result.result {
//                let newRate = trackingError.errorRate + result.errorRate
//                let newTracking = TrackingError(tracking: trackingError.tracking, errorRate: newRate)
//                updatedTrackings.append(newTracking)
//            }
//        }
//        return updatedTrackings
//    }
//
//    init(_ block: SimpleBlock, lineIndex: Int) {
//        self.block = block
//        self.lineIndex = lineIndex
//    }
//}
//
//enum LineIndex: Int {
//    case main = 0
//    case current
//    case next
//}
//
//extension Tree where Node == TrackingTypeOperations, Result == SomeType {
//    func find(in test: Test) -> MirrorSomeType {
//        switch self {
//        case .empty: return .split
//        case .r(let result): return MirrorSomeType(test, with: result)
//        case let .n(operation, left, right):
//            return (operation.action ? left : right).find(in: test)
//        }
//    }
//}
//
//fileprivate typealias T = Tree<TrackingTypeOperations, SomeType>
//
//let trackTree = T.n(.pass(.current),
//                    .r(.success),
//                    T.n(.zeroPass,
//                        T.n(.intersect(.main, with: .current),
//                            .r(.split),
//                            T.n(.pass(.next),
//                                .r(.success),
//                                .r(.success))),
//                        .r(.success)))
//
//enum TrackingTypeOperations: CustomStringConvertible {
//
//    case pass(LineIndex)
//    case halfPass
//    case zeroPass
//    case intersect(LineIndex, with: LineIndex)
//
//    var action: Bool {
//        return true
//    }
//    var description: String {
//        return ""
//    }
//}
//
//enum SomeType {
//    case update
//    case split
//    case success
//}
//
//enum MirrorSomeType {
//    case update
//    case split
//    case success
//
//    init(_ test: Test, with type: SomeType) {
//        switch type {
//        case .update: self = .update
//        default: self = .update
//        }
//    }
//}
//
//extension TrackingInfoFinder {
//    enum NewType2 {
//        case update([TrackingError])
//        case restricted([TrackingError], LineRestriction)
//        case split
//    }
//}
