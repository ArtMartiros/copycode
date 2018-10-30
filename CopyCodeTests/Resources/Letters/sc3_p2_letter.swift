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
