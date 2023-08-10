//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import UIKit
import UIGrid

public enum UIGridButtonViewModelError: Error {
    case noUrlsForMedia
}

/// self.backgroundGIFView.animatedImage = gifImage
/// self.backgroundGIFView.contentMode = [self contentModeForScaleType:askedVM.backgroundMediaScaleType]
public protocol UIGridMediaView: AnyObject, UIView, Equatable {
    
    // TODO: implement it
    /// backgroundGIFView.image = nil
    /// backgroundGIFView.animatedImage = nil
    func prepareForReuse()
    
    //
//    if viewModel?.button.isLoopInBackground != true {
//        mediaView?.stopAnimation(forceStop: false)
//    }
    func startAnimation(withLoop: Bool)
    
    /// not force will do it after end of current
    /// TODO:     self.backgroundGIFView.loopCompletionBlock = @weakselfnotnil(^(NSUInteger loop)) {
//    [self.backgroundGIFView stopAnimating]
//} @weakselfend

    func stopAnimation()
}

public protocol UIGridMediaProvider: AnyObject {
    
    func requestImage(_ url: URL,
                      sizeInUI: CGSize,
                      contentMode: UIView.ContentMode,
                      allowToHandleSynchronously: Bool,
                      handler: (Result<UIImage, Error>) -> Void)
    
    func requestBackgroundMedia(_ url: URL,
                                type: UIGridButton.BackgroundMediaType,
                                sizeInUI: CGSize,
                                handler: (Result<(UIImage?, (any UIGridMediaView)?), Error>) -> Void)

    func cancelFetching(_ url: URL)
}

public protocol UIGridAttributedTextGenerator {
    
    func generateAttributedString(for textWithHTMLTags: String,
                                  fontSize: CGFloat,
                                  textAlignment: NSTextAlignment,
                                  completion: (NSAttributedString?) -> Void)
}

public protocol UIGridButtonViewModelInjection {
    var mediaProvider: UIGridMediaProvider? { get }
    var textGenerator: UIGridAttributedTextGenerator? { get }
}

public final class UIGridButtonViewModel {
    
    public init(gridType: UIGridType,
                button: UIGridButton,
                publicAccountId: String?,
                loadingBackgroundColor: UIColor? = nil,
                injection: UIGridButtonViewModelInjection) {
        self.gridType = gridType
        self.button = button
        self.publicAccountId = publicAccountId
        self.loadingBackgroundColor = loadingBackgroundColor
        self.injection = injection
    }
    
    public let gridType: UIGridType
    public let button: UIGridButton
    
    /// Public account ID which generated this  keyboard's button
    public var publicAccountId: String?
    
    /// Background color that is used until media is loaded.
    public var loadingBackgroundColor: UIColor?
    
    public var highPriorityOfImageDownloading: Bool {
        guard gridType == .keyboard else {
            return false
        }
        return button.image != nil ||
        (button.backgroundMedia != nil && button.backgroundMediaType == .picture)
    }

    let injection: UIGridButtonViewModelInjection
    
    /// completion in bg thread
    public func requestBackgroundMedia(sizeInUI: CGSize,
                                       handler: @escaping (Result<(UIImage?, (any UIGridMediaView)?), Error>) -> Void) {
        guard let url = button.backgroundMedia else {
            handler(.failure(UIGridButtonViewModelError.noUrlsForMedia))
            return
        }
        let contentMode = button.backgroundMediaContentMode
        injection.mediaProvider?.requestBackgroundMedia(url,
                                                        type: button.backgroundMediaType,
                                                        sizeInUI: sizeInUI,
                                                        handler: { result in
            onMain {
                handler(result)
            }
        })
    }

    public func requestImage(sizeInUI: CGSize,
                             handler: @escaping (Result<UIImage, Error>) -> Void) {
        let contentMode = button.imageContentMode // ex VIBImageContentMode
        guard let imageUrl = button.image else {
            handler(.failure(UIGridButtonViewModelError.noUrlsForMedia))
            return
        }
        injection.mediaProvider?.requestImage(imageUrl,
                                              sizeInUI: sizeInUI,
                                              contentMode: contentMode,
                                              allowToHandleSynchronously: highPriorityOfImageDownloading,
                                              handler: { result in
            onMain {
                handler(result)
            }
        })
    }
    
    public func cancelDownloadingRequests() {
        [button.image, button.backgroundMedia].forEach { url in
            guard let url else { return }
            self.injection.mediaProvider?.cancelFetching(url)
        }
    }
        
    public var loadedAttributedText: NSAttributedString?
    
    /**
     * Ask to generate attr.text from rawText, returns attrText if it was parsed before
     **/
    public func generateAttributedText(handler: @escaping (_ text: NSAttributedString?, _ fontSize: CGFloat) -> Void) {
        let fontSize = button.textSize.fontSize
        
        if let loadedAttributedText {
            handler(loadedAttributedText, fontSize)
            return
        }
        guard let text = button.text,
              !text.isEmpty,
              let generator = injection.textGenerator
        else {
            handler(nil, fontSize)
            return
        }
        
        generator.generateAttributedString(for: text,
                                           fontSize: button.textSize.fontSize,
                                           textAlignment: button.textAlignment) { result in
            self.loadedAttributedText = result
            handler(result, fontSize)
        }
    }
}
