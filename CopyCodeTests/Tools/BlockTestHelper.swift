//
//  BlockTestHelper.swift
//  CopyCodeTests
//
//  Created by Артем on 11/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct BlockTestHelper {
    private static let blockNames = ["block_one", "block_two"]
    static func getBlocks(_ object: AnyObject) -> [Block<LetterRectangle>] {
      return blockNames.compactMap {
            CodableHelper.decode(object, path: $0, structType: Block<LetterRectangle>.self, shouldPrint: false)
        }
        
    }
}
