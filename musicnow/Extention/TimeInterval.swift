//
//  TimeInterval.swift
//  musicnow
//
//  Created by Quyen on 10/7/20.
//

import Foundation


extension TimeInterval {
    func intervalToString() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.maximumUnitCount = 2
        return formatter.string(from: self)
    }
}
