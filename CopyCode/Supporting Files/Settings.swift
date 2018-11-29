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
    private static let defaultTest = false
    private static let defaultShowInitialBlock = false
    private static let defaultEnableFirebase = true
    private static let defaultShowBlock: LayerOptions = [.release]
    private static let defaultIncludeMissingChars = true
    private static let defaultShowGrid = false
    private static let defaultShowAlert = true
    private static let defaultFilterBlock = true

    static let isTest = release ? defaultTest : false
    static let enableFirebase = isDefault ? defaultEnableFirebase : true
    static let showInitialBlock = isDefault ? defaultShowInitialBlock : false
    static let showBlockOptions: LayerOptions = isDefault ? defaultShowBlock : [.debug]
    static let includeMissingChars = isDefault ? defaultIncludeMissingChars : true
    static let showGrid = isDefault ? defaultShowGrid : true
    static let showAlert = isDefault ? defaultShowAlert : false
    static let filterBlock = isDefault ? defaultFilterBlock : true

    static let shouldPrint = false
}

enum Test {
    case initialBlock
    case initialGrid
    case standart

}
