//
//  Letter.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterRectangle: Rectangle, Hashable, Codable {
    let frame: CGRect
    let type: LetterType

    init(rect: Rectangle, type: LetterType = .undefined) {
        self.frame = rect.frame
        self.type = type
    }

    init(frame: CGRect, type: LetterType = .undefined) {
        self.frame = frame
        self.type = type
    }

    public var hashValue: Int {
        return frame.width.hashValue ^ frame.height.hashValue ^ frame.origin.x.hashValue ^ frame.origin.y.hashValue
    }

    ///коэфициент с помощью которого, мы по высоте определяем приблизительную длину символов
    private static let kHeightWidthRatio: CGFloat = 1.72

    static func letterWidth(from height: CGFloat) -> CGFloat {
        return height / kHeightWidthRatio
    }
}

extension LetterRectangle: RatioUpdatable {
    func updated(by rate: Int) -> LetterRectangle {
        let frame = updatedFrame(by: rate)
        return LetterRectangle(frame: frame, type: type)
    }
}

struct Letter: Rectangle, ValueProtocol {
    let frame: CGRect
    let value: String

    init(rectangle: Rectangle, value: String) {
        self.init(frame: rectangle.frame, value: value)
    }

    init(frame: CGRect, value: String) {
        self.frame = frame
        self.value = value
    }
}
extension Letter: RatioUpdatable {
    func updated(by rate: Int) -> Letter {
       let frame = updatedFrame(by: rate)
       return Letter(frame: frame, value: value)
    }
}
