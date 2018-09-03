//
//  Word.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol Container: Rectangle {
    associatedtype Content: Rectangle
    var letters: [Content] { get }
}

struct Word<Child:Rectangle>: Container, Gapable {
    
    var gaps: [Gap] {
        var gaps: [Gap] = []
        letters.forEachPair {
            let gapFrame = CGRect(left: $0.frame.rightX, right: $1.frame.leftX,
                                  top: frame.topY, bottom: frame.bottomY)
            gaps.append(Gap(frame: gapFrame))
        }
        return gaps
    }
    
    let frame: CGRect
    let pixelFrame: CGRect
    let letters: [Child]
    let type: WordType 
    init(frame: CGRect, pixelFrame: CGRect, type: WordType = .undefined, letters: [Child]) {
        self.frame = frame
        self.pixelFrame = pixelFrame
        self.letters = letters
        self.type = type
    }

    static func from(_ letters: [Child]) -> Word<Child> {
        let frame = letters.map { $0.frame }.compoundFrame
        let pixelFrame = letters.map { $0.pixelFrame }.compoundFrame
        return Word(frame: frame, pixelFrame: pixelFrame, letters: letters)
    }
}


extension Word where Word.Content == Letter {
    var value: String { return letters.map { $0.value }.joined() }
}

extension Word {
    init(rect: Rectangle, type: WordType, letters: [Word.Content]) {
        self.init(frame: rect.frame, pixelFrame: rect.pixelFrame, type: type, letters: letters)
    }
}
