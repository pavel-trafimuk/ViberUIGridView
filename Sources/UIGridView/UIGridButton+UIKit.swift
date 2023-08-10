//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import UIGrid

public extension UIGridButton.TextSize {
    var fontSize: Double {
        var result: Double
        switch self {
        case .small: result = 12.0
        case .regular: result = 14.0
        case .large: result = 16.0
        }
        return UIFontMetrics(forTextStyle: .body).scaledValue(for: result)
    }
}

public extension UIGridButton {
    
    var backgroundUIColor: UIColor {
        UIColor(hexString: backgroundColor) ?? .white
    }
    
    var overlayIconImage: UIImage? {
        guard actionType == .openUrl else {
            return nil
        }
        switch openUrlMediaType {
        case .none: return nil
        case .gif, .picture, .notMedia: return nil
        case .audio, .video: return UIImage(named: "video_play_btn_with_bg") // TODO: [UIImage imageNamed:@"video_play_btn_with_bg" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        }
    }
    
    var textAlignment: NSTextAlignment {
        switch textHAlign {
        case .left: return .left
        case .center: return .center
        case .right: return .right
        }
    }
    
    var textBackgroundGradientUIColor: UIColor? {
        UIColor(hexString: textBackgroundGradientColor)
    }
    
    var backgroundMediaContentMode: UIView.ContentMode {
        switch backgroundScaleType {
        case .crop: return .scaleAspectFill
        case .fit: return .scaleAspectFit
        case .fill: return .scaleToFill
        case .unknown: return .center
        }
    }
    
    var imageContentMode: UIView.ContentMode {
        switch imageScaleType {
        case .crop: return .scaleAspectFill
        case .fit: return .scaleAspectFit
        case .fill: return .scaleToFill
        case .unknown: return .center
        }
    }
}
#endif
