//
//  LetterPixelFinder.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class LetterPixelFinder {

    private let kDifferenceRate: CGFloat = 0.2
    private let colorPicker: ColorPicker
    init(colorPicker: ColorPicker) {
        self.colorPicker = colorPicker
    }
    
    /// определяет есть ли буква во фрейме
    func find(in frame: CGRect) -> Bool {
        let points = ratesFrom2(frame)
            .map { CGPoint(x: frame.xAs(rate: $0.x), y: frame.yAs(rate: $0.y)) }
        var compareWhite: CGFloat?
        //находим разницу значит что то есть
        for point in points {
            let white = colorPicker.pickWhite(at: point)
            if let compareWhite = compareWhite {
                if existDifferent(compareWhite: compareWhite, currentWhite: white) {
                    return true
                }
            } else {
                compareWhite = white
            }
        }
        return false
    }
    
  
    private func existDifferent(compareWhite: CGFloat, currentWhite: CGFloat) -> Bool {
        let difference = abs(compareWhite - currentWhite)
        return difference > kDifferenceRate
    }


    private func ratesFrom2(_ frame: CGRect) -> [FrameRate] {
        let ratios1 = FrameRate.ratesFrom(xArray: [0.2, 0.4, 0.6, 0.8], yArray: [0.2, 0.4, 0.6, 0.8], in: frame)
        let ratios2 = FrameRate.ratesFrom(xArray: [0.3, 0.5, 0.7], yArray: [0.3, 0.5, 0.7], in: frame)
        let ratios3 = FrameRate.ratesFrom(xArray: [0.5], yArray: [0.9, 1], in: frame)
        let ratios = ratios1 + ratios2 + ratios3
        return ratios
    }
    
}


