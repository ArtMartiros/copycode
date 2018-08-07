//
//  TreeOCR.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Tree where Node == OCROperations, Result == String {
    func find(_ colorChecker: LetterColorChecker, with frame: CGRect) -> String? {
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
    typealias Operation = (_ checker: LetterColorChecker, _ frame: CGRect) -> Bool
    
    enum Action {
        case checkerWithFrame ((LetterColorChecker, CGRect) -> Bool)
        case frameRatio ((CGRect) -> Bool)
    }
    
    case tL, tR, tC, bL, bR, bC, lC, rC
    case tLr, lCr, rCr, tCr
    case ratio(CGFloat, (CGFloat,CGFloat)->Bool)
    /// (0,0) - is top left, (1,1) - bottom right
    case xy(x: CGFloat, y: CGFloat)
    case H_N, c, p_d, z_s, q, G_C, r_k, t_4, K_k, n8_3, f_t
    case l_i, O_G, I_Z, n83_S, n4_f, not5, n7_W, G_65
    case n_u, r3, f_W, r6, n5_9
    case l4
    
    case hyphenOrDash
    var action: Action {
        switch self {
        case let .ratio(ratio, operation): return .frameRatio { operation(ratio, $0.ratio) }
        case .tL: return .checkerWithFrame { $0.exist(at: $1.tL, in: $1) }
        case .tR: return .checkerWithFrame { $0.exist(yArray:[0,5], of: 100, x: 0.95, with: $1, op: .or) }
        case .tC: return .checkerWithFrame { $0.exist(at: $1.tC, in: $1) }
        case .tCr: return .checkerWithFrame { $0.exist(yArray: [0,1], of: 20, x: 0.5, with: $1, op: .or) }
        case .bL: return .checkerWithFrame { $0.exist(at: $1.bL, in: $1) }
        case .bR: return .checkerWithFrame { $0.exist(yArray:[95,100], of: 100, x: 0.95, with: $1, op: .or) }
        case .bC: return .checkerWithFrame { $0.exist(x: 0.5, y: 0.95, in: $1) }
        //{ $0.exist(at: $1.bC, in: $1) }
        case .lC: return .checkerWithFrame { $0.exist(at: $1.lC, in: $1) }
        case .rC: return .checkerWithFrame { $0.exist(at: $1.rC, in: $1) }
        case .c: return  .checkerWithFrame { $0.exist(at: $1.c, in: $1) }
        case .r_k: return .checkerWithFrame { $0.exist(x: 5/11, y: 1, in: $1)}
        case .G_C: return .checkerWithFrame { $0.exist(x: 1, y: 2/3, in: $1) }
        case .H_N: return .checkerWithFrame {
            $0.exist(xRange: 2...5, of: 7, y: 0.5, with: $1, op: .and) ||
            $0.exist(xRange: 2...5, of: 7, y: 0.4, with: $1, op: .and)
            }
        case .p_d: return .checkerWithFrame { $0.exist(yArray: [3,5], of: 7, x: 0.5, with: $1, op: .or) }
        case .z_s: return .checkerWithFrame(z_sOperation)
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
        case .f_W: return .checkerWithFrame { $0.exist(yRange: 4...7, of: 20, x: 0, with: $1, op: .or) }
        case .n7_W: return .checkerWithFrame { $0.exist(xArray: [2,3], of: 5, y: 0, with: $1, op: .and) }
        case .t_4: return .checkerWithFrame { $0.exist(yRange: 1...3, of: 8, x: 0, with: $1, op: .or) }
        case .n8_3: return .checkerWithFrame {
            !($0.exist(xRange: 0...3, of: 8, y: 0.7, with: $1, op: .allFalse) ||
                $0.exist(xRange: 0...3, of: 8, y: 0.6, with: $1, op: .allFalse))
            }
        case .K_k: return .checkerWithFrame { $0.exist(xRange: 6...7, of: 8, y: 0.1, with: $1, op: .or) }
        case .f_t: return .checkerWithFrame { $0.exist(xRange: 7...8, of: 8, y: 0.05, with: $1, op: .or) }
        case .l_i: return .checkerWithFrame(z_sOperation) //FIXME
        case .O_G: return .checkerWithFrame {
            $0.exist(xRange: 8...9, of: 10, y: 2/7, with: $1, op: .or) &&
                $0.exist(xRange: 8...9, of: 10, y: 3/7, with: $1, op: .or)
            }
        case .I_Z: return .checkerWithFrame {
            $0.exist(x: 0.5, y: 0.3, in: $1) &&
                $0.sameMirrored(xArray: [2,3], of: 7, y: 0.3, with: $1, op: .and)
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
        case .hyphenOrDash: return "dashOrHyphen"
        case .l4:  return "l4"
        }
    }
    
    ///находим первую черную точку линии G
    private var firsGrayscaleOperation: (_ checker: LetterColorChecker, _ frame: CGRect, _ startY: CGFloat) -> CGFloat {
        return { checker, frame, startY  in
            let y = startY
            let x = frame.xAs(rate: 0.9)
            var isGrayscale = false
            var lastY = y
            while !isGrayscale {
                lastY -= 1
                let newPoint = CGPoint(x: x, y: lastY)
                isGrayscale = checker.exist(at: newPoint, in: frame)
            }
            return lastY
        }
    }
    
    private var firsWhiteOperation: (_ checker: LetterColorChecker, _ frame: CGRect) -> CGFloat {
        return { checker, frame in
            let y = frame.yAs(rate: 0.2)
            let x = frame.xAs(rate: 0.9)
            var isWhite = false
            var lastY = y
            while !isWhite {
                lastY -= 1
                let newPoint = CGPoint(x: x, y: lastY)
                isWhite = !checker.exist(at: newPoint, in: frame)
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
                if checker.exist(at: point, in: frame) {
                    return false
                }
            }
            return true
        }
    }
    
    private var z_sOperation: Operation {
        return { checker, frame in
            return true
            //FIXME
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



