//
//  ClosedRange.swift
//  CopyCode
//
//  Created by Артем on 21/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension ClosedRange where Bound == CGFloat {
    /// Returns a copy of this range clamped to the given limiting range.
    ///
    /// The bounds of the result are always limited to the bounds of `limits`.
    /// For example:
    ///
    ///     let x: ClosedRange = 0...20
    ///     print(x.clamped(to: 10...1000))
    ///     // Prints "10...20"
    ///
    /// If the two ranges do not overlap, the result is nil
    ///
    ///
    ///     let y: ClosedRange = 0...5
    ///     print(y.clamped(to: 10...1000))
    ///     // Prints "nil"
    ///
    /// - Parameter limits: The range to clamp the bounds of this range.
    /// - Returns: A new range clamped to the bounds of `limits`.

    func intesected(with newRange: ClosedRange<CGFloat>) -> ClosedRange<CGFloat>? {
        guard self.overlaps(newRange) else { return nil }
        return clamped(to: newRange)
    }

    var integers: [Int] {
        let lower = Int(lowerBound.rounded(.up))
        let upper = Int(upperBound.rounded(.down))
        guard lower <= upper else { return [] }
        let array = Array(lower...upper)
        return array
    }

    var distance: CGFloat {
        return upperBound - lowerBound
    }
}

extension ClosedRange: Codable where Bound: Codable {

}
extension ClosedRange where Bound: Codable {
    private enum CodingKeys: String, CodingKey {
        case lowerBound, upperBound
    }
    public init(from decoder: Decoder) throws {
        let dict = try [String: Bound](from: decoder)

        guard let lower = dict[CodingKeys.lowerBound.stringValue] else {
            let path = decoder.codingPath + [CodingKeys.lowerBound]
            let message = "lowerBound not found"
            throw DecodingError.valueNotFound(Bound.self, .init(codingPath: path, debugDescription: message))
        }
        guard let upper = dict[CodingKeys.upperBound.stringValue] else {
            let path = decoder.codingPath + [CodingKeys.upperBound]
            let message = "upperBound not found"
            throw DecodingError.valueNotFound(Bound.self, .init(codingPath: path, debugDescription: message))
        }

        self.init(uncheckedBounds: (lower: lower, upper: upper))
    }
}

extension ClosedRange where Bound: Codable {
    public func encode(to encoder: Encoder) throws {
        try [CodingKeys.lowerBound.stringValue: lowerBound, CodingKeys.upperBound.stringValue: upperBound].encode(to: encoder)
    }
}
