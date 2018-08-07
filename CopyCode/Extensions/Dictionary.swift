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

extension Dictionary where Key: Comparable, Key: Hashable {
    func valuesSortedByKeys() -> [Value] {
        let keys = self.keys.sorted()
        return keys.compactMap { self[$0] }
    }
}
extension Dictionary {
    func valuesSorted(byKey areInIncreasingOrder: (Key, Key) -> Bool) -> [Value] {
        let keys = self.keys.sorted(by: areInIncreasingOrder)
        return keys.compactMap { self[$0] }
    }
}
