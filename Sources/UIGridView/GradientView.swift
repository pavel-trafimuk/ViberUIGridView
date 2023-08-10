//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import UIKit

final class GradientView: UIView {
 
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    enum Location {
        case top
        case bottom
    }
    
    func showGradiant(from location: Location, alpha: Double = 0.7) {
        guard let gradientLayer else { return }
        let endColor = UIColor(white: 0.0, alpha: 0.0)
        let startColor = UIColor(white: 0.0, alpha: alpha)
        gradientLayer.frame = bounds
        
        switch location {
        case .top:
            gradientLayer.colors = [startColor, endColor]
        case .bottom:
            gradientLayer.colors = [endColor, startColor]
        }
        gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}
