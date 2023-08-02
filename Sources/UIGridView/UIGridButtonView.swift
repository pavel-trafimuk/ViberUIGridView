//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import UIGrid

public final class UIGridButtonView: UICollectionViewCell {
    
    private(set) var viewModel: UIGridButtonViewModel?
    
    ///  Determines if cell supports highlighting on selection
    public var doesSupportHighlighting: Bool = true
    
    private var textLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.numberOfLines = 0
        return result
    }()
    
    private var textConstraints: [NSLayoutConstraint]?
    
    /// Presents gradient under textLabel
    private var gradientView: GradientView?
    
    private var imageView: UIImageView?
    
    /// Presents icons for specific mediaTypes above backgroundImage and image
    private var overlayImageView: UIImageView?
    
    private var backgroundImageView: UIImageView?
    
    /// custom abstract view, which presents media (video, gif)
    private var mediaView: (any UIGridMediaView)?
    
    private var lastVerticalAlign: UIGridButton.TextVAlign?
    
    private var boxConstraints = [NSLayoutConstraint]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constants {
        static let locationPlaceholder = "bubblePlaceholderLocation_incoming"
    }
    
    /// Bot keyboard input view use it to reduce flickering of icons on the buttons
    public func configure(viewModel: UIGridButtonViewModel) {
        self.viewModel = viewModel
        
        backgroundColor = viewModel.button.backgroundUIColor
        setupBorders()
        
        loadText()
        
        loadOverlay()
        loadImage()
        loadBackgroundMedia()
        
        updateAccessibilityValues()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
        viewModel = nil
        backgroundImageView?.image = nil
        imageView?.image = nil
        mediaView?.prepareForReuse()
        overlayImageView?.image = nil
        // don't overwrite values in UI, it's better do it in the next configureWithViewModel
    }
    
    func updateForPressedState() {
        let needsHighlighting = self.doesSupportHighlighting && viewModel?.button.actionType != UIGridButton.ActionType.none
        if needsHighlighting {
            self.alpha = (self.isSelected || self.isHighlighted) ? 0.4 : 1.0
        }
        else {
            self.alpha = 1.0
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            updateForPressedState()
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            updateForPressedState()
        }
    }
}

extension UIGridButtonView {
    
    func loadText() {
        guard let viewModel else { return }
        
        guard
            let text = viewModel.button.text,
            !text.isEmpty else {
            textLabel.text = ""
            removeTextGradient()
            return
        }
        loadTextLabel(isFirstLaunch: false)
        
        // clear during loading
        if viewModel.loadedAttributedText == nil {
            self.textLabel.text = ""
        }
        textLabel.alpha = CGFloat(viewModel.button.textOpacity) / 100.0
        
        let askedButton = viewModel.button
        viewModel.generateAttributedText { text, fontSize in
            /// cell was updated to another view model
            guard self.viewModel?.button == askedButton else { return }
            
            if viewModel.button.isTextShouldFit {
                self.textLabel.minimumScaleFactor = 12.0 / fontSize
                self.textLabel.adjustsFontSizeToFitWidth = true
            }
            
            self.textLabel.attributedText = text
            self.textLabel.lineBreakMode = .byTruncatingTail
            
            self.updateTextConstraints()
            // disable UICollectionView flickering when text constraints updating
            UIView.animate(withDuration: 0.0) {
                self.layoutIfNeeded()
            }
            self.updateAccessibilityValues()
        }
    }
    
    func loadTextLabel(isFirstLaunch: Bool) {
        fixOrderOfSubviews()
        
        if textConstraints != nil &&
            lastVerticalAlign == viewModel?.button.textVAlign {
            loadTextGradientBackgroundIfNeeded()
            return
        }
        
        updateTextConstraints()
        
        /// disable UICollectionView flickering when text constraints updating
        UIView.animate(withDuration: 0.0) {
            self.layoutIfNeeded()
        }
        loadTextGradientBackgroundIfNeeded()
    }
    
    func fixOrderOfSubviews() {
        /// order is important
        [imageView, overlayImageView, gradientView, textLabel].forEach { view in
            guard let view else { return }
            if view.superview == contentView {
                contentView.sendSubviewToBack(view)
            }
            else {
                contentView.addSubview(view)
            }
        }
    }
    
    func loadTextGradientBackgroundIfNeeded() {
        guard let viewModel else { return }
        
        guard
            viewModel.button.shouldDrawGradientUnderText() == true else {
            removeTextGradient()
            return
        }
        
        let view: GradientView
        if let gradientView {
            view = gradientView
        }
        else {
            view = GradientView(frame: bounds)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gradientView = view
        }
        
        fixOrderOfSubviews()
        
        guard
            let gradientLayer = gradientView?.gradientLayer,
            let gradientColor = viewModel.button.textBackgroundGradientUIColor
        else {
            return
        }
        let bottomColor = gradientColor.withAlphaComponent(0.0)
        let middleColor = gradientColor.withAlphaComponent(0.1)
        let topColor = gradientColor.withAlphaComponent(0.7)
        gradientLayer.frame = bounds
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        
        switch viewModel.button.textVAlign {
        case .top:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
            
        case .middle:
            /// not supported
            removeTextGradient()
            
        case .bottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    func removeTextGradient() {
        guard gradientView != nil else { return }
        gradientView?.removeFromSuperview()
        gradientView = nil
    }
    
    func updateTextConstraints() {
        guard let viewModel else { return }
        
        if let textConstraints {
            NSLayoutConstraint.deactivate(textConstraints)
            self.textConstraints = nil
        }
        guard let textSuperview = textLabel.superview else {
            return
        }
        var result = [NSLayoutConstraint]()
        
        let leadingPadding: Double
        let trailingPadding: Double
        let topPadding: Double
        let bottomPadding: Double
        
        if viewModel.button.isDefaultTextPaddings,
           textLabel.attributedText != nil  {
            leadingPadding = Double(viewModel.button.textPaddings[1])
            trailingPadding = Double(viewModel.button.textPaddings[3])
            
            let maxInset = 12.0
            let minInset = 1.0
            
            let potentialFrame = CGRect(x: maxInset,
                                        y: maxInset,
                                        width: bounds.width - 2 * maxInset,
                                        height: bounds.height - 2 * maxInset)
            // TODO: fix performance
            let textFrameForPotential = textLabel.textRect(forBounds: potentialFrame,
                                                           limitedToNumberOfLines: 0)
            
            let infiniteHeightFrame = CGRect(x: maxInset,
                                             y: maxInset,
                                             width: bounds.width - 2 * maxInset,
                                             height: Double.greatestFiniteMagnitude)
            
            let textFrameForInfiniteHeight = textLabel.textRect(forBounds: infiniteHeightFrame,
                                                                limitedToNumberOfLines: 0)
            
            if ceil(textFrameForInfiniteHeight.height) > ceil(textFrameForPotential.height) {
                topPadding = minInset
                bottomPadding = minInset
            }
            else {
                topPadding = Double(UIGridButton.Constants.textDefaultPaddings[0])
                bottomPadding = Double(UIGridButton.Constants.textDefaultPaddings[2])
            }
        }
        else if
            !viewModel.button.isDefaultTextPaddings,
            viewModel.button.textPaddings.count == 4 {
            
            topPadding = Double(viewModel.button.textPaddings[0])
            leadingPadding = Double(viewModel.button.textPaddings[1])
            bottomPadding = Double(viewModel.button.textPaddings[2])
            trailingPadding = Double(viewModel.button.textPaddings[3])
        }
        else {
            topPadding = Double(UIGridButton.Constants.textDefaultPaddings[0])
            leadingPadding = Double(UIGridButton.Constants.textDefaultPaddings[1])
            bottomPadding = Double(UIGridButton.Constants.textDefaultPaddings[2])
            trailingPadding = Double(UIGridButton.Constants.textDefaultPaddings[3])
        }
        
        result.append(textLabel.leftAnchor.constraint(equalTo: textSuperview.leftAnchor, constant: leadingPadding))
        result.append(textLabel.rightAnchor.constraint(equalTo: textSuperview.rightAnchor, constant: -trailingPadding))
        
        switch viewModel.button.textVAlign {
        case .top:
            result.append(textLabel.topAnchor.constraint(equalTo: textSuperview.topAnchor, constant: topPadding))
            result.append(textLabel.bottomAnchor.constraint(lessThanOrEqualTo: textSuperview.bottomAnchor, constant: -bottomPadding))
            
        case .middle:
            result.append(textLabel.topAnchor.constraint(equalTo: textSuperview.topAnchor, constant: topPadding))
            result.append(textLabel.bottomAnchor.constraint(equalTo: textSuperview.bottomAnchor, constant: -bottomPadding))
            
        case .bottom:
            result.append(textLabel.topAnchor.constraint(greaterThanOrEqualTo: textSuperview.topAnchor, constant: topPadding))
            result.append(textLabel.bottomAnchor.constraint(equalTo: textSuperview.bottomAnchor, constant: -bottomPadding))
        }
        
        lastVerticalAlign = viewModel.button.textVAlign
        NSLayoutConstraint.activate(result)
        textConstraints = result
    }
    
    func setupBorders() {
        guard let frame = viewModel?.button.frame else {
            layer.borderWidth = 0
            layer.cornerRadius = 0
            clipsToBounds = false
            return
        }
        if frame.borderWidth > 0 {
            layer.borderColor = frame.borderUIColor.cgColor
            layer.borderWidth = CGFloat(frame.borderWidth)
        }
        else if layer.borderWidth != 0.0 {
            layer.borderWidth = 0.0
        }
        
        if frame.cornerRadius > 0 {
            layer.cornerRadius = CGFloat(frame.cornerRadius)
            clipsToBounds = true
        }
        else if layer.cornerRadius != 0.0 {
            layer.cornerRadius = 0.0
            clipsToBounds = false
        }
    }
    
    func updateAccessibilityValues() {
        guard let viewModel else { return }
        
        contentView.accessibilityIdentifier = "buttonWithAction_\(viewModel.button.actionBody ?? "")"
        accessibilityTraits = .button
        contentView.isAccessibilityElement = true
        // attr could not be loaded yet, so we wait
        if let attrText = viewModel.loadedAttributedText, attrText.length > 0 {
            accessibilityLabel = attrText.string
        }
        else {
            accessibilityLabel = nil
        }
    }
    
    func loadBackgroundMedia() {
        guard let viewModel else { return }
        guard let mediaUrl = viewModel.button.backgroundMedia else {
            removeBackgroundViews()
            return
        }
        
        let askedButton = viewModel.button
        
        // clear during loading
        backgroundImageView?.image = nil
        mediaView?.prepareForReuse()
        
        if let loadingBackgroundColor = viewModel.loadingBackgroundColor {
            backgroundColor = loadingBackgroundColor
        }
        
        /// Attention, we use self.bounds instead of self.contentView.bounds, because in this case contentView still have invalid bounds
        viewModel.requestBackgroundMedia(sizeInUI: bounds.size,
                                         handler: { result in
            guard askedButton == self.viewModel?.button else { return }
            
            switch result {
            case .success(let success):
                if let mediaView = success.1 {
                    self.handledReceivedMedia(mediaView)
                }
                else {
                    self.handleReceivedBackgroundImage(success.0, animated: !viewModel.highPriorityOfImageDownloading)
                }
                
            case .failure:
                let placeholder = viewModel.button.doesBackgroundMediaContainMapSnapshot ? UIImage(named: Constants.locationPlaceholder) : nil
                self.handleReceivedBackgroundImage(placeholder, animated: !viewModel.highPriorityOfImageDownloading)
            }
        })
    }
    
    private func handleReceivedBackgroundImage(_ image: UIImage?,
                                               animated: Bool) {
        if image != nil {
            backgroundColor = viewModel?.button.backgroundUIColor
        }
        loadBackgroundImageView()
        backgroundImageView?.set(image: image, animated: animated)
        
        if let mediaView {
            mediaView.prepareForReuse()
            mediaView.isHidden = true
        }
    }
    
    func loadBackgroundImageView() {
        defer {
            if backgroundView != backgroundImageView {
                backgroundView = backgroundImageView
            }
            backgroundView?.isHidden = false
        }
        guard backgroundImageView == nil else {
            return
        }
        
        backgroundImageView = UIImageView(frame: contentView.bounds)
        backgroundImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView?.contentMode = .scaleToFill
    }
    
    func handledReceivedMedia(_ view: any UIGridMediaView) {
        backgroundColor = viewModel?.button.backgroundUIColor
        
        /// TODO: decide with equality
        if let mediaView {
            mediaView.removeFromSuperview()
        }
        mediaView = view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        backgroundView = mediaView
        view.isHidden = false
        
        mediaView = view
        
        if let backgroundImageView {
            backgroundImageView.isHidden = true
            backgroundImageView.image = nil
        }
    }
    
    func loadImage() {
        guard let viewModel else { return }
        
        guard let imageUrl = viewModel.button.image else {
            if let imageView {
                imageView.image = nil
                imageView.isHidden = true
            }
            return
        }
        let askedButton = viewModel.button
        
        imageView?.image = nil
        viewModel.requestImage(sizeInUI: bounds.size) { result in
            guard askedButton == self.viewModel?.button else { return }
            switch result {
            case .success(let success):
                self.loadImageView()
                self.imageView?.set(image: success, animated: true)
            case .failure:
                self.imageView?.set(image: nil, animated: true)
                self.imageView?.isHidden = true
            }
        }
    }
    
    func loadOverlay() {
        guard let viewModel else { return }
        guard let icon = viewModel.button.overlayIconImage else {
            if overlayImageView != nil {
                overlayImageView?.removeFromSuperview()
                overlayImageView = nil
            }
            return
        }
        loadOverlayImageView()
        overlayImageView?.image = icon
    }
    
    func loadImageView() {
        defer {
            imageView?.isHidden = false
            fixOrderOfSubviews()
        }
        guard imageView == nil else {
            return
        }
        
        imageView = UIImageView(frame: contentView.bounds)
        imageView?.contentMode = .scaleAspectFill
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.pinAutolayoutToSuperview()
    }
    

    func loadOverlayImageView() {
        defer {
            fixOrderOfSubviews()
        }
        guard overlayImageView == nil else {
            return
        }
        
        overlayImageView = UIImageView(frame: contentView.bounds)
        overlayImageView?.contentMode = .center
        overlayImageView?.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView?.clipsToBounds = true
        overlayImageView?.pinAutolayoutToSuperview()
    }
    
    func removeBackgroundViews() {
        if let mediaView {
            mediaView.prepareForReuse()
            mediaView.isHidden = true
        }
        if let backgroundImageView {
            backgroundImageView.image = nil
            backgroundImageView.isHidden = true
        }
        backgroundView = nil
    }
    
    /// ex. startBackgroundAnimation
    func startMediaAnimation() {
        mediaView?.startAnimation(withLoop: viewModel?.button.isLoopInBackground == true)
    }
    
    /// ex. stopBackgroundAnimation
    func stopMediaAnimation() {
        mediaView?.stopAnimation()
    }
}

extension UIGridButtonView {
    
    /// Used to get already loaded image
    public var frontImage: UIImage? {
        imageView?.image
    }
    
    /// Used to get already loaded image
    public var backgroundImage: UIImage? {
        backgroundImageView?.image
    }
    
    public var cellContentView: UIView {
        self
    }
    
    public var previewImageView: UIView? {
        return self
    }
}

// TODO: fix
//extension VIBConversationOpenGalleryAnimatorStartViewProtocol, VIBConversationCloseGalleryAnimatorFinalViewProtocol

extension UIView {
    func pinAutolayoutToSuperview() {
        guard let superview else { return }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}

extension UIImageView {
    func set(image: UIImage?, animated: Bool) {
        guard animated else {
            self.image = image
            return
        }
        
        UIView.transition(with: self,
                          duration: 0.2) {
            self.image = image
        }
    }
}

#endif
