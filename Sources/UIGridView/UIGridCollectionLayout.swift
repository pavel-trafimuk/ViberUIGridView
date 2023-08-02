//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import UIGrid

// TODO: decide with public marks

public protocol UIGridCollectionLayoutDataSource {
    func gridSize(for indexPath: IndexPath) -> UIGridSize?
}

/***
 * This layout used to layout elements in groups and then layout blocks. Elements and groups of elements layout with fit collectionView width from left-to-right, from top-to-bottom
 * Legenda:
 *      grid  - view is divided by blocks in grid. All visual elements will be layout on this grid by own block size and group logic
 *
 *      grid block width - it reflects how much block will be placed in one grid row. Should be integer and fold by group block width (so one row will have integer count of groups). Used to calculate UI point size of each block
 *
 *      block - one cell in whole grid. All blocks have the same UI point size (e.g. 100x100 points)
 *
 *      group - group of elements. All elements before placing in UI, are grouped. So if element can't be placed in groupA, it will moved to groupB, and groupA will be not full filled. All groups have the same block size (e.g. 6x2 blocks)
 *
 *      element - one concrete visual element. It could be only rectangle with integer block size, each element may have different sizes, but couldn't be bigger than group
 **/
public final class UIGridCollectionLayout: UICollectionViewLayout {
    
    var dataSource: UIGridCollectionLayoutDataSource

    /// Layout can increase/decrease each element on specific value to make spaces between elements, use insets for this
    public var cellInsets: UIEdgeInsets? {
        didSet {
            if oldValue != cellInsets {
                invalidateLayout()
            }
        }
    }
    
    public var edgeSpace: CGFloat = 0 {
        didSet {
            if oldValue != edgeSpace {
                invalidateLayout()
            }
        }
    }
    
    /// how much grid groups could be placed in one row, usually is 1 for portrait
    public var limitOfGroupsInOneRow: UInt = 1 {
        didSet {
            if oldValue != limitOfGroupsInOneRow {
                invalidateLayout()
            }
        }
    }
    
    public var gridGroupSize: UIGridSize {
        didSet {
            if gridGroupSize != oldValue {
                invalidateLayout()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(dataSource: UIGridCollectionLayoutDataSource,
         gridGroupSize: UIGridSize) {
        self.dataSource = dataSource
        self.gridGroupSize = gridGroupSize
        super.init()
    }
    
    /// it keeps last two storages to reduce calculations during rotation
    private var cachedStorages = [UInt: UIGridLayoutStorage]()

    // prepared grid of elements
    private var activeGridStorage: UIGridLayoutStorage?

    // real UI points size of one grid cell
    private var gridCellUISize: CGSize?
    private var leadingInsets: CGFloat = 0.0
    
    // for optimize calculation for freq. requestss
    private var previousLayoutAttributes: [UICollectionViewLayoutAttributes]?
    private var previousLayoutRect: CGRect?

    public override var collectionViewContentSize: CGSize {
        guard let lastUsedPoint = activeGridStorage?.lastUsedPoint(),
              let gridCellUISize
        else {
            // not prepared yet
            return .zero
        }
        let height = (CGFloat((lastUsedPoint.y + 1)) * gridCellUISize.height)
            .retinaRounded(scale: collectionView?.screenScale)
        return CGSize(width: collectionView?.bounds.size.width ?? 0.0,
                      height: height)
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let activeGridStorage,
              let gridCellUISize,
              gridCellUISize.height > 0
        else {
            return []
        }
        
        // TODO: better compare of equality!!!
        if let previousLayoutRect,
           previousLayoutRect == rect {
            return previousLayoutAttributes
        }
        
        let firstRow = Int(floor(rect.origin.y / gridCellUISize.height))
        let lastRow = Int(ceil(rect.maxY / gridCellUISize.height))
        var attributes = [UICollectionViewLayoutAttributes]()
        
        activeGridStorage.enumerateGrid(from: firstRow,
                                        to: lastRow) { path, gridFrame in
            if let attr = layoutAttributesForItem(at: path) {
                attributes.append(attr)
            }
        }
        
        previousLayoutAttributes = attributes
        previousLayoutRect = rect

        return previousLayoutAttributes
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let gridCellUISize,
              let gridFrame = activeGridStorage?.frame(for: indexPath)
        else {
            return nil
        }
        
        var finalFrame = CGRect(x: CGFloat(gridFrame.x) * gridCellUISize.width + leadingInsets,
                                y: CGFloat(gridFrame.y) * gridCellUISize.height,
                                width: CGFloat(gridFrame.width) * gridCellUISize.width,
                                height: CGFloat(gridFrame.height) * gridCellUISize.height)
            .retinaRounded(scale: collectionView?.screenScale)
        if let cellInsets {
            finalFrame = finalFrame.inset(by: cellInsets)
        }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = finalFrame
        return attributes
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView else { return true }
        return Int(floor(newBounds.width)) != Int(floor(collectionView.bounds.width))
    }

    public override func prepare() {
        guard
            limitOfGroupsInOneRow != 0,
            let collectionView
        else {
            return
        }
        loadGridStorageForCurrentGridRowWidth()
        
        // TODO: check keyboards and different height
        var cellSize = CGSize.zero
        cellSize.width = (collectionView.bounds.width - self.edgeSpace * 2) / CGFloat(limitOfGroupsInOneRow * gridGroupSize.width)
        cellSize.height = cellSize.width
        gridCellUISize = cellSize
        
        leadingInsets = ((collectionView.bounds.width - CGFloat(limitOfGroupsInOneRow * gridGroupSize.width) * cellSize.width) / 2)
            .retinaRounded(scale: collectionView.screenScale)
    }

    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)

        if context.invalidateEverything || context.invalidateDataSourceCounts {
            activeGridStorage = nil
            cachedStorages.removeAll()
        }

        gridCellUISize = nil
        previousLayoutRect = nil
        previousLayoutAttributes = nil
    }

    func loadGridStorageForCurrentGridRowWidth() {
        if let storage = cachedStorages[limitOfGroupsInOneRow * gridGroupSize.width] {
            activeGridStorage = storage
        }
        guard let collectionView else {
            return
        }

        var loadedValues = [IndexPath: UIGridSize]()
        
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            let rowsCount = collectionView.numberOfItems(inSection: section)
            for row in 0..<rowsCount {
                let indexPath = IndexPath(row: row, section: section)
                guard let size = dataSource.gridSize(for: indexPath) else {
                    continue
                }
                loadedValues[indexPath] = size
            }
        }
        
        do {
            let storage = try UIGridLayoutStorageGenerator().generateStorage(with: loadedValues,
                                                                       limitOfGroupsInOneRow: limitOfGroupsInOneRow,
                                                                       gridGroupSize: gridGroupSize,
                                                                       reverseOrderForGroups: false,
                                                                       flexibleRowsLayout: true) // TODO: check values!
            cachedStorages[limitOfGroupsInOneRow * gridGroupSize.width] = storage
            activeGridStorage = storage
        }
        catch {
            print("Error: \(error)")
        }
    }
}
#endif
