//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

public enum UIGridType: String, Codable, UnknownDecodable {
    case keyboard
    case richMedia = "rich_media"
    
    // for all future cases
    case unknown
}

extension UIGridType {
    public var defaultButtonsGroupSize: UIGridSize {
        switch self {
        case .keyboard: return .init(columns: 6, rows: 2)
        case .richMedia: return .init(columns: 6, rows: 7)
            
        case .unknown: return .init(columns: 1, rows: 1)
        }
    }
    
    public func defaultButtonSize(groupSize: UIGridSize) -> UIGridSize {
        switch self {
        case .keyboard: return .init(columns: groupSize.columns, rows: 1)
        case .richMedia: return groupSize
            
        case .unknown: return groupSize
        }
    }
    
//    public func isValid(actionType: UIGridButton.ActionType) -> Bool {
//        switch self {
//        case .richMedia:
//            switch actionType {
//            case .none, .reply, .openUrl, .openMap: return true
//            case .sharePhone, .locationPicker, .subscribeBot: return false
//            }
//        case .keyboard:
//            switch actionType {
//            case .none, .reply, .openUrl, .openMap,.sharePhone, .locationPicker, .subscribeBot: return true
//            }
//        }
//    }
}
