//
//  TreeOCR.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
//start top left corner
extension Tree where Node == OCROperations, Result == String {
    func find(_ colorChecker: LetterExistenceChecker, with frame: CGRect) -> String? {
        switch self {
        case .empty: return nil
        case .r(let element):
            print("🔔: \(element)")
            return element
        case let .n(operation, left, right):
            print("-🔸-" + operation.description)
            let exist: Bool
            switch operation.action {
            case .checkerWithFrame(let action): exist = action(colorChecker, frame)
            case .frameRatio(let action): exist = action(frame)
            case .updateFrame(let action):
                let newFrame = action(colorChecker, frame)
                return left.find(colorChecker, with: newFrame)
            }
            return (exist ? left : right).find(colorChecker, with: frame)
        }
    }
}

enum OCROperations: CustomStringConvertible {
    typealias Operation = (_ checker: LetterExistenceChecker, _ frame: CGRect) -> Bool
    typealias FrameOperation = (_ checker: LetterExistenceChecker, _ frame: CGRect) -> CGRect
    
    enum Action {
        case updateFrame ((LetterExistenceChecker, CGRect) -> CGRect)
        case checkerWithFrame ((LetterExistenceChecker, CGRect) -> Bool)
        case frameRatio ((CGRect) -> Bool)
        
    }
    
    case expandFrame(DirectionOptions)
    case tL, tR, tC, bL, bR, bC, lC, rC
    case tLr, lCr, rCr, tCr
    ///height / width
    case ratio(((CGFloat,CGFloat)->Bool), CGFloat)
    /// (0,0) - is top left, (1,1) - bottom right
    case xy(x: CGFloat, y: CGFloat)
    case xRange(x: ClosedRange<Int>, y: CGFloat, op: LogicalOperator)
    case yRange(x: CGFloat, y: ClosedRange<Int>, op: LogicalOperator)
    case notH, c, p_d, Z_S, G_C, t_4, K_k, f_t
    case O_G, I_Z, n4_f, not5, n7_W, G_6
    case n_u, r3, f_W, r6
    case left4
    case hyphenOrDash
    case question
    case equalOrDash
    case asterix
    case S_Dollar
    case semicolon
    case colon
    case s_star
    case R_K
    case O_Q
    case G_0
    case plus_e
    case doubleQuotesCustom
    case equalOrDashCustom
    case bracketOrArrowCustom
    case topCircleRight, botCircleLeft, topCircleLeft
    var action: Action {
        switch self {
        case let .ratio(operation, ratio): return .frameRatio {
            print("ratio \($0.ratio)")
            return operation($0.ratio, ratio)
            }
        case .tL: return .checkerWithFrame { $0.exist(at: $1.tL) }
        case .tR: return .checkerWithFrame { $0.exist(yArray:[0,5], of: 100, x: 0.95, with: $1, op: .or) }
        case .tC: return .checkerWithFrame { $0.exist(at: $1.tC) }
        case .tCr: return .checkerWithFrame { $0.exist(yArray: [0,1], of: 20, x: 0.5, with: $1, op: .or) }
        case .bL: return .checkerWithFrame { $0.exist(at: $1.bL) }
        case .bR: return .checkerWithFrame { $0.exist(yArray:[95,100], of: 100, x: 0.95, with: $1, op: .or) }
        case .bC: return .checkerWithFrame { $0.exist(x: 0.5, y: 0.95, in: $1) }
        case .lC: return .checkerWithFrame { $0.exist(at: $1.lC) }
        case .rC: return .checkerWithFrame { $0.exist(at: $1.rC) }
        case .c: return  .checkerWithFrame { $0.exist(at: $1.c) }
        case .G_C: return .checkerWithFrame
        { $0.exist(x: 1, y: 0.6, in: $1) }
        case .notH: return .checkerWithFrame {
            !($0.exist(xRange: 2...5, of: 7, y: 0.5, with: $1, op: .and) ||
                $0.exist(xRange: 2...5, of: 7, y: 0.4, with: $1, op: .and))
            }
        case .p_d: return .checkerWithFrame { $0.exist(yArray: [3,5], of: 7, x: 0.5, with: $1, op: .or) }
        case .Z_S: return .checkerWithFrame { $0.exist(yRange: 6...7, of: 10, x: 0.95, with: $1, op: .allFalse) }
        case let .xy(x,y): return .checkerWithFrame { $0.exist(x: x, y: y, in: $1) }
        case .n4_f: return .checkerWithFrame { $0.exist(yRange: 6...8, of: 9, x: 0.95, with: $1, op: .or) }
        case .n_u: return .checkerWithFrame { $0.exist(xRange: 3...4, of: 7, y: 0, with: $1, op: .or) }
        case .r3: return .checkerWithFrame { $0.exist(yRange: 3...4, of: 10, x: 0.9, with: $1, op: .or) }
        case .r6: return .checkerWithFrame { $0.exist(yRange: 6...7, of: 10, x: 0.9, with: $1, op: .or) }
        case .lCr: return .checkerWithFrame { $0.exist(yArray: [1], of: 2, x: 0.05, with: $1, op: .or) }
        case .rCr: return .checkerWithFrame { $0.exist(yArray: [1], of: 2, x: 0.90, with: $1, op: .or) }
        case .tLr: return .checkerWithFrame { $0.exist(yArray: [0], of: 1, x: 0.05, with: $1, op: .or) }
        /// ищет левую точку соприкосновения у f
        case .f_W: return .checkerWithFrame (f_WOperation)
        case .n7_W: return .checkerWithFrame { $0.exist(xArray: [2,3], of: 5, y: 0, with: $1, op: .and) }
        case .t_4: return .checkerWithFrame { $0.exist(yRange: 1...3, of: 8, x: 0, with: $1, op: .or) }
        case .botCircleLeft: return .checkerWithFrame {
            !($0.exist(xRange: 0...3, of: 8, y: 0.7, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3, of: 8, y: 0.6, with: $1, op: .allFalse))
            }
        case .topCircleRight:  return .checkerWithFrame {
            !($0.exist(xRange: 5...8 , of: 8, y: 0.2, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8 , of: 8, y: 0.3, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8 , of: 8, y: 0.4, with: $1, op: .allFalse))
            }
            
        case .topCircleLeft: return .checkerWithFrame {
            !($0.exist(xRange: 0...3, of: 8, y: 0.3, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3, of: 8, y: 0.4, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3, of: 8, y: 0.5, with: $1, op: .allFalse))
            }
        case .K_k: return .checkerWithFrame { $0.exist(xRange: 6...7, of: 8, y: 0.1, with: $1, op: .or) }
        case .f_t: return .checkerWithFrame {
            $0.exist(xRange: 7...8, of: 8, y: 0, with: $1, op: .or) ||
                $0.exist(xRange: 7...8, of: 8, y: 0.05, with: $1, op: .or)
            }
        case .O_G: return .checkerWithFrame {
            $0.exist(xRange: 8...9, of: 10, y: 2/7, with: $1, op: .or) &&
                $0.exist(xRange: 8...9, of: 10, y: 3/7, with: $1, op: .or)
            }
        case .I_Z: return .checkerWithFrame {
            $0.exist(xRange: 7...10, of: 10, y: 0.3, with: $1, op: .allFalse)
            
            }
        case .G_6: return .checkerWithFrame(G_6Operation)
        case .not5: return .checkerWithFrame {
            !($0.exist(xRange: 0...2, of: 6, y: 5/9, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...2, of: 6, y: 6/9, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...2, of: 6, y: 7/9, with: $1, op: .allFalse))
            }
        case .hyphenOrDash: return .checkerWithFrame {
            $0.exist(xRange: 5...7, of: 8, y: 0.2, with: $1, op: .someFalse) &&
                $0.exist(xRange: 1...3, of: 8, y: 0.8, with: $1, op: .someFalse)
            }
        case .left4: return .checkerWithFrame { $0.exist(yRange: 3...5, of: 10, x: 0.1, with: $1, op: .someFalse) }
        case let .xRange(x, y, op): return .checkerWithFrame { $0.exist(xRange: x, of: 10, y: y, with: $1, op: op) }
        case let .yRange(x, y, op): return .checkerWithFrame { $0.exist(yRange: y, of: 10, x: x, with: $1, op: op) }
        case .question: return .checkerWithFrame {
            let frame = $1.update(by: ($1.height / 2.4).uintRounded(), in: .offset(.bottom))
            return $0.exist(yRange: 8...10, of: 10, x: 0.4, with: frame, op: .or) ||
                $0.exist(yRange: 8...10, of: 10, x: 0.5, with: frame, op: .or)
            }
        case .equalOrDash: return .checkerWithFrame (equalOperation)
        case .asterix: return .checkerWithFrame {
            $0.exist(xRange: 4...8, of: 8, y: 0.8, with: $1, op: .allFalse) ||
                $0.exist(xRange: 4...8, of: 8, y: 0.7, with: $1, op: .allFalse)
            }
        case .S_Dollar: return .checkerWithFrame {
            !($0.exist(xRange: 4...6, of: 10, y: 0.3, with: $1, op: .or) &&
                $0.exist(xRange: 4...6, of: 10, y: 0.4, with: $1, op: .or))
            }
        case .semicolon: return .checkerWithFrame {
            let topFrame = $1.update(by: ($1.height / 1.1).uintRounded(), in: .offset(.top))
            return $0.exist(yRange: 0...2, of: 10, x: 0.5, with: topFrame, op: .or)
            }
        case .colon: return .checkerWithFrame (equalOperation)
        case .s_star: return .checkerWithFrame  {
            var newFrame = $1
            for direction in [Direction.left, Direction.right] {
                newFrame = $1.update(by: 1, using: $0, in: direction, points: [1, 2, 3])
            }
            return $0.exist(xRange: 7...10, of: 10, y: 0.95, with: newFrame, op: .or)
            }
            
        case .R_K: return .checkerWithFrame {
            $0.exist(xRange: 3...5 , of: 8, y: 0, with: $1, op: .and) ||
                $0.exist(xRange: 3...5 , of: 8, y: 0.05, with: $1, op: .and)
            }

            
        case .O_Q: return .checkerWithFrame {
            let newFrame = $1.update(by: 1, using: $0, in: .bottom, points: [9, 10])
            return $0.exist(x: 0.5, y: 1, in: newFrame)
            }

        case .plus_e: return .checkerWithFrame {
            let array: [Bool] = [$0.exist(x: 0.2, y: 0.2, in: $1),
                                 $0.exist(x: 0.2, y: 0.8, in: $1),
                                 $0.exist(x: 0.8, y: 0.2, in: $1),
                                 $0.exist(x: 0.8, y: 0.8, in: $1)]
            return array.filter { $0 == false }.count >= 3
            }

        case .G_0: return .checkerWithFrame { $0.exist(yRange: 4...8 , of: 14, x: 0.95, with: $1, op: .someFalse) }
            
        case .doubleQuotesCustom: return .checkerWithFrame (doubleQuotesOperation)
        case .equalOrDashCustom: return .checkerWithFrame (equalOrDashOperation)
        case .bracketOrArrowCustom: return .checkerWithFrame (bracketOrArrowCustomOperation)
        case .expandFrame(let options): return .updateFrame {
            var newFrame = $1
            for direction in options.directions {
                newFrame = newFrame.expandFrame(by: 1, times: 4, using: $0, in: direction, with: [1,5,9])
            }
            return newFrame
            }
        }
        
    }
    
    var description: String {
        switch self {
        case .bC: return "bottomCenter"
        case .bL: return "bottomLeft"
        case .bR: return "bottomRight"
        case .c: return "center"
        case .f_t: return "f_t"
        case .f_W: return "f_W"
        case .G_6: return "G_6"
        case .G_C: return "G_C"
        case .notH: return "notH"
        case .I_Z: return "I_Z"
        case .K_k: return "K_k"
        case .lC: return "leftCenter"
        case .lCr: return "lcr"
        case .n4_f: return "n4_f"
        case .n7_W: return "7_W"
        case .botCircleLeft: return "botCircleLeft"
        case .topCircleRight: return "topCircleRight"
        case .topCircleLeft: return "topCircleLeft"
        case .n_u: return "n_u"
        case .not5: return "not5"
        case .O_G: return "O_G"
        case .p_d: return "p_d"
        case .r3: return "r3"
        case .r6: return "r6"
        case .ratio(let ratio): return "ratio: \(ratio)"
        case .rC: return "rightCenter"
        case .rCr: return "rCr"
        case .t_4: return "t_4"
        case .tC: return "topCenter"
        case .tCr: return "tCr"
        case .tL: return "topLeft"
        case .tLr: return "tLr"
        case .tR: return "topRight"
        case .Z_S: return "Z_S"
        case let .xy(x,y): return "xy \(x), \(y)"
        case let .xRange(x, y, op): return "xRange: \(x), y: \(y), operator: \(op)"
        case let .yRange(x, y, op): return "yRange: \(y), x: \(x), operator: \(op)"
        case .hyphenOrDash: return "dashOrHyphen"
        case .left4:  return "left4"
        case .question: return "question"
        case .equalOrDash: return "equalOrDash"
        case .asterix: return "asterix"
        case .S_Dollar: return "S_Dollar"
        case .semicolon: return "semicolon"
        case .colon: return "colon"
        case .s_star: return "s_star"
        case .R_K: return "R_K"
        case .O_Q: return "O_Q"
        case .plus_e: return "plus_e"
        case .G_0: return "G_0"
        case .doubleQuotesCustom: return "quotes"
        case .equalOrDashCustom: return "equalOrDashCustom"
        case .bracketOrArrowCustom: return "bracketOrArrowCustom"
        case .expandFrame(let options ): return "expandFrame in \(options.directions)"
            
        }
    }
    
    enum InsideType {
        case undefined
        case startOut
        case inside
        case endOut
    }

    private var columnOrDot: Operation {
        return { checker, frame in
            return  checker.exist(yRange: 3...4, of: 10, x: 0.5, with: frame, op: .or) &&
                checker.exist(yRange: 6...7, of: 10, x: 0.5, with: frame, op: .or)
        }
    }
    
    private var bracketOrArrowCustomOperation: Operation {
        return { checker, frame in
            return  checker.exist(xRange: 1...2, of: 10, y: 0.1, with: frame, op: .or) ||
                checker.exist(xRange: 1...2, of: 10, y: 0.9, with: frame, op: .or)
        }
    }
    
    //пока оставлю так
    private var equalOrDashOperation: Operation {
        return { checker, frame in
            let array: [CGFloat] = [0.3, 0.4, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8]
            var exists: [CGFloat] = []
            for y in array {
                let value = checker.exist(x: 0.5, y: y, in: frame)
                if value {
                   exists.append(y)
                }
            }
            guard let first = exists.first, let last = exists.last else { return false }
            let difference = last - first
            print("difference \(difference)")
            print(exists)
            return difference > 0.1
        }
    }
    
    private var doubleQuotesOperation: Operation {
        return { checker, frame in
            var insideType: InsideType = .undefined
            let array: [CGFloat] = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
            for x in array {
                let value = checker.exist(x: x, y: 0.3, in: frame)
                switch insideType {
                case .undefined:
                    insideType = value ? .startOut : .undefined
                case .startOut:
                    insideType = value ? .startOut : .inside
                case .inside:
                    insideType = value ? .endOut : .inside
                case .endOut: return true
                }
            }
            
            if case .endOut = insideType {
                return true
            }
            return false
        }
    }
    
    private var f_WOperation: Operation {
        return { checker, frame in
            var exist = true
            var updatedFrame = frame
            
            while exist {
                let newFrame = updatedFrame.expand(addingOfRatio: 0.05, in: .left)
                exist = checker.exist(yArray: [0, 2, 4, 6], of: 6, x: 0, with: newFrame, op: .or)
                updatedFrame = newFrame
            }
            return checker.exist(yRange: 4...7, of: 20, x: 0, with: updatedFrame, op: .or)
        }
    }

    private var equalOperation: Operation {
        return { checker, frame in
            let distance = (frame.height * 2).uintRounded()
            let topFrame = frame.update(by: distance, in: .offset(.top))
            let bottomFrame = frame.update(by: distance, in: .offset(.bottom))
            
            return checker.exist(yRange: 0...3, of: 10, x: 0.5, with: topFrame, op: .or) ||
                checker.exist(yRange: 7...10, of: 10, x: 0.5, with: bottomFrame, op: .or)
        }
    }
    
    ///находим первую черную точку линии G
    private var firsGrayscaleOperation: (_ checker: LetterExistenceChecker, _ frame: CGRect, _ startY: CGFloat) -> CGFloat {
        return { checker, frame, startY  in
            let y = startY
            let x = frame.xAs(rate: 0.9)
            var isGrayscale = false
            var lastY = y
            while !isGrayscale {
                lastY -= 1
                let newPoint = CGPoint(x: x, y: lastY)
                isGrayscale = checker.exist(at: newPoint)
            }
            return lastY
        }
    }
    
    private var firstWhiteOperation: (_ checker: LetterExistenceChecker, _ frame: CGRect) -> CGFloat {
        return { checker, frame in
            let y = frame.yAs(rate: 0.2)
            let x = frame.xAs(rate: 0.9)
            var isWhite = false
            var lastY = y
            while !isWhite {
                lastY -= 1
                let newPoint = CGPoint(x: x, y: lastY)
                isWhite = !checker.exist(at: newPoint)
            }
            return lastY
        }
    }
    
    private var G_6Operation: Operation {
        return { checker, frame in
            //так как firsGrayscaleOperation может сразу попасть на верх G то тогда будет ошибка, нужно чтобы сначала нашел пустоту, а потом от нее черный цвет
            let white = self.firstWhiteOperation(checker, frame)
            let firstBlack = self.firsGrayscaleOperation(checker, frame, white)
            let lastWhite = firstBlack + 1
            for i in Array(4...8).reversed() {
                let x = frame.xAs(part: i, of: 8)
                let point = CGPoint(x: x, y: lastWhite)
                if checker.exist(at: point) {
                    return false
                }
            }
            return true
        }
    }
}

extension Direction {
    fileprivate var completion: (LetterExistenceChecker, [Int], CGRect) -> Bool {
        switch self {
        case .top: return { $0.exist(xArray: $1, of: 10, y: 0, with: $2, op: .or) }
        case .left: return { $0.exist(yArray: $1, of: 10, x: 0, with: $2, op: .or) }
        case .right: return { $0.exist(yArray: $1, of: 10, x: 1, with: $2, op: .or) }
        case .bottom: return { $0.exist(xArray: $1, of: 10, y: 1, with: $2, op: .or) }
        }
    }
}

extension CGRect {
    fileprivate func expandFrame(by pixels: UInt, times: Int, using checker: LetterExistenceChecker,
                            in direction: Direction, with points: [Int]) -> CGRect {
        
        var newFrame = self
        for _ in 0..<times {
            let temporaryFrame = newFrame.update(by: pixels, in: .offset(direction.optionSet))
            
            guard direction.completion(checker, points, temporaryFrame) else { break }
            newFrame = temporaryFrame
        }
        return newFrame
    }
    
    ///просто обновляет границы либо внуть либо снаружи, сам решает
    fileprivate func update(by pixels: UInt, using checker: LetterExistenceChecker, in direction: Direction, points: [Int]) -> CGRect {
        let initialStatus = direction.completion(checker, points, self)
        var updatedFrame = self
        
        for _ in 0..<4 {
            let edge: EdgeDirection = initialStatus ? .offset(direction.optionSet) : .inset(direction.optionSet)
            let newFrame = updatedFrame.update(by: pixels, in: edge)
            let status = direction.completion(checker, points, newFrame)
            //если инсет то нужно принять изменения фрейма
            if status { updatedFrame = newFrame }
            if initialStatus != status { break }
            updatedFrame = newFrame
        }
        
        return updatedFrame
        
    }
}

extension CGFloat {
    fileprivate func uintRounded() -> UInt {
        return UInt(self.rounded())
    }
}
