//
//  Constants.swift
//  TaskCountdown
//
//  Created by Rizky Mashudi on 18/10/21.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: -variables
    static var hasTopNotch: Bool {
        guard #available(iOS 11, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        return window.safeAreaInsets.top >= 44
    }
}
