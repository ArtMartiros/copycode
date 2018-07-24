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
    func find(in bitmap: NSBitmapImageRep, with frame: CGRect) -> String? {
        print(frame)
        switch self {
        case .empty: return nil
        case .r(let element):return element
        case let .n(operation, left, right):
            print("--" + operation.description)
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
        case ratio(CGFloat, (CGFloat,CGFloat)->Bool)
        /// (0,0) - is top left, (1,1) - bottom right
        case xy(x: CGFloat, y: CGFloat)
        case H_N, c, p_d, z_s, q, G_C, r_k, t_4, K_k, n8_3, f_t
        case l_i, O_G, I_Z, n83_S, n4_f, no5, n7_W, G_65
        case u_n, r3, lCr, rCr, f_W
        var action: Action {
            switch self {
            case let .ratio(ratio, operation): return .frameRatio {
                print($0.ratio)
               return operation(ratio, $0.ratio)
                }
            case .tL: return .bitmapAndFrame { $0.isGrayscale(at: $1.tL, in: $1) }
            case .tR: return .bitmapAndFrame { $0.isGrayscale(at: $1.tR, in: $1) }
            case .tC: return .bitmapAndFrame { $0.isGrayscale(at: $1.tC, in: $1) }
            case .bL: return .bitmapAndFrame { $0.isGrayscale(at: $1.bL, in: $1) }
            case .bR: return .bitmapAndFrame { $0.isGrayscale(at: $1.bR, in: $1) }
            case .bC: return .bitmapAndFrame { $0.isGrayscale(at: $1.bC, in: $1) }
            case .lC: return .bitmapAndFrame { $0.isGrayscale(at: $1.lC, in: $1) }
            case .rC: return .bitmapAndFrame { $0.isGrayscale(at: $1.rC, in: $1) }
            case .c: return  .bitmapAndFrame { $0.isGrayscale(at: $1.c, in: $1) }
            case .r_k: return .bitmapAndFrame { $0.isGrayscaleX([5], of: 11, y: 1, with: $1, binary: .or) }
            case .G_C: return .bitmapAndFrame { $0.isGrayscaleY([2], of: 3, x: 1, with: $1, binary: .or) }
            case .H_N: return .bitmapAndFrame { $0.isGrayscaleX([2,4], of: 5, y: 0.5, with: $1, binary: .and) }
            case .p_d: return .bitmapAndFrame { $0.isGrayscaleY([3,5], of: 7, x: 0.5, with: $1, binary: .or) }
            case .z_s: return .bitmapAndFrame(z_sOperation)
            case .q: return .bitmapAndFrame(qOperation)
            case let .xy(x,y): return .bitmapAndFrame {
                let point = CGPoint(x: $1.xPositionAs(x: x), y: $1.yPositionAs(y: y))
                return $0.isGrayscale(at: point, in: $1)
                }
            case .t_4: return .bitmapAndFrame { $0.isGrayscaleY(1...3, of: 8, x: 0, with: $1, binary: .or) }
            case .K_k: return .bitmapAndFrame(K_kOperation) //FIXME
            case .n8_3: return .bitmapAndFrame(n8_3Operation) //FIXME
            case .f_t: return .bitmapAndFrame(K_kOperation) //FIXME
            case .l_i: return .bitmapAndFrame(K_kOperation) //FIXME
            case .O_G: return .bitmapAndFrame(O_GOperation)
            case .I_Z: return .bitmapAndFrame(I_ZOperation)
            case .n83_S: return .bitmapAndFrame {
                $0.isGrayscaleX(8...9, of: 10, y: 0.3, with: $1, binary: .or) &&
                $0.isGrayscaleX(8...9, of: 10, y: 0.4, with: $1, binary: .or) }
            case .n4_f: return .bitmapAndFrame { $0.isGrayscaleY(6...8, of: 9, x: 1, with: $1, binary: .or) }
            case .no5: return .bitmapAndFrame(no5Operation)
            case .n7_W: return .bitmapAndFrame { $0.isGrayscaleX([2,3], of: 5, y: 0, with: $1, binary: .and) }
            case .G_65: return .bitmapAndFrame(G_65Operation)
            case .u_n: return .bitmapAndFrame { $0.isGrayscaleX([3,4], of: 7, y: 0, with: $1, binary: .or) }
            case .r3: return .bitmapAndFrame { $0.isGrayscaleY(3...4, of: 10, x: 0.9, with: $1, binary: .or) }
            case .lCr: return .bitmapAndFrame { $0.isGrayscaleY([1], of: 20, x: 0.05, with: $1, binary: .or) }
            case .rCr: return .bitmapAndFrame { $0.isGrayscaleY([1], of: 20, x: 0.95, with: $1, binary: .or) }
            case .f_W: return .bitmapAndFrame { $0.isGrayscaleY(4...7, of: 20, x: 0.05, with: $1, binary: .or) }
                
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
            case .u_n: return "u_n"
                
            case .r3: return "r3"
                
            case .lCr: return "lcr"
                
            case .rCr: return "rCr"
                
            case .f_W: return "f_W"
                
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
                let y = frame.yPositionAs(y: 0.3)
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
                
                let white = self.firsWhiteOperation(bitmap, frame)
                print("-WHiteBU \(white)")
                let topY = self.firsGrayscaleOperation(bitmap, frame, white)
                print("-topY \(topY)")
                // - 1 нужен так как при маленьких размерах может быть ошибка изза слишком большого разброса
                let height = self.heightOperation(bitmap, frame) - 1
                print("-height \(height)")
                let botY = topY - height
                var isG = false
                for i in Array(1...6).reversed() {
                    let x = frame.xPositionAs(part: i, of: 6)
                    let topPoint = CGPoint(x: x, y: topY)
                    let botPoint = CGPoint(x: x, y: botY)
                    let topGrayscale = bitmap.isGrayscale(at: topPoint, in: frame)
                    let botGrayscale = bitmap.isGrayscale(at: botPoint, in: frame)
                     isG = topGrayscale == botGrayscale
                    if !isG { break }
                }
                return isG
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

        private var O_GOperation: Operation {
            return { bitmap, frame in
                let first = bitmap.isGrayscaleX(8...9, of: 10, y: 2/7, with: frame, binary: .or)
                let second = bitmap.isGrayscaleX(8...9, of: 10, y: 3/7, with: frame, binary: .or)
                return first && second
            }
        }
        
        private var I_ZOperation: Operation {
            return { bitmap, frame in
                
                let centerX = frame.xPositionAs(x: 4/7)
                let yPosition = frame.yPositionAs(y: 2/5)
                let point = CGPoint(x: centerX, y: yPosition)
                
                let centerGrayscale = bitmap.isGrayscale(at: point, in: frame)
                
                guard centerGrayscale,
                    bitmap.sameXGrayscale(frame: frame, part: 2, of: 7, withY: yPosition),
                    bitmap.sameXGrayscale(frame: frame, part: 3, of: 7, withY: yPosition)
                    else { return false }
                return true
            }
        }
        
        private var K_kOperation: Operation { //FIXME
            return { bitmap, frame in
                let firstX = frame.xPositionAs(x: 7/8)
                let secondX = frame.xPositionAs(x: 6/9)
                let yPosition = frame.yPositionAs(y: 1/7)
                let firstPoint = CGPoint(x: firstX, y: yPosition)
                let secondPoint = CGPoint(x: secondX, y: yPosition)
                
                return bitmap.isGrayscale(at: firstPoint, in: frame) || bitmap.isGrayscale(at: secondPoint, in: frame)
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

extension NSBitmapImageRep {
    func isGrayscale(at point: CGPoint,
                                 in frame: CGRect,
                                 addToX x: Int = 0,
                                 addToY y: Int = 0) -> Bool {
        let factor = WordFactor(frame: frame, in: self)
        let isGraiscale = grayscale(at: point, xOffset: x, yOffset: y) < factor.whiteFactor
        print(isGraiscale ? "✅\n" : "⭕️\n")
        return isGraiscale
    }
 
    fileprivate func isGrayscaleX(_ range: ClosedRange<Int>, of unit: Int, y: CGFloat,
                                  with frame: CGRect, binary: BinaryOperator) -> Bool {
        return isGrayscaleX(Array(range), of: unit, y: y, with: frame, binary: binary)
    }
    
    fileprivate func isGrayscaleX(_ array: [Int], of unit: Int, y: CGFloat,
                                  with frame: CGRect, binary: BinaryOperator) -> Bool {
        let points: [CGPoint] = array.map { CGPoint(x: frame.xPositionAs(part: $0, of: unit), y: y) }
        return isGrayscale(points, binary: binary, with: frame)
    }
    

    fileprivate func isGrayscaleY(_ range: ClosedRange<Int>, of unit: Int, x: CGFloat,
                                  with frame: CGRect, binary: BinaryOperator) -> Bool {
        return isGrayscaleY(Array(range), of: unit, x: x, with: frame, binary: binary)
    }
    
    fileprivate func isGrayscaleY(_ array: [Int], of unit: Int, x: CGFloat,
                                  with frame: CGRect, binary: BinaryOperator) -> Bool {
        let points: [CGPoint] = array.map { CGPoint(x: x, y: frame.yPositionAs(part: $0, of: unit)) }
        return isGrayscale(points, binary: binary, with: frame)
    }
    

    fileprivate func grayscale(at point: CGPoint, xOffset: Int = 0, yOffset: Int = 0) -> CGFloat {
        let (x, y) = convertToPixelCoordinate(point: point)
        let grayScaleFactor = colorAt(x: x + xOffset, y: y + yOffset)?.grayScale.rounded(toPlaces: 4) ?? 0
        print("Point: \(point)")
        print("x: \(x), y: \(y)")
        print("White: \(grayScaleFactor)")
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
    
    enum BinaryOperator {
        case or
        case and
    }
    
    private func isGrayscale(_ points: [CGPoint],
                             binary: BinaryOperator,
                             with frame: CGRect) -> Bool {
        switch binary {
        case .or:  return points.first { isGrayscale(at: $0, in: frame) } != nil
        case .and: return points.first { !isGrayscale(at: $0, in: frame) } == nil
        }
    }
    
}

