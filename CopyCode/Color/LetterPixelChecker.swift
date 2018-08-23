//
//  LetterPixelChecker.swift
//  CopyCode
//
//  Created by Артем on 22/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol LetterPixelExistenceProtocol {
    func exist(currentValue value: CGFloat) -> Bool
}

struct LetterPixelChecker: LetterPixelExistenceProtocol {
    private let backgroundWhite: CGFloat
    private let letterDefaultWhite: CGFloat
    /// From 0 to 100%
    /// Диапазон от backgroundWhite до letterWhite в котором ответ считается правильным
    /// При 100% весь диапазон счтается правильным при 0% только letterWhite
    private let whitePercent: UInt
    init(backgroundWhite: CGFloat, letterDefaultWhite: CGFloat,  whitePercent: UInt) {
        self.backgroundWhite = backgroundWhite
        self.letterDefaultWhite = letterDefaultWhite
        self.whitePercent = whitePercent
    }
    
    func exist(currentValue value: CGFloat) -> Bool {
        let allowedInterval = abs(letterDefaultWhite - backgroundWhite) / 100 * CGFloat(whitePercent)
        if letterDefaultWhite >= backgroundWhite{
            let startPoint = letterDefaultWhite - allowedInterval
            let range = startPoint.rounded(toPlaces: 3) ... 1
            print("Range \(range)")
            return range ~= value
        } else {
            let endPoint = letterDefaultWhite + allowedInterval
            let range =  0...endPoint.rounded(toPlaces: 3)
            print("Range \(range)")
            return range ~= value
        }
    }
}
