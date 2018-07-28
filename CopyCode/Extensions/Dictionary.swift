//
//  Dictionary.swift
//  CopyCode
//
//  Created by Артем on 25/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Dictionary where Value: RangeReplaceableCollection {
    public mutating func append(element: Value.Iterator.Element, toKey key: Key) {
        var value: Value = self[key] ?? Value()
        value.append(element)
        self[key] = value
    }
}
