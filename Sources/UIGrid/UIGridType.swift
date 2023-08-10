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
    public var defaultButtonsGridGroupSize: UIGridSize {
        switch self {
        case .keyboard: return UIGridSize(width: 6, height: 2)
        case .richMedia: return UIGridSize(width: 6, height: 7)
            
        case .unknown: return UIGridSize(width: 1, height: 1)
        }
    }
    
    public func defaultButtonSize(gridGroupSize: UIGridSize) -> UIGridSize {
        switch self {
        case .keyboard: return UIGridSize(width: gridGroupSize.width, height: 1)
        case .richMedia: return gridGroupSize
            
        case .unknown: return gridGroupSize
        }
    }
    
    public func isValid(actionType: UIGridButton.ActionType) -> Bool {
        switch self {
        case .richMedia:
            switch actionType {
            case .none, .reply, .openUrl, .openMap: return true
            case .sharePhone, .locationPicker, .subscribeBot: return false
            case .unknown: return false
            }
        case .keyboard:
            switch actionType {
            case .none, .reply, .openUrl, .openMap,.sharePhone, .locationPicker, .subscribeBot: return true
                
            case .unknown: return false
            }
        case .unknown:
            return false
        }
    }
}
