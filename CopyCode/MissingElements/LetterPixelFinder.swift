//
//  LetterPixelFinder.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias PixelFinderDictionary = [FrameRate: SimpleResult<CGPoint>]

class LetterPixelFinder {
    private let checker: LetterExistenceChecker
    
    init(checker: LetterExistenceChecker) {
        self.checker = checker
    }
    
    /// определяет есть ли буква во фрейме и если есть,
    /// то возвращает словарь со всеми результатами поиска либо .empty
    func find(in frame: CGRect, with edge: CGRectEdge) -> SimpleResult<PixelFinderDictionary> {
        var dictionary: PixelFinderDictionary = [:]
        let rates = ratesFrom(frame, with: edge)
        for rate in rates {
            let point = CGPoint(x: frame.xAs(rate: rate.x), y: frame.yAs(rate: rate.y))
            print("Masai \(point)")
            if checker.exist(at: point) {
                dictionary[rate] = .value(point.rounded)
                return .value(dictionary)
            } else {
                dictionary[rate] = .empty
            }
        }
        return .empty
    }

    private func ratesFrom(_ frame: CGRect, with edge: CGRectEdge) -> [FrameRate] {
        let ratios1 = FrameRate.ratesFrom(xArray: [0.2, 0.4, 0.6, 0.8], yArray: [0.2, 0.4, 0.6, 0.8], in: frame, edge: edge)
        let ratios2 = FrameRate.ratesFrom(xArray: [0.3, 0.5, 0.7], yArray: [0.3, 0.5, 0.7], in: frame, edge: edge)
        let ratios3 = FrameRate.ratesFrom(xArray: [0.5], yArray: [0.9, 1], in: frame, edge: edge)
        let ratios = ratios1 + ratios2 + ratios3
        return ratios
    }

}


