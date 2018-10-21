//
//  ButtonCreator.swift
//  CopyCode
//
//  Created by Артем on 11/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class ButtonCreator {

    func create(title: NSAttributedString, selector: Selector, position: CGPoint) -> CustomButton {
        let button = CustomButton(title: title.string, target: nil, action: selector)
        button.attributedTitle = title
        button.sizeToFit()
        button.frame.origin = position
        return button
    }
}
