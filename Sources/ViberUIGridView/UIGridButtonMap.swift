//
//  UIGridButtonMap.swift
//
//
//  Created by Pavel Trafimuk on 13/07/2023.
//  Viber Media, Inc.
//

import Foundation

/// Configuration for open-map action
/// API: rev.6+
public struct UIGridButtonMap: Codable, Equatable {
    /// Location latitude (format: "12.12345")
    public let latitudeString: String
    
    public var latitude: Double? {
        Double(latitudeString)
    }
    
    /// Location longitude (format: "3.12345")
    public let longitudeString: String

    public var longitude: Double? {
        Double(longitudeString)
    }
    
    public enum CodingKeys: String, CodingKey {
        case latitudeString = "Latitude"
        case longitudeString = "Longitude"
    }
    
    public init(latitude: String, longitude: String) {
        self.latitudeString = latitude
        self.longitudeString = longitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitudeString = try container.decodeIfPresent(String.self, forKey: .latitudeString) ?? "0.0"
        self.longitudeString = try container.decodeIfPresent(String.self, forKey: .longitudeString) ?? "0.0"
    }
}
