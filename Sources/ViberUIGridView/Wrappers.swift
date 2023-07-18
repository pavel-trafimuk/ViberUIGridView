//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 13/07/2023.
//

import Foundation

@propertyWrapper
public struct SomeKindOfBool: Decodable {
    public var wrappedValue: Bool

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // Handle String value
        if let stringValue = try? container.decode(String.self) {
            switch stringValue.lowercased() {
            case "false", "no", "0": wrappedValue = false
            case "true", "yes", "1": wrappedValue = true
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expect true/false, yes/no or 0/1 but`\(stringValue)` instead")
            }
        }

        //Handle Int value
        else if let intValue = try? container.decode(Int.self) {
            switch intValue {
            case 0: wrappedValue = false
            case 1: wrappedValue = true
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expect `0` or `1` but found `\(intValue)` instead")
            }
        }

        //Handle Int value
        else if let doubleValue = try? container.decode(Double.self) {
            switch doubleValue {
            case 0: wrappedValue = false
            case 1: wrappedValue = true
            default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expect `0` or `1` but found `\(doubleValue)` instead")
            }
        }

        else {
            wrappedValue = try container.decode(Bool.self)
        }
    }
}

@propertyWrapper
struct DecodeUnknownAsNil<Enum: RawRepresentable> where Enum.RawValue: Codable {
    var wrappedValue: Enum?
}

extension DecodeUnknownAsNil : Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Enum.RawValue.self)
        wrappedValue = Enum(rawValue: raw)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue?.rawValue)
    }
}

extension KeyedDecodingContainer {
    func decode<Enum>(_ type: DecodeUnknownAsNil<Enum>.Type, forKey key: Key) throws -> DecodeUnknownAsNil<Enum> {
        return try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
    }
}

extension DecodeUnknownAsNil: Equatable where Enum: Equatable {}
extension DecodeUnknownAsNil: Hashable where Enum: Hashable {}
