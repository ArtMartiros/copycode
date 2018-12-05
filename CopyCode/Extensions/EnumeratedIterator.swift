//
//  EnumeratedIterator.swift
//  CopyCode
//
//  Created by Артем on 28/11/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension EnumeratedSequence {
    public func notReversed() -> [(offset: Int, element: Base.Element)] {
        return self.map { (offset: $0.0, element: $0.1) }
    }
}
