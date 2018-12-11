//
//  CGSize.swift
//  CopyCode
//
//  Created by Артем on 11/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension CGSize {
    func scale(by rate: CGFloat) -> CGSize {
        return CGSize(width: width * 2, height: height * 2)
    }
}
