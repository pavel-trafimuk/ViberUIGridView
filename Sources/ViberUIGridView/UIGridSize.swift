//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

public struct UIGridSize {
    public init(columns: UInt, rows: UInt) {
        self.columns = columns
        self.rows = rows
    }
    
    public let columns: UInt
    public let rows: UInt
    
    public var width: UInt { columns }
    public var height: UInt { rows }
    
    public var cgSize: CGSize { .init(width: Double(columns), height: Double(rows)) }
}
