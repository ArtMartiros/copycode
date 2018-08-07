//
//  DecodeHelper.swift
//  CopyCodeTests
//
//  Created by Артем on 08/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class DecodeHelper {
    private static let decoder = JSONDecoder()
    static func decode<T>(_ object: AnyObject, path: String, structType: T.Type) -> T? where T: Decodable {
        guard let path = Bundle(for: type(of: object)).path(forResource: path, ofType: "json"),
            let json = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else { return nil }
        let data = Data(json.utf8)

        do {
            let structs = try decoder.decode(structType, from: data)

            print(structs)
            return structs
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
