//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation
import UIKit
import UIGrid

public protocol ScreenSizeCalculating {
    func heightOfScreenPercentage(_ percentage: CGFloat) -> CGFloat
}

/**
 * Main view for UI grid which you should use to show bot keyboard, based on UI Grid JSON. Just create it with viewModel and set in VIBInputViewContainer
 **/
public final class BotKeyboardView: UIView {
    
    var collectionView: UICollectionView!
    var viewModel: UIGridViewModel
    
    lazy var collectionViewLayout: UIGridCollectionLayout = {
        let layout = UIGridCollectionLayout(dataSource: self, gridGroupSize: viewModel.gridGroupSize)
        layout.cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: Constants.spaceBetweenBlocks, right: Constants.spaceBetweenBlocks)
        return layout
    }()
    
    var lastCalculatedDefaultHeight: CGFloat?
    var portraitCollectionViewSize: CGSize?
    var landscapeCollectionViewSize: CGSize?
    
    private var viewModelWasChangedLastTime: Bool = true
    
    enum Constants {
        static let spaceBetweenBlocks = 2.0
        static let maximumKeyboardWith = 480.0
        static let minCustomKeyboardHeight = 30
        static let maxCustomKeyboardHeight = 85
        
        static let cellId = "UIGridButtonCellId"
    }
    
    public init(frame: CGRect,
                viewModel: UIGridViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
        backgroundColor = viewModel.grid.backgroundUIColor ?? viewModel.defaultBackgroundColor

        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(UIGridButtonView.self, forCellWithReuseIdentifier: Constants.cellId)
        collectionView.isAccessibilityElement = false
        addSubview(collectionView)
        self.collectionView = collectionView
        
        // first sizerToFit will automatically rotate collectionView to needed size (and reload it)
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UIGridViewModel) {
        guard viewModel.grid != model.grid else {
            return
        }
        
        self.viewModel = model
        backgroundColor = viewModel.grid.backgroundUIColor ?? viewModel.defaultBackgroundColor
        
        lastCalculatedDefaultHeight = nil
        portraitCollectionViewSize = nil
        landscapeCollectionViewSize = nil
        viewModelWasChangedLastTime = true
        
        collectionViewLayout.gridGroupSize = viewModel.gridGroupSize
        collectionView.setContentOffset(.zero, animated: false)
        
        // first sizerToFit will automatically rotate collectionView to needed size (and reload it)
        sizeToFit()
    }
    
    ///  Method should be called when orientation is going to be changed with new input view's preffered size
    public func orientationWillChange(to orientation: UIInterfaceOrientation, prefferedSize: CGSize) {
        changeCollectionViewOrientation(to: orientation, prefferedSize: prefferedSize)
    }
    
    /**
     Returns content size for inline bot keyboard for the current model according to orientation and input view's default size
     @param orientation Current input view orientation
     @param prefferedSize Preffered size for input view
     */
    public func contentSize(for orientation: UIInterfaceOrientation, prefferedSize: CGSize) -> CGSize {
        // called during init three times (super, ownInit, boxing in realInputView)
        // also called before rotation and after rotation
        
        var isDefaultHeightChanged = lastCalculatedDefaultHeight != prefferedSize.height
        var resultSize: CGSize
        if orientation.isPortrait {
            if isDefaultHeightChanged || portraitCollectionViewSize == nil {
                changeCollectionViewOrientation(to: orientation, prefferedSize: prefferedSize)
            }
            resultSize = portraitCollectionViewSize ?? .zero
        }
        else {
            if isDefaultHeightChanged || landscapeCollectionViewSize == nil {
                changeCollectionViewOrientation(to: orientation, prefferedSize: prefferedSize)
            }
            resultSize = landscapeCollectionViewSize ?? .zero
        }
        
        resultSize.width = prefferedSize.width
        if viewModel.grid.isDefaultHeight == true {
            resultSize.height = prefferedSize.height
        }
        else {
            resultSize.height += Constants.spaceBetweenBlocks
        }
        return resultSize
    }

    public func prefferedSizeForCustomDefaultHeight(prefferedHeigt: CGFloat,
                                                    screenSizeCalculator: ScreenSizeCalculating) -> CGFloat {
        guard viewModel.grid.isDefaultHeight == true,
              let customHeightScale = viewModel.grid.customDefaultHeight
        else {
            return prefferedHeigt
        }
        let workScale: CGFloat
        if customHeightScale < Constants.minCustomKeyboardHeight {
            workScale = CGFloat(Constants.minCustomKeyboardHeight)
        }
        else if customHeightScale > Constants.maxCustomKeyboardHeight {
            workScale = CGFloat(Constants.maximumKeyboardWith)
        }
        else {
            workScale = CGFloat(customHeightScale)
        }
        
        let customHeight = screenSizeCalculator.heightOfScreenPercentage(workScale)
        return customHeight > prefferedHeigt ? customHeight : prefferedHeigt
    }

    public func changeCollectionViewOrientation(to orientation: UIInterfaceOrientation,
                                                prefferedSize: CGSize) {
        let askIsPortrait = orientation.isPortrait
        let groupWidth = viewModel.gridGroupSize.width
        let defaultKeyboardSize = prefferedSize

        var collectionViewFrame = CGRect.zero
        collectionViewFrame.origin.x = Constants.spaceBetweenBlocks
        collectionViewFrame.origin.y = Constants.spaceBetweenBlocks

        var shouldReload = false
        let saveSized = askIsPortrait ? portraitCollectionViewSize : landscapeCollectionViewSize
        var collectionViewSize = CGSize.zero
        if let saveSized, saveSized != .zero {
            collectionViewSize = saveSized
        }
        else {
            collectionViewSize.width = defaultKeyboardSize.width - collectionViewFrame.origin.x
            collectionViewSize.height = defaultKeyboardSize.height - collectionViewFrame.origin.y // we don't know real height
            shouldReload = true
        }
        
        if viewModel.grid.isDefaultHeight == true &&
            floor(collectionViewSize.height) != floor(prefferedSize.height) {
            // Using default height, but default keyboard height was changed after last time - update layout
            collectionViewSize.height = defaultKeyboardSize.height - collectionViewFrame.origin.y
            // TODO: check if it should be really reloaded
            // shouldReload = true
        }
        
        collectionViewFrame.size = collectionViewSize

        if !shouldReload {
            shouldReload = floor(collectionView.frame.width) != floor(collectionViewFrame.width)
        }
        
        let windowSize = collectionView.window?.screen.bounds.size ?? .zero
        let portraitWidth = max(min(windowSize.width, windowSize.height), Constants.maximumKeyboardWith)

        collectionViewLayout.edgeSpace = (collectionViewFrame.origin.x + collectionViewFrame.size.width - portraitWidth) / 2
        
        if shouldReload {
            // we should reload collectionView because it needs to update internal count of items
            if viewModelWasChangedLastTime {
                collectionView.reloadData()
                viewModelWasChangedLastTime = false
            }
            collectionView.frame = collectionViewFrame
            collectionView.layoutIfNeeded()
        }
        else {
            collectionView.frame = collectionViewFrame
        }

        // TODO: seems like it will flick!
        if viewModel.grid.isDefaultHeight != true {
            collectionViewFrame.size.height = min(collectionView.contentSize.height, defaultKeyboardSize.height - collectionViewFrame.origin.y)
            collectionViewFrame.size.height += superview?.safeAreaInsets.bottom ?? 0.0
            collectionView.frame = collectionViewFrame
        }
        
        if askIsPortrait {
            portraitCollectionViewSize = collectionViewFrame.size
        }
        else {
            landscapeCollectionViewSize = collectionViewFrame.size
        }
        lastCalculatedDefaultHeight = prefferedSize.height
    }

    public func clearCalculatedContentSizes() {
        portraitCollectionViewSize = nil
        landscapeCollectionViewSize = nil
    }
}

extension BotKeyboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.buttonViewModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rawCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath)
        guard
            let cell = rawCell as? UIGridButtonView,
            indexPath.item < viewModel.buttonViewModels.count
        else {
            return rawCell
        }
        let cellViewModel = viewModel.buttonViewModels[indexPath.item]
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? UIGridButtonView else { return }
        cell.startMediaAnimation()
    }
    
    // TODO: check that BG also stops animation
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? UIGridButtonView else { return }
        cell.stopMediaAnimation()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard
            let cell = collectionView.cellForItem(at: indexPath) as? UIGridButtonView,
            let cellViewModel = cell.viewModel
        else {
            return
        }
        let actionContext = UIGridActionContext(grid: viewModel.grid,
                                                button: cellViewModel.button,
                                                buttonViewModel: cellViewModel,
                                                buttonView: cell,
                                                analyticsContext: nil)
        // TODO: implement
//            [cellVM uiGrid:self handleActionWithContext:actionContext];
    }
}

extension BotKeyboardView: UIGridCollectionLayoutDataSource {
    public func gridSize(for indexPath: IndexPath) -> UIGridSize? {
        guard indexPath.item < viewModel.buttonViewModels.count else { return nil }
        
        // TODO: attention, implement default size
        return viewModel.buttonViewModels[indexPath.item].button.size
    }
    
    
}
