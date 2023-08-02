//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 24/07/2023.
//

import XCTest
import UIGrid
@testable import UIGridView

final class UIGridLayoutStorageTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmpty() throws {
        let storage = UIGridLayoutStorage()
        XCTAssert(storage.countOfGroups == 0)
        XCTAssert(storage.lastUsedPoint() == nil)
        XCTAssert(storage.frame(for: IndexPath(row: 0, section: 0)) == nil)
        XCTAssert(storage.frames.isEmpty)
        XCTAssert(storage.storage.isEmpty)
    }
    
    func testSimple() throws {
        let storage = UIGridLayoutStorage()
        let groupSize = UIGridSize(width: 6, height: 2)

        do {
            let path = IndexPath(row: 0, section: 0)
            let frame = UIGridFrame(x: 0, y: 0, width: 6, height: 1)
            XCTAssert(storage.canInsert(frame: frame, gridGroupSize: groupSize))
            
            let resultFindPlace1 = storage.findPlace(for: frame.size,
                                                     startingFrom: frame.origin,
                                                     gridGroupSize: groupSize)
            XCTAssert(resultFindPlace1 == frame.origin)
            
            try storage.insert(path: path, frame: frame)
            
            let checkLastUsedPoint = UIGridPoint(x: 5, y: 0)
            let resultLastUsedPoint = storage.lastUsedPoint()
            XCTAssert(checkLastUsedPoint == resultLastUsedPoint, "Should be \(checkLastUsedPoint) but \(resultLastUsedPoint)")
            XCTAssert(storage.frame(for: path) == frame)
            XCTAssert(storage.indexPath(at: frame.origin) == path)
            
            let checkFirstFreeSpace: UIGridPoint? = UIGridPoint(x: 0, y: 1)
            let resultFirstFreeSpace = storage.firstFreePoint(startingFrom: .zero, gridGroupSize: groupSize)
            XCTAssert(checkFirstFreeSpace == resultFirstFreeSpace, "Should be \(checkFirstFreeSpace) but \(resultFirstFreeSpace)")
        }
        
        do {
            let path = IndexPath(row: 1, section: 0)
            let frame = UIGridFrame(x: 0, y: 1, width: 3, height: 1)
            XCTAssert(storage.canInsert(frame: frame, gridGroupSize: groupSize))
            
            let resultFindPlace1 = storage.findPlace(for: frame.size,
                                                     startingFrom: frame.origin,
                                                     gridGroupSize: groupSize)
            XCTAssert(resultFindPlace1 == frame.origin)

            let resultFindPlace2 = storage.findPlace(for: frame.size,
                                                     startingFrom: .zero,
                                                     gridGroupSize: groupSize)
            XCTAssert(resultFindPlace2 == frame.origin)

            try storage.insert(path: path, frame: frame)
            
            let checkLastUsedPoint = UIGridPoint(x: 2, y: 1)
            let resultLastUsedPoint = storage.lastUsedPoint()
            XCTAssert(checkLastUsedPoint == resultLastUsedPoint, "Should be \(checkLastUsedPoint) but \(resultLastUsedPoint)")
            XCTAssert(storage.frame(for: path) == frame)
            XCTAssert(storage.indexPath(at: frame.origin) == path)
            
            let checkFirstFreeSpace: UIGridPoint? = UIGridPoint(x: 3, y: 1)
            let resultFirstFreeSpace = storage.firstFreePoint(startingFrom: .zero, gridGroupSize: groupSize)
            XCTAssert(checkFirstFreeSpace == resultFirstFreeSpace, "Should be \(checkFirstFreeSpace) but \(resultFirstFreeSpace)")
        }
        
        do {
            let path = IndexPath(row: 2, section: 0)
            let frame = UIGridFrame(x: 3, y: 1, width: 5, height: 1)
            XCTAssert(storage.canInsert(frame: frame, gridGroupSize: groupSize) == false)
            
            let resultFindPlace1 = storage.findPlace(for: frame.size,
                                                     startingFrom: .zero,
                                                     gridGroupSize: groupSize)
            XCTAssert(resultFindPlace1 == nil)
        }
    }
}
