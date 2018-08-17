//
//  TreeOCR.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Tree where Node == OCROperations, Result == String {
    func find(_ colorChecker: LetterExistenceChecker, with frame: CGRect) -> String? {
        switch self {
        case .empty: return nil
        case .r(let element):return element
        case let .n(operation, left, right):
            print("--" + operation.description)
            let exist: Bool
            switch operation.action {
            case .checkerWithFrame(let action): exist = action(colorChecker, frame)
            case .frameRatio(let action): exist = action(frame)
            }
            return (exist ? left : right).find(colorChecker, with: frame)
        }
    }
}

enum OCROperations: CustomStringConvertible {
    typealias Operation = (_ checker: LetterExistenceChecker, _ frame: CGRect) -> Bool
    
    enum Action {
        case checkerWithFrame ((LetterExistenceChecker, CGRect) -> Bool)
        case frameRatio ((CGRect) -> Bool)
        
    }
    
    case tL, tR, tC, bL, bR, bC, lC, rC
    case tLr, lCr, rCr, tCr
    ///height / width
    case ratio(((CGFloat,CGFloat)->Bool), CGFloat)
    /// (0,0) - is top left, (1,1) - bottom right
    case xy(x: CGFloat, y: CGFloat)
    case expand(x: CGFloat, y: CGFloat, in: [Direction])
    case xRange(x: ClosedRange<Int>, y: CGFloat, op: LogicalOperator)
    case yRange(x: CGFloat, y: ClosedRange<Int>, op: LogicalOperator)
    case H_N, c, p_d, z_s, q, G_C, r_k, t_4, K_k, n8_3, f_t
    case l_i, O_G, I_Z, n83_S, n4_f, not5, n7_W, G_65
    case n_u, r3, f_W, r6, n5_9
    case l4
    case hyphenOrDash
    case question
    case equalOrDash
    case asterix
    case S_dollar
    case semicolon
    case colon
    case s_star
    case F_P
    case R_K
    case G_9
    case G_S
    case O_Q
    case G_0
    case n9_3
    case plus_e
    case n6_zero
    case n9_zero
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
        case .r_k: return .checkerWithFrame { $0.exist(x: 5/11, y: 1, in: $1)}
        case .G_C: return .checkerWithFrame
        { $0.exist(x: 1, y: 0.6, in: $1) }
        case .H_N: return .checkerWithFrame {
            $0.exist(xRange: 2...5, of: 7, y: 0.5, with: $1, op: .and) ||
                $0.exist(xRange: 2...5, of: 7, y: 0.4, with: $1, op: .and)
            }
        case .p_d: return .checkerWithFrame { $0.exist(yArray: [3,5], of: 7, x: 0.5, with: $1, op: .or) }
        case .z_s: return .checkerWithFrame { $0.exist(yRange: 6...7, of: 10, x: 0.95, with: $1, op: .allFalse) }
        case .q: return .checkerWithFrame { $0.exist(yArray: [9, 10], of: 10, x: 0.9, with: $1, op: .or) }
        case let .xy(x,y): return .checkerWithFrame { $0.exist(x: x, y: y, in: $1) }
        case .n4_f: return .checkerWithFrame { $0.exist(yRange: 6...8, of: 9, x: 0.95, with: $1, op: .or) }
        case .n_u: return .checkerWithFrame { $0.exist(xRange: 3...4, of: 7, y: 0, with: $1, op: .or) }
        case .r3: return .checkerWithFrame { $0.exist(yRange: 3...4, of: 10, x: 0.9, with: $1, op: .or) }
        case .r6: return .checkerWithFrame { $0.exist(yRange: 6...7, of: 10, x: 0.9, with: $1, op: .or) }
        case .lCr: return .checkerWithFrame { $0.exist(yArray: [1], of: 2, x: 0.05, with: $1, op: .or) }
        case .rCr: return .checkerWithFrame { $0.exist(yArray: [1], of: 2, x: 0.90, with: $1, op: .or) }
        case .tLr: return .checkerWithFrame { $0.exist(yArray: [0], of: 1, x: 0.05, with: $1, op: .or) }
        //ищет левую точку соприкосновения у f
        case .f_W: return .checkerWithFrame (findLeft)
        //{ $0.exist(yRange: 4...7, of: 20, x: 0, with: $1, op: .or) }
        case .n7_W: return .checkerWithFrame { $0.exist(xArray: [2,3], of: 5, y: 0, with: $1, op: .and) }
        case .t_4: return .checkerWithFrame { $0.exist(yRange: 1...3, of: 8, x: 0, with: $1, op: .or) }
        case .n8_3: return .checkerWithFrame {
            !($0.exist(xRange: 0...3, of: 8, y: 0.7, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3, of: 8, y: 0.6, with: $1, op: .allFalse))
            }
        case .K_k: return .checkerWithFrame { $0.exist(xRange: 6...7, of: 8, y: 0.1, with: $1, op: .or) }
        case .f_t: return .checkerWithFrame {
            $0.exist(xRange: 7...8, of: 8, y: 0, with: $1, op: .or) ||
                $0.exist(xRange: 7...8, of: 8, y: 0.05, with: $1, op: .or)
            }
        case .l_i: return .checkerWithFrame(z_sOperation) //FIXME
        case .O_G: return .checkerWithFrame {
            $0.exist(xRange: 8...9, of: 10, y: 2/7, with: $1, op: .or) &&
                $0.exist(xRange: 8...9, of: 10, y: 3/7, with: $1, op: .or)
            }
        case .I_Z: return .checkerWithFrame {
            $0.exist(xRange: 7...10, of: 10, y: 0.3, with: $1, op: .allFalse)
            
            }
        case .n83_S: return .checkerWithFrame {
            $0.exist(xRange: 8...9, of: 10, y: 0.3, with: $1, op: .or) &&
                $0.exist(xRange: 8...9, of: 10, y: 0.4, with: $1, op: .or) }
            
        case .G_65: return .checkerWithFrame(G_65Operation)
        case .not5: return .checkerWithFrame {
            !($0.exist(xRange: 0...2, of: 6, y: 5/9, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...2, of: 6, y: 6/9, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...2, of: 6, y: 7/9, with: $1, op: .allFalse))
            }
        case .n5_9: return .checkerWithFrame {
            $0.exist(xRange: 6...8, of: 8, y: 0.3, with: $1, op: .allFalse) ||
                $0.exist(xRange: 6...8, of: 8, y: 0.2, with: $1, op: .allFalse)
            }
        case .hyphenOrDash: return .checkerWithFrame {
            let one = $0.exist(xRange: 5...7, of: 8, y: 0.2, with: $1, op: .someFalse)
            let two = $0.exist(xRange: 1...3, of: 8, y: 0.8, with: $1, op: .someFalse)
            
            return one && two
            }
        case .l4: return .checkerWithFrame { $0.exist(yRange: 3...5, of: 10, x: 0.1, with: $1, op: .someFalse) }
        case let .xRange(x, y, op): return .checkerWithFrame { $0.exist(xRange: x, of: 10, y: y, with: $1, op: op) }
        case let .yRange(x, y, op): return .checkerWithFrame { $0.exist(yRange: y, of: 10, x: x, with: $1, op: op) }
        case .question: return .checkerWithFrame (questionDot)
        case .equalOrDash: return .checkerWithFrame (equalOperation)
        case .asterix: return .checkerWithFrame (asterixOperation)
        case .S_dollar: return .checkerWithFrame {
            !($0.exist(xRange: 4...6, of: 10, y: 0.3, with: $1, op: .or) &&
                $0.exist(xRange: 4...6, of: 10, y: 0.4, with: $1, op: .or))
            }
        case .semicolon: return .checkerWithFrame (semicolonOperation)
        case .colon: return .checkerWithFrame (equalOperation)
        case let .expand(x, y, d): return .checkerWithFrame {
            var newFrame = $1
            for direction in d {
                newFrame = self.test(array: [1], checker: $0, frame: newFrame, direction: direction)
            }
            return $0.exist(x: x, y: y, in: newFrame)
            }
        case .s_star: return .checkerWithFrame  { checker, frame in
            let directions: [Direction] = [.left, .right]
            var newFrame = frame
            for direction in directions {
                newFrame = self.test(array: [1, 2, 3], checker: checker, frame: newFrame, direction: direction)
                
            }
            
            return  checker.exist(xRange: 7...10, of: 10, y: 0.95, with: newFrame, op: .or)
            }
        case .F_P: return .checkerWithFrame {
            $0.exist(xRange: 5...8 , of: 8, y: 0.3, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8 , of: 8, y: 0.4, with: $1, op: .allFalse)
            }
            
        case .R_K: return .checkerWithFrame {
            $0.exist(xRange: 3...5 , of: 8, y: 0, with: $1, op: .and) ||
                $0.exist(xRange: 3...5 , of: 8, y: 0.05, with: $1, op: .and)
            }
        case .G_9:return .checkerWithFrame {
            $0.exist(xRange: 5...8 , of: 8, y: 0.4, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8 , of: 8, y: 0.5, with: $1, op: .allFalse) ||
                $0.exist(xRange: 5...8 , of: 8, y: 0.6, with: $1, op: .allFalse)
            }
        case .G_S: return .checkerWithFrame {
            !($0.exist(xRange: 0...3 , of: 10, y: 0.6, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3 , of: 10, y: 0.7, with: $1, op: .allFalse))
            }
            
        case .O_Q: return .checkerWithFrame {
            let newFrame = self.test(array: [9, 10], checker: $0, frame: $1, direction: .bottom)
            return $0.exist(x: 0.5, y: 1, in: newFrame)
            }
        case .n9_3: return .checkerWithFrame {
                !($0.exist(xRange: 0...4 , of: 10, y: 0.3, with: $1, op: .allFalse) ||
                    $0.exist(xRange: 0...4 , of: 10, y: 0.4, with: $1, op: .allFalse) ||
                    $0.exist(xRange: 0...4 , of: 10, y: 0.5, with: $1, op: .allFalse))
            }
        case .plus_e: return .checkerWithFrame {
            let array: [Bool] = [$0.exist(x: 0.2, y: 0.2, in: $1),
                                 $0.exist(x: 0.2, y: 0.8, in: $1),
                                 $0.exist(x: 0.8, y: 0.2, in: $1),
                                 $0.exist(x: 0.8, y: 0.8, in: $1)]
            return array.filter { $0 == false }.count >= 3
            }
        case .n6_zero:  return .checkerWithFrame {
                $0.exist(xRange: 7...10 , of: 10, y: 0.2, with: $1, op: .allFalse) ||
                $0.exist(xRange: 7...10 , of: 10, y: 0.3, with: $1, op: .allFalse) ||
                $0.exist(xRange: 7...10 , of: 10, y: 0.4, with: $1, op: .allFalse)
            }
        case .G_0: return .checkerWithFrame {
            $0.exist(yRange: 4...8 , of: 14, x: 0.95, with: $1, op: .someFalse)
        }
            
        case .n9_zero: return .checkerWithFrame {
            $0.exist(xRange: 0...3 , of: 10, y: 0.6, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3 , of: 10, y: 0.7, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3 , of: 10, y: 0.8, with: $1, op: .allFalse)
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
        case .G_65: return "G_65"
        case .G_C: return "G_C"
        case .H_N: return "H_N"
        case .I_Z: return "I_Z"
        case .K_k: return "K_k"
        case .l_i: return "l_i"
        case .lC: return "leftCenter"
        case .lCr: return "lcr"
        case .n4_f: return "n4_f"
        case .n5_9: return "n5_9"
        case .n7_W: return "7_W"
        case .n83_S: return "83_S"
        case .n8_3: return "8_3"
        case .n_u: return "n_u"
        case .not5: return "not5"
        case .O_G: return "O_G"
        case .p_d: return "p_d"
        case .q: return "q_operation"
        case .r3: return "r3"
        case .r6: return "r6"
        case .r_k: return "r_k"
        case .ratio(let ratio): return "ratio: \(ratio)"
        case .rC: return "rightCenter"
        case .rCr: return "rCr"
        case .t_4: return "t_4"
        case .tC: return "topCenter"
        case .tCr: return "tCr"
        case .tL: return "topLeft"
        case .tLr: return "tLr"
        case .tR: return "topRight"
        case .z_s: return "z_s"
        case let .xy(x,y): return "xy \(x), \(y)"
        case let .xRange(x, y, op): return "xRange: \(x), y: \(y), operator: \(op)"
        case let .yRange(x, y, op): return "yRange: \(y), x: \(x), operator: \(op)"
        case .hyphenOrDash: return "dashOrHyphen"
        case .l4:  return "l4"
        case .question: return "question"
        case .equalOrDash: return "equalOrDash"
        case .asterix: return "asterix"
        case .S_dollar: return "S_dollar"
        case .semicolon: return "semicolon"
        case .colon: return "colon"
        case .expand(let d): return "expand directions: \(d)"
        case .s_star: return "s_star"
        case .F_P: return "F_P"
        case .R_K: return "R_K"
        case .G_9: return "G_9"
            
        case .G_S: return "G_S"
            
        case .O_Q: return "O_Q"
            
        case .n9_3: return "n9_3"
            
        case .plus_e: return "plus_e"
            
        case .n6_zero: return "n6_zero"
            
        case .G_0: return "G_0"
            
        case .n9_zero: return "n9_zero"
            
        }
    }
    
    func expandTest(checker: LetterExistenceChecker, frame: CGRect, directions: [Direction]) -> CGRect {
        var newFrame = frame
        for direction in directions {
            newFrame = test(array: [1], checker: checker, frame: newFrame, direction: direction)
        }
        return newFrame
    }
    
    func test(array: [Int], checker: LetterExistenceChecker, frame: CGRect, direction: Direction) -> CGRect {
        let completion: (CGRect) -> Bool
        switch direction {
        case .top: completion = { checker.exist(xArray: array, of: 10, y: 0, with: $0, op: .or) }
        case .left: completion = { checker.exist(yArray: array, of: 10, x: 0, with: $0, op: .or) }
        case .right: completion = { checker.exist(yArray: array, of: 10, x: 1, with: $0, op: .or) }
        case .bottom: completion = { checker.exist(xArray: array, of: 10, y: 1, with: $0, op: .or) }
        }
        
        let initialStatus = completion(frame)
        
        var updatedFrame = frame
        
        for _ in 0..<4 {
            print("+++")
            let newFrame = updatedFrame.update(plus: 1, in: initialStatus ? .offset(direction) : .inset(direction))
            let status = completion(newFrame)
            if status { updatedFrame = newFrame }
            print("+++ \(updatedFrame)")
            if initialStatus != status { break }
            updatedFrame = newFrame
        }
        
        return updatedFrame
        
    }
    
    
    private var findLeft: Operation {
        return { checker, frame in
            var exist = true
            var updatedFrame = frame
            
            while exist {
                let newFrame = updatedFrame.expand(addingOfRatio: 0.05, in: .left)
                exist = checker.exist(yArray: [0,2,4,6], of: 6, x: 0, with: newFrame, op: .or)
                updatedFrame = newFrame
            }
            return checker.exist(yRange: 4...7, of: 20, x: 0, with: updatedFrame, op: .or)
        }
    }

    private var questionDot: Operation {
        return { checker, frame in
            let distance = frame.height / 2.4
            let newFrame = frame.update(plus: UInt(distance.rounded()), in: .offset(.bottom))
            
            return checker.exist(yRange: 8...10, of: 10, x: 0.4, with: newFrame, op: .or) ||
                checker.exist(yRange: 8...10, of: 10, x: 0.5, with: newFrame, op: .or)
        }
    }
    
    private var asterixOperation: Operation {
        return {
            $0.exist(xRange: 4...8, of: 8, y: 0.8, with: $1, op: .allFalse) ||
                $0.exist(xRange: 4...8, of: 8, y: 0.7, with: $1, op: .allFalse)
        }
    }
    
    private var semicolonOperation: Operation {
        return { checker, frame in
            let distance = frame.height / 1.1
            let topFrame = frame.update(plus: UInt(distance.rounded()), in: .offset(.top))
            return checker.exist(yRange: 0...2, of: 10, x: 0.5, with: topFrame, op: .or)
        }
    }
    
    private var equalOperation: Operation {
        return { checker, frame in
            let distance = frame.height * 2
            let topFrame = frame.update(plus: UInt(distance.rounded()), in: .offset(.top))
            let bottomFrame = frame.update(plus: UInt(distance.rounded()), in: .offset(.bottom))
            
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
    
    private var firsWhiteOperation: (_ checker: LetterExistenceChecker, _ frame: CGRect) -> CGFloat {
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
    
    private var G_65Operation: Operation {
        return { checker, frame in
            //так как firsGrayscaleOperation может сразу попасть на верх G то тогда будет ошибка, нужно чтобы сначала нашел пустоту, а потом от нее черный цвет
            //                print("White")
            let white = self.firsWhiteOperation(checker, frame)
            //                print("firstBlack")
            let firstBlack = self.firsGrayscaleOperation(checker, frame, white)
            //                print("lastWhite")
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
    
    private var z_sOperation: Operation {
        return { checker, frame in
            return true
            //                //изначально стояла 2 я поставил один
            //                // но когда разница столь мала только цветом пикселя можно отличить насколько белый
            //                // допустим B сразу будет черным, Z постепенно так как изначально был пиксель недостающий
            //                let wordFactor = WordFactor(frame: frame)
            //                let addToX = Int(round(wordFactor.zTLx))
            //                let whiteColor = wordFactor.zTLXWhite
            //                return checker.grayscale(at: frame.tL, xOffset: addToX) < whiteColor
        }
    }
}





