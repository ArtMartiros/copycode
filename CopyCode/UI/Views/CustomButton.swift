//
//  CustomButton.swift
//  CopyCode
//
//  Created by Артем on 28/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa

final class CustomButton: NSButton {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    override var wantsUpdateLayer: Bool {
        return true
    }

    override func updateLayer() {
        layer?.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0, height: 0)
        if cell?.isHighlighted ?? false {
            layer?.contents = NSImage(named: .init("button_pressed"))!
        } else {
            layer?.contents = NSImage(named: .init("button"))!
        }
    }
}
