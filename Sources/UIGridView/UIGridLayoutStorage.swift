//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation
import UIGrid

//public struct UIGridFrameIterator: IteratorProtocol {
//    var current: UIGridPoint
//    let end: UIGridPoint
//    
//    public init(start: UIGridPoint, end: UIGridPoint) {
//        self.current = start
//        self.end = end
//    }
//    
//    public mutating func next() -> UIGridPoint? {
//        if current.y < end.y {
//            
//        }
//        else if current.x < end.x {
//            // last line
//            let newValue = UIGridPoint(x: current.x + 1, y: current.y)
//            current = newValue
//            return newValue
//        }
//        return nil
//    }
//}

public struct UIGridFrame: Equatable {//} Sequence, IteratorProtocol {
    public let x: Int
    public let y: Int
    public var width: UInt
    public var height: UInt
    
    public var origin: UIGridPoint {
        .init(x: x, y: y)
    }
    
    public var size: UIGridSize {
        .init(width: width, height: height)
    }
    
    public init(x: Int, y: Int, width: UInt, height: UInt) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public init(point: UIGridPoint, size: UIGridSize) {
        self.x = point.x
        self.y = point.y
        self.width = size.width
        self.height = size.height
    }
    
    public var maxX: Int {
        x + Int(width)
    }
    
    public var maxY: Int {
        y + Int(height)
    }
    
    public var isZeroSize: Bool {
        size.isZero
    }
}

//
//    struct IntSequenceGenerator :  {
//            var index = 0
//            let sequence: IntSequence
//            init(sequence: IntSequence) {
//                self.sequence = sequence
//            }
//            mutating func next() -> Int? {
//                if self.index < self.sequence.values.count {
//                    self.index += 1
//                    return self.sequence.values[self.index - 1]
//                } else {
//                    return nil
//                }
//            }
//        }
//        func generate() -> IntSequenceGenerator {
//            return IntSequenceGenerator(sequence: self)
//        }
//}

public struct UIGridPoint: Equatable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public static var zero: UIGridPoint {
        .init(x: 0, y: 0)
    }
    
    public func isInside(_ frame: UIGridFrame) -> Bool {
        x >= frame.x && x < frame.maxX && y >= frame.y && y < frame.maxY
    }
}

enum UIGridLayoutStorageError: Error {
    case alreadyWithElement
    case incorrectSize
}

public final class UIGridLayoutStorage {
    
    /// Reflects how much groups of elements where placed in the current grid
    /// *Attention*: fill it outside
    var countOfGroups: UInt = 0
    
    /// [y: [x: IndexPath]]
    private(set) var storage = [Int: [Int: IndexPath]]()
    private(set) var frames = [IndexPath: UIGridFrame]()
    
    /// place path with needed size in two-dimension array, so each 'square' knows which element it contains
    /// Also remember size and start points to quickly
    func insert(path: IndexPath,
                frame: UIGridFrame) throws {
        guard !frame.isZeroSize else {
            throw UIGridLayoutStorageError.incorrectSize
        }
        frames[path] = frame

        for idy in frame.y..<frame.maxY {
            var xValues: [Int: IndexPath]
            if let found = storage[idy] {
                xValues = found
            }
            else {
                xValues = [:]
                storage[idy] = xValues
            }
            for idx in frame.x..<frame.maxX {
                xValues[idx] = path
            }
            storage[idy] = xValues
        }
    }
    
    public func frame(for path: IndexPath) -> UIGridFrame? {
        frames[path]
    }
    
    // element at point or nil if out of bounds or empty place
    public func indexPath(at point: UIGridPoint) -> IndexPath? {
        storage[point.y]?[point.x]
    }

    /// enumerate storage from left-to-right, upper-to-bottom
    /// @param finishY includes this row also
    /// each indexPath will be called only once, and even if this row is partially cover it
    public func enumerateGrid(from startY: Int,
                              to finishY: Int?,
                              handler: (IndexPath, UIGridFrame) -> Void) {
        guard
            let finishY = finishY ?? storage.keys.max(),
            storage.keys.count != 0,
            startY <= finishY
        else {
            return
        }
        
        var calledPaths = Set<IndexPath>()
        
        for idy in startY...finishY {
            guard
                let xValues = storage[idy],
                    !xValues.isEmpty
            else {
                continue
            }
            for (_, indexPath) in xValues.sorted(by: { $0.key < $1.key }) {
                guard
                    !calledPaths.contains(indexPath),
                    let frame = frames[indexPath]
                else {
                    continue
                }
                
                calledPaths.insert(indexPath)
                handler(indexPath, frame)
            }
        }
    }
}

extension UIGridLayoutStorage {
    
    /// The method tries to find a place on next row if element area already filled or out of bounds in start point
    func findPlace(for size: UIGridSize,
                   startingFrom startPoint: UIGridPoint,
                   gridGroupSize: UIGridSize) -> UIGridPoint? {
        if canInsert(frame: .init(point: startPoint, size: size), gridGroupSize: gridGroupSize) {
            return startPoint
        }
        guard startPoint.y + 1 < gridGroupSize.height else {
            return nil
        }
        let newRowCursor = UIGridPoint(x: 0, y: startPoint.y + 1)
        let allowed = canInsert(frame: .init(point: newRowCursor, size: size), gridGroupSize: gridGroupSize)
        return allowed ? newRowCursor : nil
    }
    
    /// Checks if start point and all area with element size are not already filled and are not out of bounds
    func canInsert(frame: UIGridFrame, gridGroupSize: UIGridSize) -> Bool {
        guard !frame.isZeroSize else {
            return false
        }
        let gridGroupFrame = UIGridFrame(point: .zero, size: gridGroupSize)
        
        for idy in frame.y..<frame.maxY {
            for idx in frame.x..<frame.maxX {
                let point = UIGridPoint(x: idx, y: idy)
                guard point.isInside(gridGroupFrame) else {
                    return false
                }
                guard indexPath(at: point) == nil else {
                    return false
                }
            }
        }
        return true
    }
    
    func firstFreePoint(startingFrom startPoint: UIGridPoint,
                        gridGroupSize: UIGridSize) -> UIGridPoint? {
        guard !gridGroupSize.isZero else { return nil }
        
        for idy in 0..<Int(gridGroupSize.height) {
            guard
                let xValues = storage[idy]
            else {
                return .init(x: 0, y: idy)
            }
            
            for idx in 0..<Int(gridGroupSize.width) where xValues[idx] == nil {
                return .init(x: idx, y: idy)
            }
        }
        return nil
    }
    
    func lastUsedPoint() -> UIGridPoint? {
        guard
            let lastY = storage.keys.max(),
            let lastX = storage[lastY]?.keys.max(),
            storage[lastY]?[lastX] != nil
        else {
            return nil
        }
        return .init(x: lastX, y: lastY)
    }
}
