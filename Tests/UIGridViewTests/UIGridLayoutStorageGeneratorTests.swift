//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import XCTest
import UIGrid
@testable import UIGridView

final class UIGridLayoutStorageGeneratorTests: XCTestCase {

    let size6x1 = UIGridSize(width: 6, height: 1)
    let size6x2 = UIGridSize(width: 6, height: 2)
    let size3x1 = UIGridSize(width: 3, height: 1)
    let size2x1 = UIGridSize(width: 2, height: 1)
    let size2x2 = UIGridSize(width: 2, height: 2)
    let size4x1 = UIGridSize(width: 4, height: 1)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testZeroWidth() throws {
//        NSDictionary *elements = @{};
//        NSInteger width = 0;
//        CGSize blockSize = CGSizeMake(1, 1);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:&error];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error != nil, "layout should return error")
//        XCTAssert(error.domain == kVIBGridStorageGeneratorErrorDomain, "Error should have valid domain (%@) but have (%@)", kVIBGridStorageGeneratorErrorDomain, error);
//        XCTAssert(error.code == VIBGridStorageGeneratorError_InvalidGridBlockWidth, "Error should have valid code (invalidgridBlockWidth) but have (%@)", error);
    }


    func testWidthLessThanBlock() throws {
//        NSDictionary *elements = @{};
//        NSInteger width = 3;
//        CGSize blockSize = CGSizeMake(6, 6);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:&error];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error != nil, "layout should return error")
//        XCTAssert(error.domain == kVIBGridStorageGeneratorErrorDomain, "Error should have valid domain (%@) but have (%@)", kVIBGridStorageGeneratorErrorDomain, error);
//        XCTAssert(error.code == VIBGridStorageGeneratorError_InvalidGridBlockWidth, "Error should have valid code (invalidgridBlockWidth) but have (%@)", error);
    }


    func testWidthNotFoldBlockWidth() throws {
//        NSDictionary *elements = @{};
//        NSInteger width = 10;
//        CGSize blockSize = CGSizeMake(6, 6);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:&error];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error != nil, "layout should return error")
//        XCTAssert(error.domain == kVIBGridStorageGeneratorErrorDomain, "Error should have valid domain (%@) but have (%@)", kVIBGridStorageGeneratorErrorDomain, error);
//        XCTAssert(error.code == VIBGridStorageGeneratorError_InvalidGridBlockWidth, "Error should have valid code (invalidgridBlockWidth) but have (%@)", error);
    }


    func testZeroBlock() throws {
//        NSDictionary *elements = @{};
//        NSInteger width = 3;
//        CGSize blockSize = CGSizeMake(0, 0);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:&error];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error != nil, "layout should return error")
//        XCTAssert(error.domain == kVIBGridStorageGeneratorErrorDomain, "Error should have valid domain (%@) but have (%@)", kVIBGridStorageGeneratorErrorDomain, error);
//        XCTAssert(error.code == VIBGridStorageGeneratorError_InvalidBlockSize, "Error should have valid code (invalidBlockSize) but have (%@)", error);
    }


    func testNotIntegerBlock() throws {
//        NSDictionary *elements = @{};
//        NSInteger width = 3;
//        CGSize blockSize = CGSizeMake(1.5, 3.5);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:&error];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error != nil, "layout should return error")
//        XCTAssert(error.domain == kVIBGridStorageGeneratorErrorDomain, "Error should have valid domain (%@) but have (%@)", kVIBGridStorageGeneratorErrorDomain, error);
//        XCTAssert(error.code == VIBGridStorageGeneratorError_InvalidBlockSize, "Error should have valid code (invalidBlockSize) but have (%@)", error);
    }



    func testElementBiggerThanBlock() throws {
//        NSDictionary *elements = @{ [NSIndexPath indexPathForRow:0 inSection:0] :  [NSValue valueWithCGSize:CGSizeMake(6, 1)] };
//        NSInteger width = 4;
//        CGSize blockSize = CGSizeMake(2, 2);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:&error];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error != nil, "layout should return error")
//        XCTAssert(error.domain == kVIBGridStorageGeneratorErrorDomain, "Error should have valid domain (%@) but have (%@)", kVIBGridStorageGeneratorErrorDomain, error);
//        XCTAssert(error.code == VIBGridStorageGeneratorError_ElementTooLargeForOneBlock, "Error should have valid code (largeElement) but have (%@)", error);
    }


    func testNilErrorPointer() throws {
//        NSDictionary *elements = @{};
//        NSInteger width = 3;
//        CGSize blockSize = CGSizeMake(1.5, 3.5);
//        
//        NSError *error = nil;
//        VIBGridStorage *result = [VIBGridStorageGenerator gridForElements:elements
//                                                           gridBlockWidth:width
//                                                           groupBlockSize:blockSize
//                                                                    error:NULL];
//        XCTAssert(result == nil, "layout should return nil")
//        XCTAssert(error == nil, "layout should not crash")
    }

    private func check(storage: UIGridLayoutStorage,
                       with framesToCheck: [IndexPath: UIGridFrame],
                       checkLastPoint: UIGridPoint?,
                       checkCountOfGroups: Int) {
        XCTAssert(storage.countOfGroups == checkCountOfGroups, "Should be \(checkCountOfGroups), but \(storage.countOfGroups)")
        XCTAssert(storage.frames == framesToCheck, "Should be \(framesToCheck.sorted(by: { $0.key < $1.key})), but \(storage.frames.sorted(by: { $0.key < $1.key}))")
        XCTAssert(storage.lastUsedPoint() == checkLastPoint, "Should be \(checkLastPoint), but \(storage.lastUsedPoint())")
        
        for (indexPath, frame) in framesToCheck {
            let resultPath = storage.indexPath(at: frame.origin)
            XCTAssert(indexPath == resultPath)
            
            let resultFrame = storage.frame(for: indexPath)
            XCTAssert(frame == resultFrame)
        }
        storage.enumerateGrid(from: 0, to: nil) { indexPath, frame in
            XCTAssert(framesToCheck[indexPath] == frame)
        }
    }

    func testSimpleOrderedList() throws {
        let values = [
            IndexPath(row: 0, section: 0): size6x1,
            IndexPath(row: 1, section: 0): size6x1,
            IndexPath(row: 2, section: 0): size6x1,
            IndexPath(row: 3, section: 0): size6x1,
            IndexPath(row: 4, section: 0): size6x1,
            IndexPath(row: 5, section: 0): size6x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size6x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size6x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size6x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 0, y: 3), size: size6x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 0, y: 4), size: size6x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 0, y: 5), size: size6x1),
        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 5)
        let checkCountOfGroups = 3
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 1,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testOrderedList_6x1_6x2() throws {
        let values = [
            IndexPath(row: 0, section: 0): size6x1,
            IndexPath(row: 1, section: 0): size6x2,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size6x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size6x2),
        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 2)
        let checkCountOfGroups = 2
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 1,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }



    func testTwoBlocksInRow() throws {
        let values = [
            IndexPath(row: 0, section: 0): size3x1,
            IndexPath(row: 1, section: 0): size3x1,
            IndexPath(row: 2, section: 0): size3x1,
            IndexPath(row: 3, section: 0): size3x1,
            IndexPath(row: 4, section: 0): size3x1,
            IndexPath(row: 5, section: 0): size3x1,
            IndexPath(row: 6, section: 0): size3x1,
            IndexPath(row: 7, section: 0): size3x1,
        ]
        let groupSize = UIGridSize(width: 3, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size3x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size3x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 3, y: 0), size: size3x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 3, y: 1), size: size3x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size3x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 0, y: 3), size: size3x1),
            IndexPath(row: 6, section: 0): UIGridFrame(point: .init(x: 3, y: 2), size: size3x1),
            IndexPath(row: 7, section: 0): UIGridFrame(point: .init(x: 3, y: 3), size: size3x1),
        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 3)
        let checkCountOfGroups = 4
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 2,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testTwoBlocksInRowWithEmpty() throws {
        let values = [
            IndexPath(row: 0, section: 0): size3x1,
            IndexPath(row: 1, section: 0): size3x1,
            IndexPath(row: 2, section: 0): size3x1,
            IndexPath(row: 3, section: 0): size3x1,
            IndexPath(row: 4, section: 0): size3x1,
            IndexPath(row: 5, section: 0): size3x1,
            IndexPath(row: 6, section: 0): size3x1,
        ]
        let groupSize = UIGridSize(width: 3, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size3x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size3x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 3, y: 0), size: size3x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 3, y: 1), size: size3x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size3x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 0, y: 3), size: size3x1),
            IndexPath(row: 6, section: 0): UIGridFrame(point: .init(x: 3, y: 2), size: size3x1),
        ]
        let checkLastPoint = UIGridPoint(x: 2, y: 3)
        let checkCountOfGroups = 4
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 2,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }

    func testFromGenaExample1Portrait() throws {
        let values = [
            IndexPath(row: 0, section: 0): size2x2,
            IndexPath(row: 1, section: 0): size4x1,
            IndexPath(row: 2, section: 0): size4x1,
            IndexPath(row: 3, section: 0): size2x2,
            IndexPath(row: 4, section: 0): size4x1,
            IndexPath(row: 5, section: 0): size4x1,
            IndexPath(row: 6, section: 0): size2x2,
            IndexPath(row: 7, section: 0): size4x1,
            IndexPath(row: 8, section: 0): size4x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size2x2),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 2, y: 0), size: size4x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 2, y: 1), size: size4x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size2x2),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 2, y: 2), size: size4x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 2, y: 3), size: size4x1),
            IndexPath(row: 6, section: 0): UIGridFrame(point: .init(x: 0, y: 4), size: size2x2),
            IndexPath(row: 7, section: 0): UIGridFrame(point: .init(x: 2, y: 4), size: size4x1),
            IndexPath(row: 8, section: 0): UIGridFrame(point: .init(x: 2, y: 5), size: size4x1),

        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 5)
        let checkCountOfGroups = 3
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 1,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample1Landscape() throws {
        let values = [
            IndexPath(row: 0, section: 0): size2x2,
            IndexPath(row: 1, section: 0): size4x1,
            IndexPath(row: 2, section: 0): size4x1,
            IndexPath(row: 3, section: 0): size2x2,
            IndexPath(row: 4, section: 0): size4x1,
            IndexPath(row: 5, section: 0): size4x1,
            IndexPath(row: 6, section: 0): size2x2,
            IndexPath(row: 7, section: 0): size4x1,
            IndexPath(row: 8, section: 0): size4x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size2x2),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 2, y: 0), size: size4x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 2, y: 1), size: size4x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 6, y: 0), size: size2x2),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 8, y: 0), size: size4x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 8, y: 1), size: size4x1),
            IndexPath(row: 6, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size2x2),
            IndexPath(row: 7, section: 0): UIGridFrame(point: .init(x: 2, y: 2), size: size4x1),
            IndexPath(row: 8, section: 0): UIGridFrame(point: .init(x: 2, y: 3), size: size4x1),

        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 3)
        let checkCountOfGroups = 3
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 2,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample2Portrait() throws {
        let values = [
            IndexPath(row: 0, section: 0): size6x1,
            IndexPath(row: 1, section: 0): size6x1,
            IndexPath(row: 2, section: 0): size6x1,
            IndexPath(row: 3, section: 0): size6x1,
            IndexPath(row: 4, section: 0): size6x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size6x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size6x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size6x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 0, y: 3), size: size6x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 0, y: 4), size: size6x1),

        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 4)
        let checkCountOfGroups = 3
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 1,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample2Landscape() throws {
        let values = [
            IndexPath(row: 0, section: 0): size6x1,
            IndexPath(row: 1, section: 0): size6x1,
            IndexPath(row: 2, section: 0): size6x1,
            IndexPath(row: 3, section: 0): size6x1,
            IndexPath(row: 4, section: 0): size6x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size6x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size6x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 6, y: 0), size: size6x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 6, y: 1), size: size6x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 0, y: 2), size: size6x1),

        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 2)
        let checkCountOfGroups = 3
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 2,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample3Portrait() throws {
        let values = [
            IndexPath(row: 0, section: 0): size2x1,
            IndexPath(row: 1, section: 0): size2x1,
            IndexPath(row: 2, section: 0): size2x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size2x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 2, y: 0), size: size2x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 4, y: 0), size: size2x1),

        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 0)
        let checkCountOfGroups = 1
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 1,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample3Landscape() throws {
        let values = [
            IndexPath(row: 0, section: 0): size2x1,
            IndexPath(row: 1, section: 0): size2x1,
            IndexPath(row: 2, section: 0): size2x1,
        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size2x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 2, y: 0), size: size2x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 4, y: 0), size: size2x1),

        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 0)
        let checkCountOfGroups = 1
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 2,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample4Portrait() throws {
        let values = [
            IndexPath(row: 0, section: 0): size2x1,
            IndexPath(row: 1, section: 0): size2x1,
            IndexPath(row: 2, section: 0): size2x1,
            IndexPath(row: 3, section: 0): size2x1,
            IndexPath(row: 4, section: 0): size2x1,
            IndexPath(row: 5, section: 0): size2x1,

        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size2x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 2, y: 0), size: size2x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 4, y: 0), size: size2x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size2x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 2, y: 1), size: size2x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 4, y: 1), size: size2x1),
        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 1)
        let checkCountOfGroups = 1
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 1,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }


    func testFromGenaExample4Landscape() throws {
        let values = [
            IndexPath(row: 0, section: 0): size2x1,
            IndexPath(row: 1, section: 0): size2x1,
            IndexPath(row: 2, section: 0): size2x1,
            IndexPath(row: 3, section: 0): size2x1,
            IndexPath(row: 4, section: 0): size2x1,
            IndexPath(row: 5, section: 0): size2x1,

        ]
        let groupSize = UIGridSize(width: 6, height: 2)
        
        let checks = [
            IndexPath(row: 0, section: 0): UIGridFrame(point: .init(x: 0, y: 0), size: size2x1),
            IndexPath(row: 1, section: 0): UIGridFrame(point: .init(x: 2, y: 0), size: size2x1),
            IndexPath(row: 2, section: 0): UIGridFrame(point: .init(x: 4, y: 0), size: size2x1),
            IndexPath(row: 3, section: 0): UIGridFrame(point: .init(x: 0, y: 1), size: size2x1),
            IndexPath(row: 4, section: 0): UIGridFrame(point: .init(x: 2, y: 1), size: size2x1),
            IndexPath(row: 5, section: 0): UIGridFrame(point: .init(x: 4, y: 1), size: size2x1),
        ]
        let checkLastPoint = UIGridPoint(x: 5, y: 1)
        let checkCountOfGroups = 1
        
        let storage = try UIGridLayoutStorageGenerator().generateStorageForKeyboard(with: values,
                                                                                    limitOfGroupsInOneRow: 2,
                                                                                    gridGroupSize: groupSize)
        check(storage: storage,
              with: checks,
              checkLastPoint: checkLastPoint,
              checkCountOfGroups: checkCountOfGroups)
    }
}
