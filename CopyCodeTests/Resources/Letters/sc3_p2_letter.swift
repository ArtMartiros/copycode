//
//  sc3_p2_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 30/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
//9,10 W в слове view повысил, так как еще нет уменьшения, после анстака
let sc3_p2_letter = [
    0: "class UserMainViewController: UserDescrViewController {",
    1: "override func awakeFromNib() {",
    2: "super.awakeFromNib()",
    3: "userDescr = MainUser()",
    4: "}",
    5: "override func viewDidLoad() {",
    6: "super.viewDidLoad()",
    7: "infoView = EmptyTableClass().setupEmptyView(type: .userMain)",
    8: "}",
    9: "override func vieWWillAppear(_ animated: Bool) {",
    10: "super.vieWWillAppear(animated)",
    11: "userDescr = MainUser()",
    12: "}",
    13: "override func userPlacesObserve() {",
    14: "super.userPlacesObserve()",
    15: "handler = userCountingRef.child(userKey).queryOrdered(byChild:",
    16: "Const.UserPlaces.placeCount).observe(.childChanged, with: { [weak",
    17: "self]  (userPlaceSnap) in",
    18: "guard let strongSelf = self else { return }",
    19: "guard let cafe = (strongSelf.data as? [CafeItem])?.first(where: {",
    20: "(cafeItem) -> Bool in",
    21: "guard cafeItem.key == userPlaceSnap.key,",
    22: "let count = userPlaceSnap.value as? Int",
    23: "else { return false }",
    24: "cafeItem.countInPlaces = count",
    25: "return true",
    26: "}) else { return }",
    27: "strongSelf.someData.advAppend(item: cafe)",
    28: "strongSelf.data  = strongSelf.someData.sorted{$0.countInPlaces!",
    29: ">= $1.countInPlaces! }",
    30: "})",
    31: "}",
    32: "override func removeHandler() {",
    33: "//чтоб не убирать обсервер мейн просто перезаписываю пустотой"
]

//10, 11 w поменял на h это unstuck letter
let sc3_p2_letter_low = [
    0: "import UIKit",
    1: "class UserMainViewController: UserDescrViewController {",
    2: "override func awakeFromNib() {",
    3: "super.awakeFromNib()",
    4: "userDescr = MainUser()",
    5: "}",
    6: "override func viewDidLoad() {",
    7: "super.viewDidLoad()",
    8: "infoView = EmptyTableClass().setupEmptyView(type: .userMain)",
    9: "}",
    10: "override func viehWillAppear(_ animated: Bool) {",
    11: "super.viehWillAppear(animated)",
    12: "userDescr = MainUser()",
    13: "}",
    14: "override func userPlacesObserve() {",
    15: "super.userPlacesObserve()",
    16: "handler = userCountingRef.child(userKey).queryOrdered(byChild:",
    17: "Const.UserPlaces.placeCount).observe(.childChanged, with: { [weak",
    18: "self]  (userPlaceSnap) in",
    19: "guard let strongSelf = self else { return }",
    20: "guard let cafe = (strongSelf.data as? [CafeItem])?.first(where: {",
    21: "(cafeItem) -> Bool in",
    22: "guard cafeItem.key == userPlaceSnap.key,",
    23: "let count = userPlaceSnap.value as? Int",
    24: "else { return false }",
    25: "cafeItem.countInPlaces = count",
    26: "return true",
    27: "}) else { return }",
    28: "strongSelf.someData.advAppend(item: cafe)",
    29: "strongSelf.data  = strongSelf.someData.sorted{$0.countInPlaces!",
    30: ">= $1.countInPlaces! }",
//    31: "})",
    31: "}",
    32: "override func removeHandler() {",
    33: "//чтоб не убирать обсервер мейн просто перезаписываю пустотой"
]
