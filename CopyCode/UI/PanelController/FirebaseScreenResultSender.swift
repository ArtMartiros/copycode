//
//  FirebaseScreenResultSender.swift
//  CopyCode
//
//  Created by Артем on 11/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import BoltsSwift

class FirebaseScreenResultSender {
    private var screenRef: DatabaseReference { return Database.database().reference().child("screens") }
    private var storageRef: StorageReference { return Storage.storage().reference() }
    private var currentScreenRef: DatabaseReference {
        let timeDate = Date().toString(.HHmmss)
        return screenRef.child(user).child(timeDate)
    }

    private var user: String {
        let year = Date().current(.year)
        let month = Date().current(.month)
        let day = Date().current(.day)
        return "\(year)/\(month)/\(day)"
    }

    func send() {
        guard let imageData = GlobalValues.shared.cgImage?.toData,
            let rectangles = GlobalValues.shared.wordRectangles
            else { return }

        let wordsData = rectangles.toData()
        let stringDate = Date().toString(.yyyyMMddHHmmss)
        let screenStorageRef = storageRef.child(user).child("screens").child(stringDate + ".png")
        let jsonStorageRef = storageRef.child(user).child("json").child(stringDate + ".json")
        let value = Values()

        screenStorageRef.putDataTask(imageData, metadata: nil)
            .continueOnSuccessWithTask { _ in
                screenStorageRef.downloadURLTask()
            }.continueOnSuccessWithTask { screenURL -> Task<StorageMetadata> in
                value.value["screenURL"] = screenURL.absoluteString
                return jsonStorageRef.putDataTask(wordsData, metadata: nil)
            }.continueOnSuccessWithTask { _ in
                jsonStorageRef.downloadURLTask()
            }.continueOnSuccessWith { [weak self] jsonURL -> Any? in
                guard let sself = self else { return nil }
                value.value["jsonURL"] = jsonURL.absoluteString
                sself.currentScreenRef.setValue(value.value)
                return nil
        }
    }

    class Values {
        var value: [String: Any] = [:]
        init() {
            value["screenWidth"] = Screen.screenFrame.width
            value["screenHeight"] = Screen.screenFrame.height
            value["retina"] = Screen.screen.backingScaleFactor
            value["uploadTime"] = ServerValue.timestamp()
            value["osVersion"] = osXVersion
            value["bundle"] = "\(Bundle.main.version)-\(Bundle.main.bundle)"
        }
    }
}

extension Bundle {
   fileprivate var version: String {
        return self.infoDictionary?["CFBundleShortVersionString"]  as? String  ?? ""
    }

   fileprivate var bundle: String {
        return self.infoDictionary?["CFBundleVersion"]  as? String  ?? ""
    }
}
