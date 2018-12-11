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

//    func test(_ image: CGImage) -> Data? {
//        guard let mutableData = CFDataCreateMutable(nil, 0),
//            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil)
//            else { return nil }
//        CGImageDestinationAddImage(destination, image, nil)
//        return CGImageDestinationFinalize(destination) ? mutableData as Data : nil
//    }

    func save(_ image: CGImage) {
        let url = NSURL(fileURLWithPath: path)
        guard let destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) else { return }
        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)
        print(path)
    }
}

extension CGImage {
    var toData: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, kUTTypePNG, 1, nil)
            else { return nil }
        print("mutableData \(mutableData)")
        CGImageDestinationAddImage(destination, self, nil)
        return CGImageDestinationFinalize(destination) ? mutableData as Data : nil
    }
}

final class ScreenShot {

    @objc func capture() -> CGImage? {
        let image = CGDisplayCreateImage(CGMainDisplayID())
        return image
    }
}
