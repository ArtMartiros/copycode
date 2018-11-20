//
//  GlobalValues.swift
//  CopyCode
//
//  Created by Артем on 14/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

///класс нужен для того чтобы присылать аналитику по последнему скрину
final class GlobalValues {

    static let shared = GlobalValues()
    private init() {}

    var screenImage: NSImage?
    var wordRectangles: [SimpleWord]?
    var size: CGSize?

    func clear() {
        wordRectangles = nil
        screenImage = nil
        size = nil
    }
}
