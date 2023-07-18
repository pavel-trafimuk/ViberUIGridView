//
//  UIGridButtonFrame.swift
//
//
//  Created by Pavel Trafimuk on 13/07/2023.
//  Viber Media, Inc.
//

import Foundation

/// Draw frame above the background on the button, the size will be equal the size of the button
/// API: rev.6+
public struct UIGridButtonFrame: Codable, Equatable {
    /// valid range: 0...10, default is 1
    public let borderWidth: UInt
    
    /// Color of border, format #AABBCC, default is #000000
    public let borderColor: String
    
    /// The border will be drawn with rounded corners
    /// valid range: 0...10
    public let cornerRadius: UInt
    
    public enum CodingKeys: String, CodingKey {
        case borderWidth = "BorderWidth"
        case borderColor = "BorderColor"
        case cornerRadius = "CornerRadius"
    }
    
    public enum Constants {
        public static let defaultWidth: UInt = 1
        public static let defaultColor = "#000000"
        public static let defaultRadius: UInt = 0
    }
    
    public init(borderWidth: UInt = Constants.defaultWidth,
                borderColor: String = Constants.defaultColor,
                cornerRadius: UInt = Constants.defaultRadius) {
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.borderWidth = try container.decodeIfPresent(UInt.self, forKey: .borderWidth) ?? Constants.defaultWidth
        self.borderColor = try container.decodeIfPresent(String.self, forKey: .borderColor) ?? Constants.defaultColor
        self.cornerRadius = try container.decodeIfPresent(UInt.self, forKey: .cornerRadius) ?? Constants.defaultRadius
    }
}
