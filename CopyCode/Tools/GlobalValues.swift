//
//  GlobalValues.swift
//  CopyCode
//
//  Created by Артем on 14/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class GlobalValues {

    static let shared = GlobalValues()
    private init() {}

    var screenImage: NSImage?
    var wordRectangles: [SimpleWord]?

    func clear() {
        wordRectangles = nil
        screenImage = nil
    }
}
