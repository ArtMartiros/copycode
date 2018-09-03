//
//  CodableHelper.swift
//  CopyCode
//
//  Created by Артем on 03/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class CodableHelper {
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    
    static func decode<T>(_ object: AnyObject, path: String, structType: T.Type, shouldPrint: Bool = true) -> T? where T: Decodable {
        guard let path = Bundle(for: type(of: object)).path(forResource: path, ofType: "json"),
            let json = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else { return nil }
        let data = Data(json.utf8)
        
        do {
            let structs = try decoder.decode(structType, from: data)
            if shouldPrint {
                print(structs)
            }
            
            return structs
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func encode<T: Encodable>(_ value: T) -> String {
        let data = try! encoder.encode(value)
        let descr = String(data: data, encoding: .utf8)
        return descr ?? ""
    }
    
}
