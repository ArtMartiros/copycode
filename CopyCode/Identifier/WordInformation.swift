//
//  WordInformation.swift
//  CopyCode
//
//  Created by Артем on 08/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct WordInformation: TypeChecker {
    private let _midDiffRate: CGFloat = 30

    private let checker = Checker()
    let standartLetter: CGRect

    init(standartLetter: CGRect) {
        self.standartLetter = standartLetter
    }

    init(leading: Leading, letterFrame: CGRect) {
        let gridFrame = leading.createVirtualFrame(from: letterFrame)
        self.init(standartLetter: gridFrame)
    }

    func exist(in position: Position, with frame: CGRect) -> Bool {
        switch position {
        case .top:
            return checker.isSame(standartLetter.topY, with: frame.topY, height: frame.height, accuracy: .high)
        case .mid:
            return positionOf(currentY: frame.bottomY, relativeTo: standartLetter) > _midDiffRate
        case .bottom:
            return checker.isSame(frame.bottomY, with: standartLetter.bottomY,
                                  height: standartLetter.height, accuracy: .medium)
        }
    }

    func maxHeightRatio(with frame: CGRect) -> CGFloat {
        let ratio = frame.height / standartLetter.height
        print("Ratio: \(ratio) = \(frame.height) / \(standartLetter.height)")
        return ratio
    }

    func upperOrLowForNotSure(with frame: CGRect) -> Bool {
        let topDifferent = standartLetter.topY - frame.topY
        let bottomDifferent = getBotDifferrent(with: frame)
        print("tDiff: \(topDifferent), bDiff: \(bottomDifferent)")
        return topDifferent < bottomDifferent
    }

    func lowWithTail(with frame: CGRect) -> Bool {
        let topDifferent = standartLetter.topY - frame.topY
        let bottomDifferent = getBotDifferrent(with: frame)
        let different = topDifferent - bottomDifferent
        print("Different: \(different), topDifferent \(topDifferent), bottomDifferent \(bottomDifferent) ")
        let differenceRate = different / standartLetter.height * 100
        print("differenceRate \(differenceRate )")

        return differenceRate > 12
    }

    func getBotDifferrent(with frame: CGRect) -> CGFloat {
        let bottomDifferent = frame.bottomY - standartLetter.bottomY
        return bottomDifferent
    }

    func quotesOrColumn(with frame: CGRect) -> Bool {
        let same = checker.isSame(standartLetter.topY, with: frame.topY, height: frame.height, accuracy: .superLow)
        let inTheMid = positionOf(currentY: frame.bottomY, relativeTo: standartLetter) > _midDiffRate
        return same && inTheMid
    }

    private func positionOf(currentY: CGFloat, relativeTo frame: CGRect) -> CGFloat {
        let diff = currentY - frame.bottomY
        return diff / frame.height * 100
    }
}
