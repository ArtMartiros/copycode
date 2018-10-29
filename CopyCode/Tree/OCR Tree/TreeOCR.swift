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
// swiftlint:disable type_body_length
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
    case ratio(((CGFloat, CGFloat)->Bool), CGFloat)
    /// (0,0) - is top left, (1,1) - bottom right
    case xy(x: CGFloat, y: CGFloat)
    case xRange(x: ClosedRange<Int>, y: CGFloat, op: LogicalOperator)
    case yRange(x: CGFloat, y: ClosedRange<Int>, op: LogicalOperator)
    case vLine(l: ClosedRange<Int>, x: ClosedRange<Int>, op: LogicalOperator, mainOp: LogicalOperator)
    case hLine(l: ClosedRange<Int>, y: ClosedRange<Int>, op: LogicalOperator, mainOp: LogicalOperator)
    case H_N, c, p_d, Z_S, G_C, t_4, K_k, f_t
    case O_G, I_Z, n4_f, not5, n7_W, G_6
    case n_u, r3, r6
    case left4
    case notH
    case f_t_low
    case m_a
    case s_a
    case e_a
    case N_A
    case f_2
    case S_5
    case hyphenOrDash
    case question
    case equalOrDash
    case asterix
    case S_Dollar
    case semicolon
    case E_5
    case braceOrRoundL
    case braceOrRoundR
    case colon
    case s_star
    case l_1
    case R_K
    case O_Q
    case G_0
    case v_u
    case G_8
    case i_1
    case plus_e
    case doubleQuotesCustom
    case equalOrDashCustom
    case bracketOrArrowCustom
    case topCircleRight, botCircleLeft, topCircleLeft
    var action: Action {
        switch self {
        case let .ratio(operation, ratio): return .frameRatio {
            guard $0.width > 0 else { return operation(20, ratio) }
            print("ratio \($0.ratio)")
            return operation($0.ratio, ratio)
            }
        case .braceOrRoundL: return .checkerWithFrame (braceOrRoundLOperation)
        case .braceOrRoundR: return .checkerWithFrame (braceOrRoundROperation)
        case .tL: return .checkerWithFrame { $0.exist(at: $1.tL) }
        case .tR: return .checkerWithFrame { $0.exist(yArray: [0, 5], of: 100, x: 0.95, with: $1, op: .or) }
        case .tC: return .checkerWithFrame { $0.exist(at: $1.tC) }
        case .tCr: return .checkerWithFrame { $0.exist(yArray: [0, 1], of: 20, x: 0.5, with: $1, op: .or) }
        case .bL: return .checkerWithFrame { $0.exist(at: $1.bL) }
        case .bR: return .checkerWithFrame { $0.exist(yArray: [95, 100], of: 100, x: 0.95, with: $1, op: .or) }
        case .bC: return .checkerWithFrame { $0.exist(x: 0.5, y: 0.95, in: $1) }
        case .lC: return .checkerWithFrame { $0.exist(at: $1.lC) }
        case .rC: return .checkerWithFrame { $0.exist(at: $1.rC) }
        case .c: return  .checkerWithFrame { $0.exist(at: $1.c) }
        case .G_C: return .checkerWithFrame { $0.exist(x: 1, y: 0.6, in: $1) }
        case .notH: return .checkerWithFrame {
            !($0.exist(xRange: 2...5, of: 7, y: 0.5, with: $1, op: .and) ||
                $0.exist(xRange: 2...5, of: 7, y: 0.4, with: $1, op: .and))
            }
        case .v_u: return .checkerWithFrame (v_uOperation)
        case .H_N: return .checkerWithFrame (H_NOperation)
        case .p_d: return .checkerWithFrame { $0.exist(yArray: [3, 5], of: 7, x: 0.5, with: $1, op: .or) }
        case .Z_S: return .checkerWithFrame { $0.exist(yRange: 6...7, of: 10, x: 0.95, with: $1, op: .allFalse) }
        case let .xy(x, y): return .checkerWithFrame { $0.exist(x: x, y: y, in: $1) }
        case .n4_f: return .checkerWithFrame { $0.exist(yRange: 6...8, of: 9, x: 0.95, with: $1, op: .or) }
        case .n_u: return .checkerWithFrame { $0.exist(xRange: 3...4, of: 7, y: 0, with: $1, op: .or) }
        case .r3: return .checkerWithFrame { $0.exist(yRange: 3...4, of: 10, x: 0.9, with: $1, op: .or) }
        case .r6: return .checkerWithFrame { $0.exist(yRange: 6...7, of: 10, x: 0.9, with: $1, op: .or) }
        case .lCr: return .checkerWithFrame { $0.exist(yArray: [1], of: 2, x: 0.05, with: $1, op: .or) }
        case .rCr: return .checkerWithFrame { $0.exist(yArray: [1], of: 2, x: 0.90, with: $1, op: .or) }
        case .tLr: return .checkerWithFrame { $0.exist(yArray: [0], of: 1, x: 0.05, with: $1, op: .or) }
        case .n7_W: return .checkerWithFrame { $0.exist(xArray: [2, 3], of: 5, y: 0, with: $1, op: .and) }
        case .t_4: return .checkerWithFrame { $0.exist(yRange: 1...3, of: 8, x: 0, with: $1, op: .or) }
        case .f_2: return .checkerWithFrame {
            $0.exist(yRange: 3...7, of: 8, x: 0.4, with: $1, op: .and) ||
            $0.exist(yRange: 3...7, of: 8, x: 0.3, with: $1, op: .and)
            }
        case .botCircleLeft: return .checkerWithFrame {
            !($0.exist(xRange: 0...3, of: 8, y: 0.7, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3, of: 8, y: 0.6, with: $1, op: .allFalse))
            }
        case .topCircleRight:  return .checkerWithFrame {
            !($0.exist(xRange: 5...8, of: 8, y: 0.2, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8, of: 8, y: 0.3, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8, of: 8, y: 0.4, with: $1, op: .allFalse))
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
        case .f_t_low: return .checkerWithFrame {
            if $0.exist(xRange: 9...10, of: 10, y: 0.9, with: $1, op: .or, percent: 80) {
                return $0.exist(xRange: 0...1, of: 10, y: 0.9, with: $1, op: .or, percent: 80)
            } else {
                return true
            }

            }
        case .O_G: return .checkerWithFrame (O_GOperation)
        case .I_Z: return .checkerWithFrame {
            $0.exist(yArray: [3, 5, 7], of: 10, x: 0.5, with: $1, op: .and)

            }
        case .G_6: return .checkerWithFrame(G_6Operation)
        case .not5: return .checkerWithFrame (no5Operation)
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
        case .colon: return .checkerWithFrame (colonOperation)
        case .s_star: return .checkerWithFrame {
            var newFrame = $1
            for direction in [Direction.left, Direction.right] {
                newFrame = $1.update(by: 1, using: $0, in: direction, points: [1, 2, 3])
            }
            return $0.exist(xRange: 7...10, of: 10, y: 0.95, with: newFrame, op: .or)
            }

        case .R_K: return .checkerWithFrame {
            $0.exist(xRange: 3...5, of: 8, y: 0, with: $1, op: .and) ||
                $0.exist(xRange: 3...5, of: 8, y: 0.05, with: $1, op: .and)
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
        case .E_5: return .checkerWithFrame {
            $0.exist(yRange: 5...7, of: 10, x: 0.05, with: $1, op: .and, percent: 90)
            }
        case .G_0: return .checkerWithFrame { $0.exist(yRange: 4...8, of: 14, x: 0.95, with: $1, op: .someFalse) }
        case .G_8: return .checkerWithFrame {
           !($0.exist(xRange: 2...6, of: 10, y: 0.6, with: $1, op: .and) ||
            $0.exist(xRange: 2...6, of: 10, y: 0.5, with: $1, op: .and) ||
            $0.exist(xRange: 2...6, of: 10, y: 0.4, with: $1, op: .and))
            }
        case .N_A: return .checkerWithFrame {
             let newFrame = $1.expandFrame(by: 1, times: 4, using: $0, in: .left, with: [9])
            return $0.exist(x: 0.1, y: 0.2, in: newFrame)
            }
        case .l_1: return .checkerWithFrame (l_1Operation)
        case .i_1: return .checkerWithFrame {
            let percents: [CGFloat] = [60, 70, 80, 90, 100]
            for percent in percents {
                guard $0.exist(x: 0.5, y: 0.9, in: $1, percent: percent) else { continue }
                return !($0.exist(yRange: 3...6, of: 20, x: 0.4, with: $1, op: .and, percent: percent) ||
                    $0.exist(yRange: 3...6, of: 20, x: 0.5, with: $1, op: .and, percent: percent) ||
                    $0.exist(yRange: 3...6, of: 20, x: 0.6, with: $1, op: .and, percent: percent))
            }
            return false
            }

        case .S_5: return .checkerWithFrame (S_5Operation)
        case .doubleQuotesCustom: return .checkerWithFrame (doubleQuotesOperation)
        case .equalOrDashCustom: return .checkerWithFrame (equalOrDashOperation)
        case .bracketOrArrowCustom: return .checkerWithFrame (bracketOrArrowCustomOperation)
        case .m_a: return .checkerWithFrame (m_aOperation)
        case .s_a: return .checkerWithFrame { $0.exist(yRange: 2...4, of: 10, x: 0.9, with: $1, op: .someFalse, percent: 90) }
        case .e_a: return .checkerWithFrame {
            $0.exist(xRange: 6...9, of: 10, y: 0.9, with: $1, op: .allFalse, percent: 70) ||
                $0.exist(xRange: 6...9, of: 10, y: 0.8, with: $1, op: .allFalse, percent: 70) ||
                $0.exist(xRange: 6...9, of: 10, y: 0.7, with: $1, op: .allFalse, percent: 70) ||
                $0.exist(xRange: 6...9, of: 10, y: 0.6, with: $1, op: .allFalse, percent: 70)
            }
        case .expandFrame(let options): return .updateFrame {
            var newFrame = $1
            for direction in options.directions {
                newFrame = newFrame.expandFrame(by: 1, times: 4, using: $0, in: direction, with: [0, 1, 5, 9, 10])
            }
            print("newFrame \(newFrame)")
            return newFrame
            }
        case let .vLine(l, x, op, mainOp): return .checkerWithFrame {
            $0.exist(vLine: l, xRange: x, with: $1, op: op, mainOp: mainOp)
            }
        case let .hLine(l, y, op, mainOp): return .checkerWithFrame {
            $0.exist(hLine: l, yRange: y, with: $1, op: op, mainOp: mainOp)
            }

        }

    }

    var description: String {
        switch self {
        case .braceOrRoundL: return "braceOrRoundL"
        case .braceOrRoundR: return "braceOrRoundR"
        case .bC: return "bottomCenter"
        case .bL: return "bottomLeft"
        case .bR: return "bottomRight"
        case .c: return "center"
        case .f_t: return "f_t"
        case .G_6: return "G_6"
        case .G_C: return "G_C"
        case .H_N: return "H_N"
        case .N_A: return "N_A"
        case .I_Z: return "I_Z"
        case .K_k: return "K_k"
        case .i_1: return "i_1"
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
        case let .xy(x, y): return "xy \(x), \(y)"
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
        case .G_8: return "G_8"
        case .l_1: return "l_1"
        case .S_5: return "S_5"
        case .doubleQuotesCustom: return "quotes"
        case .equalOrDashCustom: return "equalOrDashCustom"
        case .bracketOrArrowCustom: return "bracketOrArrowCustom"
        case .expandFrame(let options ): return "expandFrame in \(options.directions)"
        case .m_a: return "m_a"
        case .e_a: return "e_a"
        case .f_2: return "f_2"
        case .f_t_low: return "f_t_low"
        case .v_u: return "v_u"
        case .E_5: return "E_5"
        case .notH: return "notH"
        case .s_a: return "s_a"
        case let .vLine(l, op, x, mainOp):
            return "vLine: \(l), lineOp: \(op), x: \(x), mainOp: \(mainOp)"
        case let .hLine(l, op, y, mainOp):
            return "hLine: \(l), lineOp: \(op), y: \(y), mainOp: \(mainOp)"
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
            return checker.exist(yArray: [6, 7, 8], of: 20, x: 0.5, with: frame, op: .or) &&
            checker.exist(yArray: [11, 12, 13, 14], of: 20, x: 0.5, with: frame, op: .or)

        }
    }

    private var l_1Operation: Operation {
        return { checker, frame in
           let newFrame = frame.expandFrame(by: 1, times: 4, using: checker, in: .top, with: [4, 5, 6])
           return
            checker.exist(xRange: 0...0, of: 10, y: 0, with: newFrame, op: .or)
        }
    }

    private var braceOrRoundLOperation: Operation {
        return { checker, frame in
            let xArray: [CGFloat] = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6]
            let yArray: [CGFloat] = [0.5, 0.4, 0.6]
            for x in xArray {
                for y in yArray {
                    guard checker.exist(x: x, y: y, in: frame) else { continue }
                    print("testOperation x: \(x), y: \(y)")
                    if checker.exist(yArray: [7, 13], of: 20, x: x + 0.05, with: frame, op: .and) {
                        return false
                    } else {
                        return true
                    }
                }
            }

            return true
        }
    }

    private var no5Operation: Operation {
        return {
            !($0.exist(xRange: 0...2, of: 6, y: 5/9, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...2, of: 6, y: 6/9, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...2, of: 6, y: 7/9, with: $1, op: .allFalse))
        }
    }

    private var O_GOperation: Operation {
        return {
                $0.exist(xRange: 8...9, of: 10, y: 2/7, with: $1, op: .or) &&
                    $0.exist(xRange: 8...9, of: 10, y: 3/7, with: $1, op: .or)
        }
    }

    private var braceOrRoundROperation: Operation {
        return { checker, frame in
            let xArray: [CGFloat] = [1, 0.9, 0.8, 0.7]
            let yArray: [CGFloat] = [0.5, 0.4, 0.6]
            for x in xArray {
                for y in yArray {
                    guard checker.exist(x: x, y: y, in: frame) else { continue }
                    print("testOperation x: \(x), y: \(y)")
                    if checker.exist(yArray: [7, 13], of: 20, x: x - 0.05, with: frame, op: .and) {
                        return false
                    } else {
                        return true
                    }
                }
            }

            return true
        }
    }
    private var v_uOperation: Operation {
        return { checker, frame in

            func isU(xArray: [CGFloat]) -> Bool {
                for x in xArray {
                    guard checker.exist(x: x, y: 0.2, in: frame) && checker.exist(x: x, y: 0.8, in: frame)
                        else { continue }
                    return true
                }
                return false
            }
            let leftXArray: [CGFloat] = [0, 0.1, 0.2]
            let rightXArray: [CGFloat] = [1, 0.9, 0.8]
            return !(isU(xArray: leftXArray) && isU(xArray: rightXArray))
        }
    }
    private var m_aOperation: Operation {
        return { checker, frame in
            guard frame.ratio <= 1.2 else { return false}
            let xArray: [CGFloat] = [0.4, 0.5, 0.6]
            let yArray: [CGFloat] = [0.3, 0.4, 0.5, 0.6, 0.7]
            var existedX: CGFloat?

            for x in xArray {
                if checker.exist(x: x, y: 0.5, in: frame, percent: 80) {
                    existedX = x
                }
            }
            guard let x = existedX else { return false }

            for y in yArray {
                if !checker.exist(x: x, y: y, in: frame, percent: 80) {
                    return false
                }
            }
            return true
        }
    }

    private var H_NOperation: Operation {
        return { checker, frame in
            let leftX: CGFloat = 0.35
            let rightX: CGFloat = 0.65
            let yArray: [CGFloat] = [0.3, 0.4, 0.6, 0.7]

            for y in yArray {
                if checker.exist(x: leftX, y: y, in: frame) != checker.exist(x: rightX, y: y, in: frame) {
                    return false
                }
            }
            return true
        }
    }

    private var vLineOperation: Operation {
        return { checker, frame in
            return  checker.exist(xRange: 1...2, of: 10, y: 0.1, with: frame, op: .or) ||
                checker.exist(xRange: 1...2, of: 10, y: 0.9, with: frame, op: .or)
        }
    }

    ///проверка скгибается ли верхняя линия
    private var S_5Operation: Operation {
        return { checker, frame in
            let yArray: [CGFloat] = [0.1, 0.15, 0.2, 0.25, 0.3]
            let xArray: [CGFloat] = [0.5, 0.6, 0.7, 0.8, 0.9]
            var findExist = false
            var emptyY: CGFloat?
            for y in yArray {
                if findExist {
                    if !checker.exist(x: 0.4, y: y, in: frame) {
                       emptyY = y
                    }
                }
                if checker.exist(x: 0.4, y: y, in: frame) {
                    findExist = true
                }
            }

            guard let y = emptyY else { return true }

            for x in xArray {
                if checker.exist(x: x, y: y, in: frame) {
                    return true
                }
            }

            return false
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

    private var colonOperation: Operation {
        return { checker, frame in
            let distance = (frame.height * 2).uintRounded()
            let topFrame = frame.update(by: distance, in: .offset(.top))
            let bottomFrame = frame.update(by: distance, in: .offset(.bottom))

            return checker.exist(yRange: 0...3, of: 10, x: 0.5, with: topFrame, op: .or) ||
                checker.exist(yRange: 7...10, of: 10, x: 0.5, with: bottomFrame, op: .or)
        }
    }

    private var equalOperation: Operation {
        return { checker, frame in
            let distance = (frame.height * 3).uintRounded()
            let topFrame = frame.update(by: distance, in: .offset(.top))
            let bottomFrame = frame.update(by: distance, in: .offset(.bottom))

            return checker.exist(yRange: 0...5, of: 10, x: 0.5, with: topFrame, op: .or) ||
                checker.exist(yRange: 5...10, of: 10, x: 0.5, with: bottomFrame, op: .or)
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
    fileprivate func expandFrame(by pixels: UInt,
                                 times: Int,
                                 using checker: LetterExistenceChecker,
                                 in direction: Direction,
                                 with points: [Int]) -> CGRect {

        var newFrame = self
        for _ in 0..<times {
            let temporaryFrame = newFrame.update(by: pixels, in: .offset(direction.optionSet))
            print("temporaryFrame \(temporaryFrame)")
            guard direction.completion(checker, points, temporaryFrame) else { break }
            newFrame = temporaryFrame
            print("newFrame \(newFrame)")
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
