//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

public struct UIGrid: Codable, Equatable {
    
    public let type: UIGridType
    
    /// When true - the keyboard will always be displayed with the same height
    /// as the native keyboard.
    /// When false - short keyboards will be displayed with the minimal possible height.
    /// Maximal height will be native keyboard height
    /// Default value is false
    /// Valid only for type == .keyboard
    public let isDefaultHeight: Bool?
    
    /// How much percent of free screen space in chat should be taken by keyboard.
    /// The final height will be not less than height of system keyboard.
    /// Ignore DefaultHeight if we have any value here.
    /// Valid range: 40 .. 70
    /// Valid only for type == .keyboard
    /// Default value: no default value, means that no custom height
    /// API: rev.3+
    public let customDefaultHeight: Int?
    
    /// Array containing all keyboard buttons by order.
    /// See buttons parameters below for buttons parameters details
    public let buttons: [UIGridButton]
    
    /// Represent size of block in rich-media or keyboard,
    /// used for grouping buttons by blocks during layout
    public let buttonsGroupColumns: Int?
    
    /// Represent size of block in rich-media or keyboard,
    /// used for grouping buttons by blocks during layout. Similar to buttons group in botKeyboard
    public let buttonsGroupRows: Int?
    
    /// Allow use custom aspect ratio for rich media blocks.
    /// Scales the height of the default square block (which is defined on client side) to the given value in percents.
    /// It means blocks can become not square and it can be used to create
    /// rich messages with correct custom aspect ratio.
    /// This is applied for all blocks in the rich message.
    /// Only for type == .richMessage
    /// Valid range: 20 .. 100 (in percents)
    /// Block size cannot be bigger than default client value.
    /// Default is 100 (use default client's block sizes)
    /// API: rev3.+
    public let heightScale: Int?
    
    /// #FFAABB hex format
    /// Default value, Viber keyboard background
    public let backgroundColor: String?
    
    public enum InputFieldState: String, Codable, UnknownDecodable {
        public static let unknown: UIGrid.InputFieldState = .regular
        
        /// display regular size input field
        case regular
        
        /// display input field minimized by default
        case minimized
        
        /// hide input field
        case hidden
    }
    
    /// Customize the keyboard input field.
    /// Default value is regular
    /// API: rev.3+
    public let inputFieldState: InputFieldState?
    
    /// API: rev.6+
    public let favoritesMetadata: UIGridFavorites?
    
    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case isDefaultHeight = "DefaultHeight"
        case customDefaultHeight = "CustomDefaultHeight"
        case buttons = "Buttons"
        case buttonsGroupColumns = "ButtonsGroupColumns"
        case buttonsGroupRows = "ButtonsGroupRows"
        case heightScale = "HeightScale"
        case backgroundColor = "BgColor"
        case inputFieldState = "InputFieldState"
        case favoritesMetadata = "FavoritesMetadata"
    }
    
    public enum Constants {
        static let defaultHeightScale = 100
    }
    
    public init(type: UIGridType,
                isDefaultHeight: Bool? = nil,
                customDefaultHeight: Int? = nil,
                buttons: [UIGridButton],
                buttonsGroupColumns: Int? = nil,
                buttonsGroupRows: Int? = nil,
                heightScale: Int? = nil,
                backgroundColor: String? = nil,
                inputFieldState: UIGrid.InputFieldState? = nil,
                favoritesMetadata: UIGridFavorites? = nil) {
        self.type = type
        self.isDefaultHeight = isDefaultHeight
        self.customDefaultHeight = customDefaultHeight
        self.buttons = buttons
        self.buttonsGroupColumns = buttonsGroupColumns
        self.buttonsGroupRows = buttonsGroupRows
        self.heightScale = heightScale
        self.backgroundColor = backgroundColor
        self.inputFieldState = inputFieldState
        self.favoritesMetadata = favoritesMetadata
    }
    
    public static let emptyKeyboard = UIGrid(type: .keyboard,
                                             isDefaultHeight: true,
                                             customDefaultHeight: nil,
                                             buttons: [.init(columns: 2,
                                                             rows: 2,
                                                             actionType: .none,
                                                             isSilent: false)],
                                             buttonsGroupColumns: nil,
                                             buttonsGroupRows: nil,
                                             heightScale: nil,
                                             backgroundColor: nil,
                                             inputFieldState: nil,
                                             favoritesMetadata: nil)
    
    public static func forKeyboard(with buttons: [UIGridButton],
                                   isDefaultHeight: Bool,
                                   customDefaultHeight: Int? = nil,
                                   buttonsGroupColumns: Int,
                                   buttonsGroupRows: Int,
                                   backgroundColor: String? = nil,
                                   inputFieldState: InputFieldState = .regular) throws -> Self {
        guard !buttons.isEmpty else {
            throw UIGridError.emptyButtons
        }
        
        return UIGrid(type: .keyboard,
                      isDefaultHeight: isDefaultHeight,
                      customDefaultHeight: customDefaultHeight,
                      buttons: buttons,
                      buttonsGroupColumns: buttonsGroupColumns,
                      buttonsGroupRows: buttonsGroupRows,
                      heightScale: nil,
                      backgroundColor: backgroundColor,
                      inputFieldState: inputFieldState,
                      favoritesMetadata: nil)
    }
    
    public static func forRichMessage(with buttons: [UIGridButton],
                                      buttonsGroupColumns: Int? = nil,
                                      buttonsGroupRows: Int? = nil,
                                      backgroundColor: String? = nil) throws -> Self {
        guard !buttons.isEmpty else {
            throw UIGridError.emptyButtons
        }
        
        return UIGrid(type: .keyboard,
                      isDefaultHeight: nil,
                      customDefaultHeight: nil,
                      buttons: buttons,
                      buttonsGroupColumns: buttonsGroupColumns,
                      buttonsGroupRows: buttonsGroupRows,
                      heightScale: nil,
                      backgroundColor: backgroundColor,
                      inputFieldState: nil,
                      favoritesMetadata: nil)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(UIGridType.self, forKey: .type) ?? .unknown
        self.isDefaultHeight = try container.decodeIfPresent(SomeKindOfBool.self, forKey: .isDefaultHeight)?.wrappedValue
        self.customDefaultHeight = try container.decodeIfPresent(Int.self, forKey: .customDefaultHeight)
        guard let buttons = try container.decodeIfPresent([UIGridButton].self, forKey: .buttons),
              !buttons.isEmpty else {
                  throw UIGridError.emptyButtons
              }
        self.buttons = buttons
        self.buttonsGroupColumns = try container.decodeIfPresent(Int.self, forKey: .buttonsGroupColumns)
        self.buttonsGroupRows = try container.decodeIfPresent(Int.self, forKey: .buttonsGroupRows)
        self.heightScale = try container.decodeIfPresent(Int.self, forKey: .heightScale)
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        self.inputFieldState = try container.decodeIfPresent(UIGrid.InputFieldState.self, forKey: .inputFieldState)
        self.favoritesMetadata = try container.decodeIfPresent(UIGridFavorites.self, forKey: .favoritesMetadata)
    }
    
    /// ex isGIFExist
    public var containsGIF: Bool {
        buttons.contains(where: { $0.backgroundMediaType == .gif })
    }
    
    /// ex isDefaultScale
    public var isDefaultHeightScale: Bool {
        heightScale == nil || heightScale == Constants.defaultHeightScale
    }
    
    // TODO: implement builder
//    public static let keyboard(buttonBuilders: [UIGridButtonBuilder?],
//                               isDefaultHeight: Bool? = nil,
//                               customDefaultHeight: Int? = nil,
//                               buttonsGroupColumns: Int? = nil,
//                               buttonsGroupRows: Int? = nil,
//                               isDefaultHeight: Bool = false,
//                               backgroundColor: String? = nil,
//                               inputFieldState: InputFieldState = .regular) throws -> Self {
//        UIGrid(type: .keyboard,
//               isDefaultHeight: isDefaultHeight,
//               customDefaultHeight: nil,
//               buttons: [.init(columns: 2,
//                               rows: 2,
//                               actionType: .none,
//                               isSilent: false)],
//               buttonsGroupColumns: nil,
//               buttonsGroupRows: nil,
//               heightScale: nil,
//               backgroundColor: nil,
//               inputFieldState: nil,
//               favoritesMetadata: nil)
//    }
//
//    public static func keyboard(with buttonBuilders: [UIGridButtonBuilder?],
//                                buttonsGroupColumns: Int? = nil,
//                                buttonsGroupRows: Int? = nil,
//                                isDefaultHeight: Bool = false,
//                                customDefaultHeight: Int? = nil,
//                                backgroundColor: String? = nil,
//                                inputFieldState: InputFieldState = .regular) throws -> Self {
//        let buttons = try buttonBuilders.map({ builder in
//            try builder?.build()
//        }).compactMap({ $0 })
//        guard !buttons.isEmpty else {
//            throw UIGridError.emptyButtons
//        }
//        
//        return .init(type: .keyboard,
//                     isDefaultHeight: isDefaultHeight,
//                     customDefaultHeight: customDefaultHeight,
//                     backgroundColor: backgroundColor,
//                     buttons: buttons,
//                     buttonsGroupColumns: buttonsGroupColumns,
//                     buttonsGroupRows: buttonsGroupRows,
//                     inputFieldState: inputFieldState)
//    }
}
