//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 10/08/2023.
//

import Foundation

public protocol UIGridViewLogger {
    func logDebug(_ message: @autoclosure () -> String)
    func logError(_ message: @autoclosure () -> String)
}
