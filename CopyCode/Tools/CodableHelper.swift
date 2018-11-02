//
//  CodableHelper.swift
//  CopyCode
//
//  Created by Артем on 03/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension String {
    func decode<T>(as structType: T.Type) -> T? where T: Decodable {
        guard let path = Bundle.main.path(forResource: self, ofType: "json"),
            let json = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else { return nil }
        let data = Data(json.utf8)

        do {
            let structs = try JSONDecoder().decode(structType, from: data)
//            if shouldPrint {
//                print(structs)
//            }
            return structs
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func shouldPrint() {
        print(self)
    }
}

extension Encodable {
    func toJSON() -> String {
        let data = self.toData()
        let descr = String(data: data, encoding: .utf8)
        return descr ?? ""
    }

    func toData() -> Data {
        // swiftlint:disable force_try
        return try! JSONEncoder().encode(self)
    }
}
