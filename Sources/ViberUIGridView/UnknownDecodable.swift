//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 13/07/2023.
//

import Foundation

public protocol UnknownDecodable: Decodable, RawRepresentable {
    static var unknown: Self { get }
}

extension UnknownDecodable where RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(RawValue.self)
        self = Self(rawValue: raw) ?? .unknown
    }
}
