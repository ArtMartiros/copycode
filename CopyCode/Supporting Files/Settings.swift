//
//  Settings.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Settings {
    private static let isDefault = false
    private static let defaultShowBlock = false
    private static let defaultShowLines = false
    private static let defaultShowWords = false
    private static let defaultShowChars = false
    private static let defaultIncludeMissingChars = true
    private static let defaultShowTextView = true
    private static let defaultShowText = false
    private static let defaultShowGrid = false

    static let showBlock =  isDefault ? defaultShowBlock : true
    static let showLines =  isDefault ? defaultShowLines : true
    static let showWords =  isDefault ? defaultShowWords : true
    static let showChars = isDefault ? defaultShowChars : true
    static let includeMissingChars = isDefault ? defaultIncludeMissingChars : false
    static let showTextView =  isDefault ? defaultShowTextView : true
    static let showText = isDefault ? defaultShowText : true
    static let showGrid =  isDefault ? defaultShowGrid : false
}
