//
//  CGFloat.swift
//  musicnow
//
//  Created by Quyen on 10/8/20.
//

import Foundation
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
