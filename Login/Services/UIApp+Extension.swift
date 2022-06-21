//
//  UIApp+Extension.swift
//  Login
//
//  Created by adam janusewski on 6/14/22.
//

import Foundation
import UIKit

// Dismiss keyboard if tapped outside entry fields
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
