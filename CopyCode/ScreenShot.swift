//
//  ScreenShot.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa

final class Save {
    private var path: String {
        let timestamp = lround(Date().timeIntervalSince1970)
        let filename = "\(timestamp)_shot.png"
        return NSTemporaryDirectory() + filename
    }

    func save(_ image: CGImage) {
        let url = NSURL(fileURLWithPath: path)
        guard let destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) else { return }
        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)
        print(path)
    }
}

final class ScreenShot {

    @objc func capture() -> CGImage? {
        let image = CGDisplayCreateImage(CGMainDisplayID())
        return image
    }


}
