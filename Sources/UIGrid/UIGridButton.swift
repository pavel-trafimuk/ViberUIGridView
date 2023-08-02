//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

public struct UIGridButton: Codable, Equatable {

    public let columns: UInt
    public let rows: UInt

    public var size: UIGridSize {
        .init(width: columns, height: rows)
    }
    
    /// Background color of button
    /// #FFAABB hex format
    /// Default value, Viber button color
    public let backgroundColor: String?
    
    /// URL for background media content (picture or gif). Will be placed with aspect to fill logic
    public let backgroundMedia: URL?

    public enum BackgroundMediaType: String, Codable, UnknownDecodable {
        /// JPEG and PNG files are supported. Max size: 500 kb
        case picture
        
        case gif
        
        case unknown
    }
    
    /// Type of the background media
    /// default is picture
    public let backgroundMediaType: BackgroundMediaType
    
    public enum MediaScaleType: String, Codable, UnknownDecodable {
        /// contents scaled to fill with fixed aspect. some portion of content may be clipped
        case crop
        /// contents scaled to fill without saving fixed aspect
        case fill
        /// at least one axis (X or Y) will fit exactly, aspect is saved
        case fit
        
        case unknown
    }
    
    /// Options for scaling the bounds of the background to the bounds of this view,
    /// default is crop
    /// API: rev.6+
    public let backgroundScaleType: MediaScaleType

    /// Set True if want to loop animated background media content (gif/video)
    /// default is true
    public let isLoopInBackground: Bool
    
    /// Type of action pressing the button will perform.
    /// Reply - will send a reply to the bot.
    /// open-url - will open the specified URL and send the URL as reply to the bot.
    /// See reply logic for more details.
    /// Note: location-picker and share-phone are not supported on desktop,
    /// and require adding any text in the ActionBody parameter.
    public enum ActionType: String, Codable, UnknownDecodable {
        case none /// API: rev.2+
        case reply = "reply"
        case openUrl = "open-url"
        case sharePhone = "share-phone" /// API: rev.3+
        case locationPicker = "location-picker" /// API: rev.3+ keyboards only
        case openMap = "open-map" /// API: rev.6+
        case subscribeBot = "subscribe-bot" /// API: rev.8+, keyboards only
        
        case unknown
    }
    
    /// default is .reply
    public let actionType: ActionType
    
    /// If mode is enabled ("True" value) user action should not be presented in conversation for other participant or on other user devices
    /// default: true for inline otherwise - false
    /// API: rev.2+
    public let isSilent: Bool?
    
    public enum OpenUrlType: String, Codable, UnknownDecodable {
        public static let unknown: UIGridButton.OpenUrlType = .external
        
        case `internal`
        case external
    }
    
    /// Represents how URL will be open: in internal or external browser.
    /// Only for OpenURLMediaType="not-media".
    /// Default is .external
    public let openUrlType: OpenUrlType?
    
    public enum OpenUrlMediaType: String, Codable, UnknownDecodable {
        public static let unknown: UIGridButton.OpenUrlMediaType = .notMedia
        
        case notMedia = "not-media"
        case video
        case gif
        case picture
        case audio /// API: rev.3+
    }
    
    /// Represents type of media.
    /// It will affect on presentation of button (e.g. show play icon) and on trying to use media-viewer instead of browser.
    /// Use "not-media" to force not use any media viewing or representation logic
    /// API: rev.2+
    /// Default is .notMedia
    public let openUrlMediaType: OpenUrlMediaType?
    
    /// JSON Object, which includes media player options.
    /// Will be ignored if 'OpenURLMediaType' is not 'video' or 'audio'.
    public let mediaPlayer: UIGridButtonMediaPlayer?

    /// JSON Object, which includes internal browser configuration
    /// for OpenURL action with "internal" type. Will be ignored if action is not openUrl in internal browser.
    public let internalBrowser: UIGridInternalBrowser?

    /// Represents how Public Account can reply on user action. For "reply" action type only
    public enum ReplyType: String, Codable, UnknownDecodable {
        case query
        case message
        
        /// for future cases
        case unknown
    }
    
    /// default is .message
    public let replyType: ReplyType
    
    /// Content for the action,
    /// e.g. text(or button prefix) for reply, URL for media or URL.
    /// rev.1: always mandatory
    /// rev.2+: mandatory only for "reply" and "open-url" keys, optional for "none"
    /// rev.3+: not mandatory for "open-location" and "allow-phonenum"
    /// text or url
    public let actionBody: String?
    
    /// Valid URL. JPEG and PNG files are supported. Max size: 500 kb
    public let image: URL?
    
    /// Options for scaling the bounds of an image to the bounds of this view
    /// API: rev.6+
    /// Default is crop
    public let imageScaleType: MediaScaleType
    
    public enum TextVAlign: String, Codable, UnknownDecodable {
        public static let unknown: UIGridButton.TextVAlign = .middle
        
        case top
        case middle
        case bottom
    }
    
    /// Vertical align of the text
    /// default is middle
    public let textVAlign: TextVAlign
    
    public enum TextHAlign: String, Codable, UnknownDecodable {
        public static let unknown: UIGridButton.TextHAlign = .center
        
        case left
        case center
        case right
    }
    
    /// Horizontal align of the text
    public let textHAlign: TextHAlign
    
    // TODO: implement defaults!
    /// Custom paddings for the text in points.
    /// The value is array of Integer number [top, left, bottom, right]
    /// Ranges: 4 values, 0 .. 12
    /// Default is [12, 12, 12, 12]
    /// on iOS top and bottom paddings decrease (up to 1p) if text cannot be fit
    /// API: rev.4+
    public let textPaddings: [Int]
    
    public var isDefaultTextPaddings: Bool {
        textPaddings == Constants.textDefaultPaddings
    }
    
    /// Text with HTML tags
    public let text: String?
    
    public enum TextSize: String, Codable, UnknownDecodable {
        public static let unknown: UIGridButton.TextSize = .regular
        case small
        case regular
        case large
    }
    
    /// Text size
    /// default is .regular
    public let textSize: TextSize
    
    /// If true the size of text will decreased to fit (min.size is 12)
    /// API: rev.6+
    /// default is false
    public let isTextShouldFit: Bool
        
    /// Text opacity, Int 0..100
    /// Default is 100
    public let textOpacity: Int
    
    /// Background gradient under text,
    /// to make it more clear for users.
    /// Works only when "TextVAlign" is equal to "top or "bottom".
    /// Button draws gradient from selected text pinned edge (top or bottom) to the center of the button.
    /// Gradient will use one color from opaque at the edge to full transparent at the center.
    /// Format: #AABBCC, Hex Color
    /// Default is nil
    public let textBackgroundGradientColor: String?
    
    /// Draw frame above the background on the button,
    /// the size will be equal the size of the button
    /// API: rev.6+
    public let frame: UIGridButtonFrame?
    
    /// Configuration for open-map action
    /// API: rev.6+
    public let map: UIGridButtonMap?
    
    public enum Constants {
        public static let textDefaultPaddings = [12, 12, 12, 12]
    }
    
    private enum CodingKeys: String, CodingKey {
        case columns = "Columns"
        case rows = "Rows"
        case backgroundColor = "BgColor"
        case backgroundMedia = "BgMedia"
        case backgroundMediaType = "BgMediaType"
        case backgroundScaleType = "BgMediaScaleType"
        case isLoopInBackground = "BgLoop"
        case actionType = "ActionType"
        case isSilent = "Silent"
        case openUrlType = "OpenURLType"
        case openUrlMediaType = "OpenURLMediaType"
        case mediaPlayer = "MediaPlayer"
        case internalBrowser = "InternalBrowser"
        case replyType = "ReplyType"
        case actionBody = "ActionBody"
        case image = "Image"
        case imageScaleType = "ImageScaleType"
        case textVAlign = "TextVAlign"
        case textHAlign = "TextHAlign"
        case textPaddings = "TextPaddings"

        case text = "Text"
        case textSize = "TextSize"
        case isTextShouldFit = "TextShouldFit"
        case textOpacity = "TextOpacity"
        case textBackgroundGradientColor = "TextBgGradientColor"
        case frame = "Frame"
        case map = "Map"
    }
    
    public init(columns: UInt,
                rows: UInt,
                backgroundColor: String? = nil,
                backgroundMedia: URL? = nil,
                backgroundMediaType: UIGridButton.BackgroundMediaType = .picture,
                backgroundScaleType: UIGridButton.MediaScaleType = .crop,
                isLoopInBackground: Bool = true,
                actionType: UIGridButton.ActionType = .reply,
                isSilent: Bool,
                openUrlType: UIGridButton.OpenUrlType? = nil,
                openUrlMediaType: UIGridButton.OpenUrlMediaType? = nil,
                mediaPlayer: UIGridButtonMediaPlayer? = nil,
                internalBrowser: UIGridInternalBrowser? = nil,
                replyType: UIGridButton.ReplyType = .message,
                actionBody: String? = nil,
                image: URL? = nil,
                imageScaleType: UIGridButton.MediaScaleType = .crop,
                textVAlign: UIGridButton.TextVAlign = .middle,
                textHAlign: UIGridButton.TextHAlign = .center,
                textPaddings: [Int] = Constants.textDefaultPaddings,
                text: String? = nil,
                textSize: UIGridButton.TextSize = .regular,
                isTextShouldFit: Bool = false,
                textOpacity: Int = 100,
                textBackgroundGradientColor: String? = nil,
                frame: UIGridButtonFrame? = nil,
                map: UIGridButtonMap? = nil) {
        self.columns = columns
        self.rows = rows
        self.backgroundColor = backgroundColor
        self.backgroundMedia = backgroundMedia
        self.backgroundMediaType = backgroundMediaType
        self.backgroundScaleType = backgroundScaleType
        self.isLoopInBackground = isLoopInBackground
        self.actionType = actionType
        self.isSilent = isSilent
        self.openUrlType = openUrlType
        self.openUrlMediaType = openUrlMediaType
        self.mediaPlayer = mediaPlayer
        self.internalBrowser = internalBrowser
        self.replyType = replyType
        self.actionBody = actionBody
        self.image = image
        self.imageScaleType = imageScaleType
        self.textVAlign = textVAlign
        self.textHAlign = textHAlign
        self.textPaddings = textPaddings
        self.text = text
        self.textSize = textSize
        self.isTextShouldFit = isTextShouldFit
        self.textOpacity = textOpacity
        self.textBackgroundGradientColor = textBackgroundGradientColor
        self.frame = frame
        self.map = map
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // TODO: fix default size
        
        let columns = try container.decodeIfPresent(Int.self, forKey: .columns) ?? 0
        let rows = try container.decodeIfPresent(Int.self, forKey: .rows) ?? 0
        
        if columns >= 0 {
            self.columns = UInt(columns)
        }
        else {
            self.columns = 0
        }
        if rows >= 0 {
            self.rows = UInt(rows)
        }
        else {
            self.rows = 0
        }
        
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        self.backgroundMedia = try container.decodeIfPresent(URL.self, forKey: .backgroundMedia)
        self.backgroundMediaType = try container.decodeIfPresent(UIGridButton.BackgroundMediaType.self, forKey: .backgroundMediaType) ?? .picture
        self.backgroundScaleType = try container.decodeIfPresent(UIGridButton.MediaScaleType.self, forKey: .backgroundScaleType) ?? .crop
        if let container = try container.decodeIfPresent(SomeKindOfBool.self, forKey: .isLoopInBackground) {
            self.isLoopInBackground = container.wrappedValue
        }
        else {
            self.isLoopInBackground = true
        }
        self.actionType = try container.decodeIfPresent(UIGridButton.ActionType.self, forKey: .actionType) ?? .reply
        if let container = try container.decodeIfPresent(SomeKindOfBool.self, forKey: .isSilent) {
            self.isSilent = container.wrappedValue
        }
        else {
            self.isSilent = nil
        }
        self.openUrlType = try container.decodeIfPresent(UIGridButton.OpenUrlType.self, forKey: .openUrlType) ?? .external
        self.openUrlMediaType = try container.decodeIfPresent(UIGridButton.OpenUrlMediaType.self, forKey: .openUrlMediaType) ?? .notMedia
        self.mediaPlayer = try container.decodeIfPresent(UIGridButtonMediaPlayer.self, forKey: .mediaPlayer)
        self.internalBrowser = try container.decodeIfPresent(UIGridInternalBrowser.self, forKey: .internalBrowser)
        self.replyType = try container.decodeIfPresent(UIGridButton.ReplyType.self, forKey: .replyType) ?? .message
        self.actionBody = try container.decodeIfPresent(String.self, forKey: .actionBody)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.imageScaleType = try container.decodeIfPresent(UIGridButton.MediaScaleType.self, forKey: .imageScaleType) ?? .crop
        self.textVAlign = try container.decodeIfPresent(UIGridButton.TextVAlign.self, forKey: .textVAlign) ?? .middle
        self.textHAlign = try container.decodeIfPresent(UIGridButton.TextHAlign.self, forKey: .textHAlign) ?? .center
        
        if let paddings = try container.decodeIfPresent([Int].self, forKey: .textPaddings), paddings.count == 4 {
            self.textPaddings = paddings
        }
        else {
            self.textPaddings = Constants.textDefaultPaddings
        }
        
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.textSize = try container.decodeIfPresent(UIGridButton.TextSize.self, forKey: .textSize) ?? .regular
        
        if let container = try container.decodeIfPresent(SomeKindOfBool.self, forKey: .isTextShouldFit) {
            self.isTextShouldFit = container.wrappedValue
        }
        else {
            self.isTextShouldFit = false
        }

        if let opacity = try container.decodeIfPresent(Int.self, forKey: .textOpacity),
            opacity >= 0,
           opacity <= 100 {
            self.textOpacity = opacity
        }
        else {
            self.textOpacity = 100
        }
        self.textBackgroundGradientColor = try container.decodeIfPresent(String.self, forKey: .textBackgroundGradientColor)
        self.frame = try container.decodeIfPresent(UIGridButtonFrame.self, forKey: .frame)
        self.map = try container.decodeIfPresent(UIGridButtonMap.self, forKey: .map)
    }
}

extension UIGridButton {
    public func shouldDrawGradientUnderText() -> Bool {
        textVAlign != .middle
        && textBackgroundGradientColor != nil
        && textBackgroundGradientColor?.isEmpty == false
        && text != nil
        && text?.isEmpty == false
    }
    
    public var doesBackgroundMediaContainMapSnapshot: Bool {
        backgroundMedia?.absoluteString.lowercased().contains("maps.google.com/maps/api/staticmap") ?? false
    }
}
