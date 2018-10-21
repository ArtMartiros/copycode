//
//  SortedArray.swift
//  CopyCode
//
//  Created by Артем on 15/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

public protocol SortedSet: BidirectionalCollection, CustomStringConvertible where Element: Comparable, Element: Codable {
    init()
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element)
}
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map { "\($0)" }.joined(separator: ", ")
        return "[\(contents)]"
    }

    subscript(value: Int) -> Element {
        let findedValue = Array(self)[value]
        return findedValue
    }
}

public struct SortedArray<Element: Comparable>: SortedSet where Element: Codable {
    fileprivate var storage: [Element] = []
    public init() {}

}
extension SortedArray {
    func index(for element: Element) -> Int {
        var start = 0
        var end = storage.count
        while start < end {
            let middle = start + (end - start) / 2
            if element > storage[middle] {
                start = middle + 1
            } else {
                end = middle
            }
        }
        return start
    }

    public func index(of element: Element) -> Int? {
        let index = self.index(for: element)
        guard index < count, storage[index] == element else { return nil }
        return index
    }

    mutating func remove(_ element: Element) {
        if let index = self.index(of: element) {
            storage.remove(at: index)
        }
    }

    public func contains(_ element: Element) -> Bool {
        let index = self.index(for: element)
        return index < count && storage[index] == element
    }

    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try storage.forEach(body)
    }

    public func sorted() -> [Element] {
        return storage
    }

    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let index = self.index(for: newElement)
        if index < count && storage[index] == newElement {
            return (false, storage[index])
        }
        storage.insert(newElement, at: index)
        return (true, newElement)
    }
}

extension SortedArray: RandomAccessCollection {
    public typealias Indices = CountableRange<Int>
    public var startIndex: Int { return storage.startIndex }
    public var endIndex: Int { return storage.endIndex }
    public subscript(index: Int) -> Element { return storage[index] }
}

extension SortedArray: Codable {

}
