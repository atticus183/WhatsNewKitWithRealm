//
//  Model.swift
//  WhatsNewKitWithRealm
//
//  Created by Josh R on 10/12/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import RealmSwift


class UserSettings: Object {
    @objc dynamic var userVersion: Double = 1.0
}

