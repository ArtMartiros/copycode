//
//  String.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension String {
    func trimWhiteSpacesAtTheEnd() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }

    func removeAll(after: String) -> String {
        var value = self
        guard let range = value.range(of: after) else { return value }
        value.removeSubrange(range.lowerBound..<value.endIndex)
        return value
    }
}
