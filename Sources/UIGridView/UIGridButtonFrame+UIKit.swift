//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import UIGrid

public extension UIGridButtonFrame {
    var borderUIColor: UIColor {
        UIColor(hexString: borderColor) ?? .black
    }
}
#endif
