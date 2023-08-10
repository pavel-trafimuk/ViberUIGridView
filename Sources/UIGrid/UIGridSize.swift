//
//  Created by Pavel Trafimuk on 13/07/2023.
//  Viber Media, Inc.
//

import Foundation

public struct UIGridSize: Equatable {
    public init(width: UInt, height: UInt) {
        self.width = width
        self.height = height
    }
    
    public let width: UInt
    public let height: UInt
    
    public var zero: UIGridSize {
        UIGridSize(width: 0, height: 0)
    }
    
    public var isZero: Bool {
        width == 0 && height == 0
    }
    
    public var cgSize: CGSize { CGSize(width: Double(width), height: Double(height)) }
}
