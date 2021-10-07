//
//  UIColor+Hex.swift
//  News
//
//  Created by Saffi on 2021/10/8.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1) {
        let components = (red:   CGFloat((hex >> 16) & 0xff) / 255,
                          green: CGFloat((hex >> 08) & 0xff) / 255,
                          blue:  CGFloat((hex >> 00) & 0xff) / 255)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
}
