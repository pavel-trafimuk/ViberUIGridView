//
//  File.swift
//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIColor {
    convenience init?(hexString: String?) {
        guard let hexString else { return nil }
        var resultString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if resultString.hasPrefix("#") {
            resultString.removeFirst()
        }
        guard resultString.count == 6 || resultString.count == 8 else {
            return nil
        }
        let hasAlpha = resultString.count == 8
        
        var rgbValue: UInt64 = .zero
        Scanner(string: resultString).scanHexInt64(&rgbValue)
        
        let maxColorValue: CGFloat = 255
        if hasAlpha {
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / maxColorValue,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / maxColorValue,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / maxColorValue,
                alpha: CGFloat(rgbValue & 0x000000FF) / maxColorValue)
        } else {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / maxColorValue,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / maxColorValue,
                blue: CGFloat(rgbValue & 0x0000FF) / maxColorValue,
                alpha: 1)
        }
    }
}
#endif
