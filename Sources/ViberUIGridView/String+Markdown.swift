//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation

// Markdown supported only in text/picture messages
extension String {
    public func markdownBold() -> String {
        "*" + self.trimmingCharacters(in: .whitespaces) + "*"
    }
    
    public func markdownItalics() -> String {
        "_" + self.trimmingCharacters(in: .whitespaces) + "_"
    }
    
    public func markdownMonospace() -> String {
        "```" + self.trimmingCharacters(in: .whitespaces) + "```"
    }
    
    public func markdownStrikethrough() -> String {
        "~" + self.trimmingCharacters(in: .whitespaces) + "~"
    }
}
