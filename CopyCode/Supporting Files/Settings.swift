//
//  Settings.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Settings {
    private static let isDefault = true
    private static let defaultShowBlock = false
    private static let defaultShowChars = false
    private static let defaultIncludeMissingChars = true
    private static let defaultShowTextView = true
    private static let defaultShowText = false
    private static let defaultShowGrid = false
    

    static let showBlock =  isDefault ? defaultShowBlock : false
    static let showChars = isDefault ? defaultShowChars : false
    static let includeMissingChars = isDefault ? defaultIncludeMissingChars : true
    static let showTextView =  isDefault ? defaultShowTextView : true
    static let showText = isDefault ? defaultShowText : true
    static let showGrid =  isDefault ? defaultShowGrid : false
}

