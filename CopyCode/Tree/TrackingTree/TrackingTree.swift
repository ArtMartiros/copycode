//
//  TrackingTree.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

//пока не использую, но потом думал заменить слишком неповоротливый механизм на этот
//import Foundation
//enum TrackingTypeOperations {
//    case intersected
//    var action: Bool {
//        return true
//    }
//}
//
//typealias TrackingTree = Tree<TrackingTypeOperations, TrackingAction>
//
//enum TrackingAction {
//    case sum
//    case split
//    case forbidden
//    case skip
//}
//
//extension Tree where Node == TrackingTypeOperations, Result == TrackingAction {
//    func find() -> TrackingAction {
//        switch self {
//        case .empty:
//            return .split
//            
//        case .r(let result):
//            return result
//            
//        case let .n(operation, left, right):
//            return (operation.action ? left : right).find()
//        }
//    }
//}
//
//let trackingTree: TrackingTree = .n(.intersected,
//                                    .empty,
//                                    .empty)

//extension TrackingInfoFinder {
//    private func intersected(frame: CGRect, with secondFrame: CGRect) -> Bool {
//        let range = frame.leftX...frame.rightX
//        let secondRange = secondFrame.leftX...secondFrame.rightX
//        return range.intesected(with: secondRange) != nil
//    }
//
//    private func getTacking(from word: SimpleWord) -> Tracking? {
//        return nil
//    }
//
//    private func checkIsSameTracking(tracking: Tracking) -> Bool {
//        return true
//    }
//
//    private func checkIsTL(with tracking: Tracking) -> Bool {
//        return true
//    }
//
//    func test(current word: SimpleWord, wordIndex: Int, previousAction: TrackingAction) -> TrackingAction {
//        if intersected(frame: sss, with: word.frame) {
//            if let tracking = getTacking(from: word) {
//                //значит
//                if wordIndex == 0 {
//                    if checkIsTL(with: tracking) {
//                        //TL возможно, что нужно уточнение
//                        return .split
//                    } else {
//                        //TD
//                        return .split
//                    }
//                } else {
//                    //TS TD
//                    return .forbidden
//                }
//            } else {
//                return .split
//            }
//            //Непересекающиеся
//        } else {
//            if let tracking = getTacking(from: word) {
//                if wordIndex == 0 {
//                    //TD
//                    return .skip
//                } else {
//                    //TS TD
//                    return .forbidden
//                }
//            } else {
//                //nil
//                return .skip
//            }
//        }
//    }
//}

/**
 Все варианты
 
 Строка nil
 Строка T
 
 Строка TT
 Строка T nil
 
 L = Little different
 S = Same
 D = Different
 
 1
 Строка nil
 
 Пересакающиеся / Непересекающиеся
 
 след. nil (суммирует)
 след. T (разделяем)
 след. TT (разделяем)
 след. T nil (разделяем)
 
 2
 Строка T
 
 Пересакающиеся
 
 след. nil        (разделяем)
 след. TS         (суммируем)
 след. TS nil    (суммируем + forbidden)
 
 след. TD    (разделяем)
 след. TD nil    (разделяем)
 след. TS TD        (суммируем + forbidden)
 след. TD TS        (разделяем)
 
 Непересекающиеся
 след. nil        (пропускаем)
 след. TS        (пред. forbidden + суммируем)
 след. TS nil    (пред. forbidden + суммируем + fobidden)
 след. TD        (пред. разделяем + разделяем)
 след. TD nil    (пред. разделяем + разделяем)
 след. TS TD        (пред. forbidden + суммируем + forbidden)
 след. TD TS        (пред. разделяем + разделяем)
 
 след. TD         (пропускаем)
 след. TS        (пред. forbidden + суммируем)
 след. TS nil    (пред. forbidden + суммируем + fobidden)
 след. TD        (пред. разделяем + суммируем)
 след. TD nil    (пред. разделяем + суммируем)
 след. TS TD        (пред. forbidden + суммируем + forbidden)
 след. TD TS        (пред. разделяем + суммируем)
 
 след. TL         (пропускаем)
 
 
 
**/
