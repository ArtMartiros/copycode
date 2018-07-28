//
//  Tree.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
import AppKit
import Vision

enum Action {
    case bitmapAndFrame ((NSBitmapImageRep, CGRect) -> Bool)
    case frameRatio ((CGRect) -> Bool)
}

extension Tree {
    func newFind(in bitmap: NSBitmapImageRep, with frame: CGRect, checker: WhiteColorChecker)
    func find(in bitmap: NSBitmapImageRep, with frame: CGRect) -> String? {
        ColorChecker(bitmap, whiteColor: checker)
        switch self {
        case .empty: return nil
        case .r(let element):return element
        case let .n(operation, left, right):
//            print("--" + operation.description)
            let exist: Bool
            switch operation.action {
            case .bitmapAndFrame(let action): exist = action(bitmap, frame)
            case .frameRatio(let action): exist = action(frame)
            }
            return (exist ? left : right).find(in: bitmap, with: frame)
            
        }
    }
}

enum Tree {
    typealias Operation = (_ bitmap: NSBitmapImageRep, _ frame: CGRect) -> Bool
    case empty
    case r(String)
    indirect case n(Operations, Tree, Tree)
    
    enum Operations {
        case tL, tR, tC, bL, bR, bC, lC, rC
        case tLr, lCr, rCr, tCr
        case ratio(CGFloat, (CGFloat,CGFloat)->Bool)
        /// (0,0) - is top left, (1,1) - bottom right
        case xy(x: CGFloat, y: CGFloat)
        case H_N, c, p_d, z_s, q, G_C, r_k, t_4, K_k, n8_3, f_t
        case l_i, O_G, I_Z, n83_S, n4_f, no5, n7_W, G_65
        case n_u, r3, f_W, r6, n5_9
        var action: Action {
            switch self {
            case let .ratio(ratio, operation): return .frameRatio {
//                print($0.ratio)
                return operation(ratio, $0.ratio)
                }
            case .tL: return .bitmapAndFrame { $0.isGrayscale(at: $1.tL, in: $1) }
            case .tR: return .bitmapAndFrame { $0.isY([0,5], of: 100, x: 0.95, with: $1, op: .or) }
            //{ $0.isGrayscale(at: $1.tR, in: $1) }
            case .tC: return .bitmapAndFrame { $0.isGrayscale(at: $1.tC, in: $1) }
            case .tCr: return .bitmapAndFrame { $0.isY([0,1], of: 20, x: 0.5, with: $1, op: .or) }
            //{ $0.isX([1], of: 2, y: 0.05, with: $1, op: .or) }
            case .bL: return .bitmapAndFrame { $0.isGrayscale(at: $1.bL, in: $1) }
            case .bR: return .bitmapAndFrame { $0.isY([95,100], of: 100, x: 0.95, with: $1, op: .or) }
            //{ $0.isGrayscale(at: $1.bR, in: $1) }
            case .bC: return .bitmapAndFrame { $0.isGrayscale(at: $1.bC, in: $1) }
            case .lC: return .bitmapAndFrame { $0.isGrayscale(at: $1.lC, in: $1) }
            case .rC: return .bitmapAndFrame { $0.isGrayscale(at: $1.rC, in: $1) }
            case .c: return  .bitmapAndFrame { $0.isGrayscale(at: $1.c, in: $1) }
            case .r_k: return .bitmapAndFrame { $0.isGrayscale(x: 5/11, y: 1, with: $1)}
            case .G_C: return .bitmapAndFrame { $0.isY([2], of: 3, x: 1, with: $1, op: .or) }
            case .H_N: return .bitmapAndFrame { $0.isX(2...4, of: 6, y: 0.5, with: $1, op: .and) }
            case .p_d: return .bitmapAndFrame { $0.isY([3,5], of: 7, x: 0.5, with: $1, op: .or) }
            case .z_s: return .bitmapAndFrame(z_sOperation)
            case .q: return .bitmapAndFrame(qOperation)
            case let .xy(x,y): return .bitmapAndFrame {
                let point = CGPoint(x: $1.xPositionAs(x: x), y: $1.yPositionAs(y: y))
                return $0.isGrayscale(at: point, in: $1)
                }
            case .n4_f: return .bitmapAndFrame { $0.isY(6...8, of: 9, x: 0.95, with: $1, op: .or) }
            case .n_u: return .bitmapAndFrame { $0.isX(3...4, of: 7, y: 0, with: $1, op: .or) }
            case .r3: return .bitmapAndFrame { $0.isY(3...4, of: 10, x: 0.9, with: $1, op: .or) }
            case .r6: return .bitmapAndFrame { $0.isY(6...7, of: 10, x: 0.9, with: $1, op: .or) }
            case .lCr: return .bitmapAndFrame { $0.isY([1], of: 2, x: 0.05, with: $1, op: .or) }
            case .rCr: return .bitmapAndFrame { $0.isY([1], of: 2, x: 0.90, with: $1, op: .or) }
            case .tLr: return .bitmapAndFrame { $0.isY([0], of: 1, x: 0.05, with: $1, op: .or) }
            //ищет левую точку соприкосновения у f
            case .f_W: return .bitmapAndFrame { $0.isY(4...7, of: 20, x: 0, with: $1, op: .or) }
            case .n7_W: return .bitmapAndFrame { $0.isX([2,3], of: 5, y: 0, with: $1, op: .and) }
            case .t_4: return .bitmapAndFrame { $0.isY(1...3, of: 8, x: 0, with: $1, op: .or) }
            case .n8_3: return .bitmapAndFrame {
                !($0.isX(1...3, of: 8, y: 0.7, with: $1, op: .allFalse) ||
                    $0.isX(1...3, of: 8, y: 0.6, with: $1, op: .allFalse))
                }
            case .K_k: return .bitmapAndFrame { $0.isX(6...7, of: 8, y: 0.1, with: $1, op: .or) }
            case .f_t: return .bitmapAndFrame { $0.isX(7...8, of: 8, y: 0.05, with: $1, op: .or) }
            case .l_i: return .bitmapAndFrame(I_ZOperation) //FIXME
            case .O_G: return .bitmapAndFrame {
                $0.isX(8...9, of: 10, y: 2/7, with: $1, op: .or) &&
                    $0.isX(8...9, of: 10, y: 3/7, with: $1, op: .or)
                }
            case .I_Z: return .bitmapAndFrame(I_ZOperation)
            case .n83_S: return .bitmapAndFrame {
                $0.isX(8...9, of: 10, y: 0.3, with: $1, op: .or) &&
                    $0.isX(8...9, of: 10, y: 0.4, with: $1, op: .or) }
                
            case .G_65: return .bitmapAndFrame(G_65Operation)
            case .no5: return .bitmapAndFrame(no5Operation)
                
                
                
                
                
                
            case .n5_9: return .bitmapAndFrame {
                $0.isX(6...8, of: 8, y: 0.3, with: $1, op: .allFalse) ||
                $0.isX(6...8, of: 8, y: 0.2, with: $1, op: .allFalse)
                }
//                Array(5...7).map { frame.yPositionAs(part: $0, of: 9) }
                
            }
        }
        
        var description: String {
            switch self {
            case .tL: return "topLeft"
            case .tR: return "topRight"
            case .tC: return "topCenter"
            case .r_k: return "r_k"
            case .bL: return "bottomLeft"
            case .bR: return "bottomRight"
            case .bC: return "bottomCenter"
            case .lC: return "leftCenter"
            case .rC: return "rightCenter"
            case .c: return "center"
            case .G_C: return "G_C"
            case .H_N: return "H_N"
            case .p_d: return "p_d"
            case .z_s: return "z_s"
            case .t_4: return "t_4"
            case .q: return "q_operation"
            case .ratio(let ratio): return "ratio: \(ratio)"
            case .xy(let x, let y): return "xy \(x), \(y)"
            case .K_k: return "K_k"
            case .n8_3: return "8_3"
            case .f_t: return "f_t"
            case .l_i: return "l_i"
            case .O_G: return "O_G"
            case .I_Z: return "I_Z"
            case .n83_S: return "83_S"
            case .n4_f: return "n4_f"
            case .no5: return "no5"
            case .n7_W: return "7_W"
            case .G_65: return "G_65"
            case .n_u: return "n_u"
                
            case .r3: return "r3"
                
            case .lCr: return "lcr"
                
            case .rCr: return "rCr"
                
            case .f_W: return "f_W"
                
            case .tLr: return "tLr"
                
            case .tCr: return "tCr"
                
            case .r6: return "r6"
                
            case .n5_9: return "n5_9"
                
            }
        }
        
        ///определяем ширину линии
        private var heightOperation: (_ bitmap: NSBitmapImageRep, _ frame: CGRect) -> CGFloat {
            return { bitmap, frame in
                let y = frame.yPositionAs(y: 1)
                let x = frame.xPositionAs(x: 0.5)
                let point = CGPoint(x: x, y: y)
                guard bitmap.isGrayscale(at: point, in: frame) else { return 0 }
                var lastY = y
                var isGrayscale = true
                while isGrayscale {
                    lastY += 1
                    let newPoint = CGPoint(x: x, y: lastY)
                    isGrayscale = bitmap.isGrayscale(at: newPoint, in: frame)
                }
                
                let height = lastY - y
                return height
            }
        }
        
        
        ///находим ервую черную точку линии G
        private var firsGrayscaleOperation: (_ bitmap: NSBitmapImageRep, _ frame: CGRect, _ startY: CGFloat) -> CGFloat {
            return { bitmap, frame, startY  in
                let y = startY
                let x = frame.xPositionAs(x: 0.9)
                var isGrayscale = false
                var lastY = y
                while !isGrayscale {
                    lastY -= 1
                    let newPoint = CGPoint(x: x, y: lastY)
                    isGrayscale = bitmap.isGrayscale(at: newPoint, in: frame)
                }
                return lastY
            }
        }
        
        private var firsWhiteOperation: (_ bitmap: NSBitmapImageRep, _ frame: CGRect) -> CGFloat {
            return { bitmap, frame in
                let y = frame.yPositionAs(y: 0.2)
                let x = frame.xPositionAs(x: 0.9)
                var isWhite = false
                var lastY = y
                while !isWhite {
                    lastY -= 1
                    let newPoint = CGPoint(x: x, y: lastY)
                    isWhite = !bitmap.isGrayscale(at: newPoint, in: frame)
                }
                return lastY
            }
        }
        
        private var G_65Operation: Operation {
            return { bitmap, frame in
                //так как firsGrayscaleOperation может сразу попасть на верх G то тогда будет ошибка, нужно чтобы сначала нашел пустоту, а потом от нее черный цвет
//                print("White")
                let white = self.firsWhiteOperation(bitmap, frame)
//                print("firstBlack")
                let firstBlack = self.firsGrayscaleOperation(bitmap, frame, white)
//                print("lastWhite")
                let lastWhite = firstBlack + 1
                for i in Array(4...8).reversed() {
                    let x = frame.xPositionAs(part: i, of: 8)
                    let point = CGPoint(x: x, y: lastWhite)
                    if bitmap.isGrayscale(at: point, in: frame) {
                        return false
                    }
                }
                return true
            }
        }
        
        ///проверка на отсутствие пустой линии внизу
        private var no5Operation: Operation {
            return { bitmap, frame in
                let yArray = Array(5...7).map { frame.yPositionAs(part: $0, of: 9) }
                let xArray = Array(0...2).map { frame.xPositionAs(part: $0, of: 6) }
                let oneOfLineEmpty = yArray.first { y in
                    let lineIsEmpty = xArray.first { bitmap.isGrayscale(at: CGPoint(x: $0, y: y), in: frame) } == nil
                    return lineIsEmpty
                    } != nil
                return !oneOfLineEmpty
            }
        }
        
        private var n8_3Operation: Operation {
            return { bitmap, frame in
               return  !(bitmap.isX(1...3, of: 8, y: 0.7, with: frame, op: .allFalse) ||
                bitmap.isX(1...3, of: 8, y: 0.6, with: frame, op: .allFalse))
            }
        }
        
//        private func correctFrame(frame: CGRect, in bitmap: NSBitmapImageRep) -> CGRect {
//            var minX = frame.minX
//            var isGrayscale = false
//            let y = frame.yPositionAs(y: 0.3)
//            while !isGrayscale {
//                let point = CGPoint(x: minX, y: y)
//                isGrayscale = bitmap.isGrayscale(at: point, in: frame)
//                minX = minX + 1
//            }
//            isGrayscale = false
//            var maxX = frame.maxX
//            while !isGrayscale {
//                let point = CGPoint(x: maxX, y: y)
//                isGrayscale = bitmap.isGrayscale(at: point, in: frame)
//                maxX = maxX - 1
//            }
//            let newWidth = maxX - minX
//            return CGRect(x: minX, y: frame.bottomY, width: newWidth, height: frame.height)
//        }
        
        private var I_ZOperation: Operation {
            return { bitmap, frame in
                let yPosition = frame.yPositionAs(y: 0.3)
                let point = CGPoint(x: frame.xPositionAs(x: 0.5), y: yPosition)
                
                let centerGrayscale = bitmap.isGrayscale(at: point, in: frame)
                guard centerGrayscale,
                    bitmap.sameXGrayscale(frame: frame, part: 2, of: 7, withY: yPosition),
                    bitmap.sameXGrayscale(frame: frame, part: 3, of: 7, withY: yPosition)
                    else { return false }
                return true
            }
        }
        
        private var z_sOperation: Operation {
            return { bitmap, frame in
                //изначально стояла 2 я поставил один
                // но когда разница столь мала только цветом пикселя можно отличить насколько белый
                // допустим B сразу будет черным, Z постепенно так как изначально был пиксель недостающий
                let wordFactor = WordFactor(frame: frame, in: bitmap)
                let addToX = Int(round(wordFactor.zTLx))
                let whiteColor = wordFactor.zTLXWhite
                return bitmap.grayscale(at: frame.tL, xOffset: addToX) < whiteColor
            }
        }
        
        private var qOperation: Operation {
            return { bitmap, frame in
                //было -2 и -6
                return bitmap.isGrayscale(at: frame.bR, in: frame, addToX: -2, addToY: -6)
            }
        }
        
    }
}
class ColorChecker {
    enum LogicalOperator {
        case or
        case and
        case allFalse
    }
    
    private let bitmap: NSBitmapImageRep
    private let whiteColor: WhiteColorChecker
    init(_ bitmap: NSBitmapImageRep, whiteColor: WhiteColorChecker) {
        self.bitmap = bitmap
        self.whiteColor = whiteColor
    }
    
    func isGrayscale(at point: CGPoint, in frame: CGRect) -> Bool {
        let factor = WordFactor(frame: frame, in: bitmap)
        let whiteColor = WhiteColorChecker(backgroundWhite: 0, whitePercent: factor.whiteFactor2)
        return true
//        return whiteColor.isRight(currentValue: whiteColor(at: point), with: <#T##CGFloat#>)
    }
    
    private func whiteColor(at point: CGPoint) -> CGFloat {
        let (x, y) = bitmap.convertToPixelCoordinate(point: point)
        
        let grayScaleFactor = bitmap.colorAt(x: x, y: y)?.grayScale.rounded(toPlaces: 4) ?? 0
        return grayScaleFactor
    }
    
}
extension NSBitmapImageRep {
    func isGrayscale(at point: CGPoint, in frame: CGRect, addToX x: Int = 0, addToY y: Int = 0) -> Bool {
        let factor = WordFactor(frame: frame, in: self)
        let isGraiscale = grayscale(at: point, xOffset: x, yOffset: y) < factor.whiteFactor
//        print(isGraiscale ? "✅\n" : "⭕️\n")
        return isGraiscale
    }
    
    func isGrayscale(x: CGFloat, y: CGFloat, with frame: CGRect) -> Bool {
        let point = CGPoint(x: frame.xPositionAs(x: x), y: frame.yPositionAs(y: y))
        return isGrayscale(at: point, in: frame)
    }
    
    fileprivate func isX(_ range: ClosedRange<Int>, of unit: Int, y: CGFloat,
                         with frame: CGRect, op: LogicalOperator) -> Bool {
        return isX(Array(range), of: unit, y: y, with: frame, op: op)
    }
    
    fileprivate func isX(_ array: [Int], of unit: Int, y: CGFloat,
                         with frame: CGRect, op: LogicalOperator) -> Bool {
        let points: [CGPoint] = array.map {
            CGPoint(x: frame.xPositionAs(part: $0, of: unit), y: frame.yPositionAs(y: y))
        }
        return isGrayscale(points, op: op, with: frame)
    }
    
    
    fileprivate func isY(_ range: ClosedRange<Int>, of unit: Int, x: CGFloat,
                         with frame: CGRect, op: LogicalOperator) -> Bool {
        return isY(Array(range), of: unit, x: x, with: frame, op: op)
    }
    
    fileprivate func isY(_ array: [Int], of unit: Int, x: CGFloat,
                         with frame: CGRect, op: LogicalOperator) -> Bool {
        let points: [CGPoint] = array.map { CGPoint(x: frame.xPositionAs(x: x),
                                                    y: frame.yPositionAs(part: $0, of: unit)) }
        return isGrayscale(points, op: op, with: frame)
    }
    
    
    fileprivate func grayscale(at point: CGPoint, xOffset: Int = 0, yOffset: Int = 0) -> CGFloat {
        let (x, y) = convertToPixelCoordinate(point: point)
    
        let grayScaleFactor = colorAt(x: x + xOffset, y: y + yOffset)?.grayScale.rounded(toPlaces: 4) ?? 0
//        print("Point: \(point)")
//        print("x: \(x), y: \(y)")
//        print("White: \(grayScaleFactor)")
        return grayScaleFactor
    }
    
    fileprivate func sameXGrayscale(frame: CGRect,
                                    part: Int,
                                    of number: Int,
                                    withY y: CGFloat)  -> Bool{
        let x = frame.xPositionAs(part: part, of: number)
        let alterX = frame.xPositionAs(part: number - part, of: number)
        let point = CGPoint(x: x, y: y)
        let alterPoint = CGPoint(x: alterX, y: y)
        return isGrayscale(at: point, in: frame) == isGrayscale(at: alterPoint, in: frame)
    }
    
    
    enum LogicalOperator {
        case or
        case and
        case allFalse
    }
    
    private func isGrayscale(_ points: [CGPoint],
                             op: LogicalOperator,
                             with frame: CGRect) -> Bool {
        switch op {
        case .or:  return points.first { isGrayscale(at: $0, in: frame) } != nil
        case .and: return points.first { !isGrayscale(at: $0, in: frame) } == nil
        case .allFalse: return points.first { isGrayscale(at: $0, in: frame) } == nil
        }
    }
    
}

