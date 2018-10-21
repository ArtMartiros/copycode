//
//  ScreenShot.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class ScreenShot {

    @objc func capture() -> CGImage? {
        let image = CGDisplayCreateImage(CGMainDisplayID())
        //        let url = NSURL(fileURLWithPath: path)

        //         пока не нужно
        //        guard let destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) else { return nil }
        //
        //        CGImageDestinationAddImage(destination, image!, nil)
        //        CGImageDestinationFinalize(destination)
        //        example
        //     /var/folders/bn/s6dhl0kj0qz95dcvqy1_lg_h0000gn/T/ru.v43years.CaptureScreen/1531068698_shot.png
        print(path)
        return image
    }

    private var path: String {
        let timestamp = lround(Date().timeIntervalSince1970)
        let filename = "\(timestamp)_shot.png"
        return NSTemporaryDirectory() + filename
    }
}
