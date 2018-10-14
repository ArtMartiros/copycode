//
//  Settings.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Settings {
    static let release = false
    private static let isDefault = true
    private static let defaultShowInitialBlock = false
    private static let defaultShowBlock = false
    private static let defaultShowLines = false
    private static let defaultShowWords = false
    private static let defaultShowChars = false
    private static let defaultIncludeMissingChars = true
    private static let defaultShowTextView = true
    private static let defaultShowText = false
    private static let defaultShowGrid = false
    private static let defaultShowAlert = true

    static let showInitialBlock = isDefault ? defaultShowInitialBlock : false
    static let showBlock = isDefault ? defaultShowBlock : true
    static let showLines = isDefault ? defaultShowLines : true
    static let showWords = isDefault ? defaultShowWords : true
    static let showChars = isDefault ? defaultShowChars : true
    static let includeMissingChars = isDefault ? defaultIncludeMissingChars : true
    static let showTextView = isDefault ? defaultShowTextView : false
    static let showText = isDefault ? defaultShowText : false
    static let showGrid = isDefault ? defaultShowGrid : false
    static let showAlert = isDefault ? defaultShowAlert : false
}

