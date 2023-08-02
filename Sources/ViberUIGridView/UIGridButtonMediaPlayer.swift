//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

/// JSON Object, which includes media player options. Will be ignored if 'OpenURLMediaType' is not 'video' or 'audio'.
/// API: rev.3.1+
public struct UIGridButtonMediaPlayer: Codable, Equatable {
    
    /// Media player's title (first line)
    public let title: String?
    
    /// Media player's subtitle (second line)
    public let subtitle: String?
    
    /// URL for player's thumbnail (background).
    public let thumbnailUrl: URL?
    
    /// Whether player will be looped forever or not
    /// API: rev.6+
    /// Optional, default value is false
    public let isLoop: Bool
    
    /// Custom reply data for sending in msgInfo
    /// API: rev.7+
    public let actionReplyData: String?
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case subtitle = "Subtitle"
        case thumbnailUrl = "ThumbnailURL"
        case isLoop = "Loop"
        case actionReplyData = "ActionReplyData"
    }
    
    public enum Constants {
        public static let defaultIsLoop = false
    }
    
    public init(title: String? = nil,
                subtitle: String? = nil,
                thumbnailUrl: URL? = nil,
                isLoop: Bool,
                actionReplyData: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.thumbnailUrl = thumbnailUrl
        self.isLoop = isLoop
        self.actionReplyData = actionReplyData
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl) {
            self.thumbnailUrl = URL(string: urlString)
        }
        else {
            self.thumbnailUrl = nil
        }
        if let container = try? container.decodeIfPresent(SomeKindOfBool.self, forKey: .isLoop) {
            self.isLoop = container.wrappedValue
        }
        else {
            self.isLoop = false
        }
        self.actionReplyData = try container.decodeIfPresent(String.self, forKey: .actionReplyData)
    }
}
