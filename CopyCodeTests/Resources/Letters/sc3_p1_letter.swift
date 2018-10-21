//
//  sc3_p1_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 09/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc3_p1_letter = [
    0: "//  FirebaseChat.swift",
    1: "//  Pharos",
    2: "//",
    3: "//  Created by Артем on 31.05.17.",
    4: "//  Copyright © 2017 Artem Martirosyan. All rights reserved.",
    5: "//",
    6: "import Foundation",
    7: "import Firebase",
    8: "class FirebaseChat {",
    9: "private static var ref = Database.database().reference()",
    10: "private static let userRef =",
    11: "Database.database().reference(withPath: Const.users)",
    12: "private static let emailRef =",
    13: "Database.database().reference(withPath: Const.emails)",
    14: "private static let cafeRef =",
    15: "Database.database().reference(withPath: Const.cafe)",
    16: "private static let favoriteRef =",
    17: "Database.database().reference(withPath: Const.favorites)",
    18: "private static let onlineInCafeRef =",
    19: "Database.database().reference(withPath: Const.onlineInCafe)",
    20: "private static let cafeLocationsRef =",
    21: "Database.database().reference(withPath:",
    22: "Const.cafeCoordinates)",
    23: "private static let cafeHistoryRef =",
    24: "Database.database().reference(withPath: Const.cafeHistory)",
    25: "private static let dialogsRef =",
    26: "Database.database().reference(withPath: Const.dialogs)",
    27: "class func createDialog(){",
    28: "guard let user = Saved.user else { return }",
    29: "var value = [String: Any]()",
    30: "let opponentKey = user.uid ==",
    31: "\"qCn8gPYkyAbiTNbII7YrH6RFbJl2\" ?",
    32: "\"00ZFD2Y0zjWFLIz7mpu7JRFytRM2\" :",
    33: "\"qCn8gPYkyAbiTNbII7YrH6RFbJl2\"",
    34: "let dialogID = [user.uid, opponentKey].createUID",
    35: "let cafeKey = \"-KlSxQ5NvmHuCbZpvCJ6\"",
    36: "//        let usersDialogs = \"/\\(Const.usersDialogs)/\\(user.uid)\"",
    37: "//        let userDialogInfo = UserDialog(dialogID: dialogID,",
    38: "created: Current.timestamp, opponentIDKey: ",
    39: "opponentKey).dictionary",
    40: "//",
    41: "//        let opponentDialogs = \"/\\(Const.usersDialogs)/\\",
    42: "(opponentKey)",
    43: "//        let opponentDialogsInfo = UserDialog(dialogID: dialogID,",
    44: "created: Current.timestamp, opponentIDKey: user.uid).dictionary",
    45: "//"
]
