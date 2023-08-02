//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import Foundation
import UIKit
import UIGrid

// TODO: check if we still needs it
public enum UIGridViewModelError: Error {
    
    /// hierarchy and types (Mantle validation)
    case invalidHierarchyJSON
    
    /// layout of buttons could not be prepared
    case invalidLayout
    
    /// model created but haven't mandatory values
    case notEnoughDetails
}

public struct UIGridActionContext {
    
    public init(grid: UIGrid,
                button: UIGridButton,
                buttonViewModel: UIGridButtonViewModel,
                buttonView: UIGridButtonView,
                analyticsContext: AnalyticsContext?) {
        self.grid = grid
        self.button = button
        self.buttonViewModel = buttonViewModel
        self.buttonView = buttonView
        self.analyticsContext = analyticsContext
    }
    
    public let grid: UIGrid
    public let button: UIGridButton
    
    public let buttonView: UIGridButtonView
    public let buttonViewModel: UIGridButtonViewModel
    
    public let analyticsContext: AnalyticsContext?
}

public protocol UIGridViewActionHandling {
    
    func handleAction(from uiGrid: UIGrid, context: UIGridActionContext)
}

public final class UIGridViewModel {
    
    public let grid: UIGrid
    public let buttonViewModels: [UIGridButtonViewModel]
    
    public let defaultBackgroundColor: UIColor
    
    public var gridGroupSize: UIGridSize {
        UIGridSize(width: UInt(grid.buttonsGroupColumns ?? 1),
                   height: UInt(grid.buttonsGroupRows ?? 1))
    }
    /// List of button-element models with open-url picture and GIF type
    public var buttonsForGallery: [UIGridButtonViewModel] {
        buttonViewModels.filter { vm in
            guard
                let actionBody = vm.button.actionBody,
                !actionBody.isEmpty
            else {
                return false
            }
            return vm.button.actionType == .openUrl && (vm.button.openUrlMediaType == .picture || vm.button.openUrlMediaType == .gif)
        }
    }
    
    public var isQueryingForNewKeyboard: Bool = false
    
    public var publicAccountId: String? {
        didSet {
            buttonViewModels.forEach { buttonViewModel in
                buttonViewModel.publicAccountId = publicAccountId
            }
        }
    }
    
    /// for cache logics
    public var createDate: Date?
    public var relatedMessageToken: UInt64?
    
    public var actionHandler: UIGridViewActionHandling?
    public var mediaProvider: UIGridMediaProvider?
    public var textGenerator: UIGridAttributedTextGenerator?
    
    /// ex hasSingleButtonWithMedia
    public var isSingleMediaButtonOnly: Bool {
        guard
            grid.buttons.count == 1,
            let button = grid.buttons.first
        else {
            return false
        }
        return button.backgroundMedia != nil && button.backgroundMediaType != .unknown
    }
    
    /// Background color that is used until media is loaded.
    public var loadingBackgroundColor: UIColor? {
        guard grid.type == .richMedia else { return nil }
        return isSingleMediaButtonOnly ? grid.backgroundUIColor : nil
    }
    
    public init(grid: UIGrid,
                publicAccountId: String? = nil,
                actionHandler: UIGridViewActionHandling?,
                defaultBackgroundColor: UIColor,
                mediaProvider: UIGridMediaProvider?) {
        self.grid = grid
        self.publicAccountId = publicAccountId
        self.actionHandler = actionHandler
        self.mediaProvider = mediaProvider
        
        //    NSError *unError = nil;
        //    VIBUIGridModel *viewModel = nil;
        //    if (jsonString.length > 0) {
        //        viewModel = mantleFromJSONStringForClass(jsonString, [self class], &unError);
        //    }
        //    else if (jsonDictionary.count > 0) {
        //        viewModel = mantleFromJSONDictionaryForClass(jsonDictionary, [self class], &unError);
        //    }
        //
        //    if (!viewModel) {
        //        if (error) {
        //            if (unError && unError.domain == kVIBUIGridModelErrorDomain) {
        //                *error = unError;
        //            }
        //            else {
        //                *error = [NSError errorWithDomain:kVIBUIGridModelErrorDomain
        //                                             code:VIBUIGridModelError_InvalidHierarchyJSON
        //                             localizedDescription:@"Invalid JSON"
        //                           localizedFailureReason:[NSString stringWithFormat:@"%@ could not be created because an invalid JSON array was provided: %@", NSStringFromClass([VIBUIGridModel class]), jsonString]
        //                                  underlyingError:unError];
        //            }
        //        }
        //        return nil;
        //    }
        //
        //    [viewModel setMediaDataSource:mediaDataSource];
        //    [viewModel setActionHandler:handler];
        //    [viewModel setPublicAccountID:publicAccountID];
        //    [viewModel updateButtonsSize];
        //    return viewModel;
        //        // it's mistake, default color is white, but we use clear color from first release(
        //        self.backgroundColor = nil;
        //        self.buttonsGroupRows = [[self class] defaultButtonsgridGroupSize].height;
        //        self.buttonsGroupColumns = [[self class] defaultButtonsgridGroupSize].width;
    }
    
    // TODO: fix defaultButtonsgridGroupSize
    
    //- (BOOL)validateLayout:(NSError *__autoreleasing *)error {
    //    NSError *layoutError = nil;
    //    NSMutableDictionary <NSIndexPath *, NSValue *> *elements = [NSMutableDictionary dictionary];
    //    [self.buttonModels enumerateObjectsUsingBlock:^(VIBUIGridButtonModel * _Nonnull buttonVM, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSIndexPath *path = [NSIndexPath indexPathForItem:idx inSection:0];
    //        [elements setObject:[NSValue valueWithCGSize:buttonVM.size] forKey:path];
    //    }];
    //
    //    VIBGridStorage *storage = [VIBGridStorageGenerator gridForElements:elements
    //                                                        gridBlockWidth:self.buttonsGroupColumns
    //                                                        groupBlockSize:CGSizeMake(self.buttonsGroupColumns, self.buttonsGroupRows)
    //                                                                 error:&layoutError];
    //
    //    if (!storage || layoutError) {
    //        if (error) {
    //            *error = [NSError errorWithDomain:kVIBUIGridModelErrorDomain
    //                                         code:VIBUIGridModelError_InvalidLayout
    //                         localizedDescription:@"Invalid layout"
    //                       localizedFailureReason:[NSString stringWithFormat:@"Keyboard contains invalid layout of buttons: %@", self]
    //                              underlyingError:layoutError];
    //        }
    //        return NO;
    //    }
    //
    //    return YES;
    //}
    
    //- (void)updateButtonsSize {
    //    [self.buttonModels makeObjectsPerformSelector:@selector(updateSizeViaDefaultSize:) withObject:[NSValue valueWithCGSize:[self defaultButtonSize]]];
    //}
    
    //#import "VIBUIGridRichMessageModel.h"
    //@import ViberCoreLegacy;
    //@import ViberCoreDatabase;
    //
    //// These limitations only as protection from possible server validation bugs
    //static const NSUInteger kVIBUIGridRichMessageMaxHeightScale = 200;
    //static const NSUInteger kVIBUIGridRichMessageDefaultHeightScale = 100;
    //static const NSUInteger kVIBUIGridRichMessageMinHeightScale = 10;
    //
    //
    //@implementation VIBUIGridRichMessageModel
    //
    //+ (instancetype)modelFromJSON:(NSString *)jsonString publicAccountID:(NSString *)publicAccountID handler:(id<VIBUIGridButtonModelHandlerProtocol>)handler mediaDataSource:(id<VIBMediaProviderProtocol>)mediaDataSource error:(NSError *__autoreleasing *)error {
    //    VIBUIGridRichMessageModel *model = [super modelFromJSON:jsonString publicAccountID:publicAccountID handler:handler mediaDataSource:mediaDataSource error:error];
    //
    //    if (model.favoritesMetadata != nil) {
    //        model.favoritesMetadata.richMedia = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
    //                                                                            options:kNilOptions
    //                                                                              error:nil];
    //    }
    //
    //    return model;
    //}
    //
    //
    //+ (instancetype)modelFromJSONDictionary:(NSDictionary *)jsonDictionary publicAccountID:(NSString *)publicAccountID handler:(id<VIBUIGridButtonModelHandlerProtocol>)handler mediaDataSource:(id<VIBMediaProviderProtocol>)mediaDataSource error:(NSError *__autoreleasing *)error {
    //    VIBUIGridRichMessageModel *model = [super modelFromJSONDictionary:jsonDictionary publicAccountID:publicAccountID handler:handler mediaDataSource:mediaDataSource error:error];
    //
    //    if (model.favoritesMetadata != nil) {
    //        model.favoritesMetadata.richMedia = jsonDictionary;
    //    }
    //
    //    return model;
    //}
    //
    //
    //- (instancetype)init {
    //    if (self = [super init]) {
    //        _heightScale = kVIBUIGridRichMessageDefaultHeightScale;
    //    }
    //    return self;
    //}
    //
    //
    //- (instancetype)initWithHeightScale:(NSUInteger)heightScale
    //                  favoritesMetadata:(VIBBotActionMetadata *)favoritesMetadata {
    //    if (self = [super init]) {
    //        _heightScale = heightScale;
    //        _isDefaultScale = isDefaultScale;
    //        _favoritesMetadata = favoritesMetadata;
    //    }
    //    return self;
    //}
    //
    //
    //+ (CGSize)defaultButtonsgridGroupSize {
    //    return CGSizeMake(6, 7);
    //}
    //
    //
    //- (CGSize)defaultButtonSize {
    //    return CGSizeMake(self.buttonsGroupColumns, self.buttonsGroupRows);
    //}
    //
    //
    //- (BOOL)isIsDefaultScale {
    //    return self.heightScale == kVIBUIGridRichMessageDefaultHeightScale;
    //}
    //
    //
    //#pragma mark - JSON
    //
    //+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    //    NSDictionary *keys = [super JSONKeyPathsByPropertyKey];
    //    return [keys mtl_dictionaryByAddingEntriesFromDictionary:@{
    //                                                                @keypath(VIBUIGridRichMessageModel.new, heightScale): @"HeightScale",
    //                                                                @keypath(VIBUIGridRichMessageModel.new, favoritesMetadata): @"FavoritesMetadata"
    //                                                               }];
    //}
    //
    //
    //+ (NSValueTransformer *)heightScaleJSONTransformer {
    //    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *jsonValue, BOOL *success, NSError *__autoreleasing *error) {
    //        if (jsonValue == nil || ![jsonValue isKindOfClass:[NSNumber class]]) {
    //            return @(kVIBUIGridRichMessageDefaultHeightScale);
    //        }
    //        NSUInteger heightScaleValue = jsonValue.unsignedIntegerValue;
    //        if (heightScaleValue > kVIBUIGridRichMessageMaxHeightScale || heightScaleValue < kVIBUIGridRichMessageMinHeightScale) {
    //            return @(kVIBUIGridRichMessageDefaultHeightScale);
    //        }
    //        return jsonValue;
    //    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
    //        return number;
    //    }];
    //}
    //
    //
    //+ (NSValueTransformer *)favoritesMetadataJSONTransformer {
    //    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[VIBBotActionMetadata class]];
    //}
    //
    //
    //@end

    // TODO: implement
//    - (void)updateButtonsSize {
//        [self.buttonModels makeObjectsPerformSelector:@selector(updateSizeViaDefaultSize:) withObject:[NSValue valueWithCGSize:[self defaultButtonSize]]];
//    }
    
    // TODO: move from button to the grid
    public func handleAction() {
//        if (self.pressGuard.isLocked) {
//            return
//        }
//        [self.pressGuard lock]
//        LogDebugDomain(@"Handle action for %@", self)
//        if (self.actionHandler) {
//            [self.actionHandler uiGrid:uiGrid handleActionWithContext:actionContext]
//        }
    }

    public func cancelDownloadingRequests() {
        buttonViewModels.forEach { vm in
            vm.cancelDownloadingRequests()
        }
    }
}

extension UIGridViewModel: UIGridButtonViewModelInjection {
}
