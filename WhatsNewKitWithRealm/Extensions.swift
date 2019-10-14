//
//  Extensions.swift
//  WhatsNewKitWithRealm
//
//  Created by Josh R on 10/13/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func giveRoundCorners() {
        self.layer.cornerRadius = self.layer.frame.height / 2
    }
    
    func roundCorners(by value: CGFloat) {
        self.layer.cornerRadius = value
    }
}
