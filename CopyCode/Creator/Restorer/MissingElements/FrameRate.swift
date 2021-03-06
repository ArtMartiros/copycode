//
//  FrameRate.swift
//  CopyCode
//
//  Created by Артем on 29/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///Создает массив со значениями от 0 до 1 для дальнейшего создания поинтов
struct FrameRate: Hashable {
    let x: CGFloat
    let y: CGFloat

    static func ratesFrom(xArray: [CGFloat], yArray: [CGFloat], in frame: CGRect) -> [FrameRate] {
        var rates: [FrameRate] = []
        for x in xArray {
            for y in yArray {
                let rate = FrameRate(x: x, y: y)
                rates.append(rate)
            }
        }
        return rates
    }
}
