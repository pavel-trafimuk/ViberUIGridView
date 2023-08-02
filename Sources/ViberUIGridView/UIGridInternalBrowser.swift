//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

/// JSON Object, which includes internal browser configuration for OpenURL action with "internal" type. Will be ignored if action is not openUrl in internal browser.
/// API: rev.3+
public struct UIGridInternalBrowser: Codable, Equatable {
    
    public enum ActionButton: String, Codable, Equatable, UnknownDecodable {
        public static let unknown = ActionButton.none
        
        /// do not display button
        case none
        /// will open the forward via Viber screen and share current URL or predefined URL
        case forward
        /// sends the currently opened URL as an URL message, or predefined URL if property "ActionPredefinedURL" is not empty
        case send
        /// opens external browser with the current URL
        case openExternally = "open-externally"
        /// sends reply data in msgInfo to bot in order to receive message
        /// API: rev. v6+
        case sendToBot = "send-to-bot"
    }
    
    /// Action button in internal's browser navigation bar
    /// default is defined by the client
    public let actionButton: ActionButton?
  
    /// If "ActionButton" == "send" or "forward" then the value from this property will be used to be sent as message, otherwise ignored
    public let actionPredefinedURL: String?
    
    /// Type of title for internal browser if not custom
    public enum TitleType: String, Codable, Equatable, UnknownDecodable {
        public static let unknown = TitleType.default

        /// means the content in the page's <OG:title> element or in <title> tag
        case `default`
        /// means the top level domain
        case domain
    }
    /// Type of title for internal browser if not custom,
    /// default value: .default
    public let titleType: TitleType
    
    /// Custom text for internal's browser title,
    /// "TitleType" will be ignored in case this key is presented
    /// Valid length: up to 15 chars
    public let customTitle: String?
    
    public enum Mode: String, Codable, UnknownDecodable {
        public static let unknown = Mode.fullscreen

        case fullscreen
        case fullscreenPortrait = "fullscreen-portrait"
        case fullscreenLandscape = "fullscreen-landscape"
        case partialSize = "partial-size"
    }
    
    /// Indicates that browser should be opened in a full screen or in partial size (50% of screen height).
    /// Full screen mode can be with orientation lock (both orientations supported, only landscape or only portrait)
    /// Default is .fullscreen
    public let mode: Mode
    
    public enum FooterType: String, Codable, UnknownDecodable {
        public static let unknown = FooterType.`default`

        case `default`
        case hidden
    }
    
    /// Displaying browser's footer or not. By default footer is displayed.
    /// iOS only, default is default
    public let footerType: FooterType
    
    /// Custom reply data for "send-to-bot" action that will be resent in msgInfo
    /// API: rev.6+
    public let actionReplyData: String?
    
    private enum CodingKeys: String, CodingKey {
        case actionButton = "ActionButton"
        case actionPredefinedURL = "ActionPredefinedURL"
        case titleType = "TitleType"
        case customTitle = "CustomTitle"
        case mode = "Mode"
        case footerType = "FooterType"
        case actionReplyData = "ActionReplyData"
    }
    
    public init(actionButton: UIGridInternalBrowser.ActionButton? = nil,
                actionPredefinedURL: String? = nil,
                titleType: UIGridInternalBrowser.TitleType,
                customTitle: String? = nil,
                mode: UIGridInternalBrowser.Mode,
                footerType: UIGridInternalBrowser.FooterType,
                actionReplyData: String? = nil) {
        self.actionButton = actionButton
        self.actionPredefinedURL = actionPredefinedURL
        self.titleType = titleType
        self.customTitle = customTitle
        self.mode = mode
        self.footerType = footerType
        self.actionReplyData = actionReplyData
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actionButton = try container.decodeIfPresent(UIGridInternalBrowser.ActionButton.self, forKey: .actionButton)
        self.actionPredefinedURL = try container.decodeIfPresent(String.self, forKey: .actionPredefinedURL)
        self.titleType = try container.decodeIfPresent(UIGridInternalBrowser.TitleType.self, forKey: .titleType) ?? .default
        self.customTitle = try container.decodeIfPresent(String.self, forKey: .customTitle)
        self.mode = try container.decodeIfPresent(UIGridInternalBrowser.Mode.self, forKey: .mode) ?? .fullscreen
        self.footerType = try container.decodeIfPresent(UIGridInternalBrowser.FooterType.self, forKey: .footerType) ?? .default
        self.actionReplyData = try container.decodeIfPresent(String.self, forKey: .actionReplyData)
    }
    
}
