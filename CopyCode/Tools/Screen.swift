//
//  Screen.swift
//  CopyCode
//
//  Created by Артем on 11/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa

class Screen {
    static var screen: NSScreen {
        return NSScreen.screens.first!
    }
    ///изменяется при смене разрешения экрана
    static var screenFrame: CGRect {
        return screen.frame
    }

    enum Retina {
        case retina(scaleFactor: CGFloat)
        case nonRetina
    }

    ///константная величина, изменение разрешения экрана не влияет
    static var retina: Retina {
        let scale = screen.backingScaleFactor
        if scale == 1 {
            return .nonRetina
        } else {
            return .retina(scaleFactor: scale)
        }
    }
}
