//
//  FoundationExtensions.swift
//  TaskCountdown
//
//  Created by Rizky Mashudi on 17/10/21.
//

import Foundation
import UIKit

extension Int {
    func appendZeroes() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

extension Double {
    func degreeToRadians() -> CGFloat {
        return CGFloat(self * .pi) /100
    }
}
