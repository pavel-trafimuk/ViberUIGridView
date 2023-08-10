//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation
import UIGrid

public struct AnalyticsContext {
    public let messageUid: NSNumber
    
    public let scrollBlocks: UInt
    public let serialBlockNumber: UInt8
    
    // TODO: fix all cases with VIBUIGridReplyType
    public let actionReply: UIGridButton.ReplyType
}
