//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation
import UIGrid

enum UIGridLayoutStorageGeneratorError: Error {
    case cantPlaceElement
    case invalidSizes
}


public struct UIGridLayoutStorageGenerator {
    
    /// bot keyboard style
    public func generateStorageForKeyboard(with elements: [IndexPath: UIGridSize],
                                           limitOfGroupsInOneRow: UInt,
                                           gridGroupSize: UIGridSize) throws -> UIGridLayoutStorage {
        try generateStorage(with: elements,
                            limitOfGroupsInOneRow: limitOfGroupsInOneRow,
                            gridGroupSize: gridGroupSize,
                            reverseOrderForGroups: false,
                            flexibleRowsLayout: true)
    }
    
    
    /// Rich message style, where only on row for elements groups
    public func generateStorageForRich(with elements: [IndexPath: UIGridSize],
                                       reverseOrderForGroups: Bool,
                                       gridGroupSize: UIGridSize) throws -> UIGridLayoutStorage {
        try generateStorage(with: elements,
                            limitOfGroupsInOneRow: nil,
                            gridGroupSize: gridGroupSize,
                            reverseOrderForGroups: reverseOrderForGroups,
                            flexibleRowsLayout: false)
    }
    
    ///
    /// Generates layout storage of elements with specific sizes, placing them left-to-right up-to-bottom
    /// Which will be grouped in @param gridGroupSize rects,
    /// And groups will be placed one by one left-to-right (or reversed by @param reverseOrderForGroups) up-to-bottom
    func generateStorage(with elements: [IndexPath: UIGridSize],
                         limitOfGroupsInOneRow: UInt?,
                         gridGroupSize: UIGridSize,
                         reverseOrderForGroups: Bool,
                         flexibleRowsLayout: Bool) throws -> UIGridLayoutStorage {
        guard
            !gridGroupSize.isZero,
            limitOfGroupsInOneRow != 0
        else {
            throw UIGridLayoutStorageGeneratorError.invalidSizes
        }
        
        // Part A. Layout in groups
        // We enumarate all path and sizes (with sorting by path comparing) and fill each element in groups
        // if group filled, we create a new one and go on, break if element is too large for group
        var cursor: UIGridPoint? = UIGridPoint.zero
        var createdGroupsOfElements = [UIGridLayoutStorage]()
        var openGroup = UIGridLayoutStorage()
        var groupIsJustCreated = true
        
        let sortedElements = elements.sorted(by: { $0.key < $1.key })
        
        for (path, size) in sortedElements {
            func placing(at frame: UIGridFrame) throws {
                try openGroup.insert(path: path, frame: frame)
                if groupIsJustCreated {
                    groupIsJustCreated = false
                    createdGroupsOfElements.append(openGroup)
                }
                cursor = openGroup.firstFreePoint(startingFrom: frame.origin,
                                                  gridGroupSize: gridGroupSize)
            }
            
            if let cursor,
               let freePosition = openGroup.findPlace(for: size, startingFrom: cursor, gridGroupSize: gridGroupSize) {
                try placing(at: .init(point: freePosition, size: size))
            }
            else {
                if groupIsJustCreated {
                    throw UIGridLayoutStorageGeneratorError.cantPlaceElement
                }
                
                // create a new element
                cursor = .zero
                groupIsJustCreated = true
                openGroup = UIGridLayoutStorage()
                try placing(at: .init(point: .zero, size: size))
            }
        }
        
        // Part B. Layout groups
        // for now we're layouting groups of elements one by one from the left to the right
        // also filling grid and reverse grid
        
        var verticalDelta: UInt = 0
        let result = UIGridLayoutStorage()
        
        if reverseOrderForGroups {
            createdGroupsOfElements.reverse()
        }
        
        let groupsInOneRow = limitOfGroupsInOneRow ?? UInt.max
        
        for (groupIdx, groupOfElements) in createdGroupsOfElements.enumerated() {
            let groupBlockOffsetX = (UInt(groupIdx) % groupsInOneRow) * gridGroupSize.width
            var groupBlockOffsetY = (UInt(groupIdx) / groupsInOneRow) * gridGroupSize.height
            
            if flexibleRowsLayout {
                groupBlockOffsetY = verticalDelta
            }
            
            groupOfElements.enumerateGrid(from: 0, to: nil) { indexPath, frame in
                let updatedFrame = UIGridFrame(x: frame.x + Int(groupBlockOffsetX),
                                               y: frame.y + Int(groupBlockOffsetY),
                                               width: frame.width,
                                               height: frame.height)
                do {
                    try result.insert(path: indexPath, frame: updatedFrame)
                }
                catch {
                    print("Can't place: \(error)")
                }
            }
            
            if flexibleRowsLayout,
               let limitOfGroupsInOneRow,
               (groupBlockOffsetX + gridGroupSize.width) == (limitOfGroupsInOneRow * gridGroupSize.width),
               let lastUsedPoint = groupOfElements.lastUsedPoint() {
                verticalDelta += UInt(lastUsedPoint.y) + 1
            }
        }
        result.countOfGroups = UInt(createdGroupsOfElements.count)
        return result;
    }
}
