//
//  Settings.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Settings {
    private static let defaults = UserDefaults()
    static let release = true
    private static let isDefault = true
    private static let defaultTest = false
    private static let defaultShowInitialBlock = false
    private static let defaultShowBlock: LayerOptions = [.release]
    private static let defaultIncludeMissingChars = true
    private static let defaultShowGrid = false
    private static let defaultShowAlert = true
    private static let defaultFilterBlock = true

    static let isTest = release ? defaultTest : false
    static let enableFirebase = release ? sendToFirebaseEnabling : false
    static let showInitialBlock = isDefault ? defaultShowInitialBlock : false
    static let showBlockOptions: LayerOptions = isDefault ? defaultShowBlock : [.debug]
    static let includeMissingChars = isDefault ? defaultIncludeMissingChars : true
    static let showGrid = isDefault ? defaultShowGrid : false
    static let showAlert = isDefault ? defaultShowAlert : false
    static let filterBlock = isDefault ? defaultFilterBlock : false

    static let shouldPrint = false

    private static let keySendToFirebaseEnabling = "sendToFirebaseEnabling"
    static var sendToFirebaseEnabling: Bool {
        get { return (defaults.value(forKey: keySendToFirebaseEnabling) as? Bool) ?? true }
        set { defaults.setValue(newValue, forKey: keySendToFirebaseEnabling) }
    }
}
