//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

public struct UIGridFavorites: Codable, Equatable {
    
    public enum ActionType: String, Codable, UnknownDecodable {
        case link
        case gif
        case video
        
        case unknown
    }

    // default is link
    public let type: ActionType
    
    public let url: URL?
    
    // TODO: what to do with it?
//    public let contentType: String?
    
    public let title: String?
    
    public let thumbnailUrl: URL?
    
    public let domain: String?
    
    public let thumbnailWidth: UInt
    
    public let thumbnailHeight: UInt
    
    public let force: Bool
    
    // TODO: what to do with it?
//    public let richMedia: Any?
    
    public let minApiVersion: UInt
    
    public let alternativeUrl: URL?
    
    public let alternativeText: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case url
        case title
        case thumbnailUrl = "thumbnail"
        case domain
        case thumbnailWidth = "width"
        case thumbnailHeight = "height"
        case force
        
        // TODO: what to do with it?
//        case richMedia
        case minApiVersion
        case alternativeUrl
        case alternativeText
    }
    
    public init(type: UIGridFavorites.ActionType,
                url: URL? = nil,
                title: String? = nil,
                thumbnailUrl: URL? = nil,
                domain: String? = nil,
                thumbnailWidth: UInt,
                thumbnailHeight: UInt,
                force: Bool,
                minApiVersion: UInt,
                alternativeUrl: URL? = nil,
                alternativeText: String? = nil) {
        self.type = type
        self.url = url
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.domain = domain
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.force = force
        self.minApiVersion = minApiVersion
        self.alternativeUrl = alternativeUrl
        self.alternativeText = alternativeText
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(UIGridFavorites.ActionType.self, forKey: .type) ?? .link
        
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.thumbnailUrl = try container.decodeIfPresent(URL.self, forKey: .thumbnailUrl)
        self.domain = try container.decodeIfPresent(String.self, forKey: .domain)
        self.thumbnailWidth = try container.decodeIfPresent(UInt.self, forKey: .thumbnailWidth) ?? 0
        self.thumbnailHeight = try container.decodeIfPresent(UInt.self, forKey: .thumbnailHeight) ?? 0
        if let container = try container.decodeIfPresent(SomeKindOfBool.self, forKey: .force) {
            self.force = container.wrappedValue
        }
        else {
            self.force = false
        }
        self.minApiVersion = try container.decodeIfPresent(UInt.self, forKey: .minApiVersion) ?? 1
        self.alternativeUrl = try container.decodeIfPresent(URL.self, forKey: .alternativeUrl)
        self.alternativeText = try container.decodeIfPresent(String.self, forKey: .alternativeText)
    }
}
