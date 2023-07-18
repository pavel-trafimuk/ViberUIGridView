////
////  File.swift
////  
////
////  Created by Pavel Trafimuk on 11/01/2023.
////  Viber Media, Inc.
//
//import Foundation
//
//public enum UIGridBuilderError: Error {
//    case typeNotProvided
//    case columnsAreNotProvided
//    case rowsAreNotProvided
//    case actionTypeNotProvided
//    case buttonsNotProvided
//}
//
//public final class UIGridBuilder {
//    public init() {}
//    public static var richMedia: UIGridBuilder { .init().type(.richMedia) }
//    public static var keyboard: UIGridBuilder { .init().type(.keyboard) }
//
//    private var _type: UIGridType?
//    public func type(_ newValue: UIGridType) -> Self {
//        _type = newValue
//        return self
//    }
//
//    private var _isDefaultHeight: Bool?
//    public func isDefaultHeight(_ newValue: Bool) -> Self {
//        _isDefaultHeight = newValue
//        return self
//    }
//
//    private var _backgroundColor: String?
//    public func backgroundColor(_ newValue: String) -> Self {
//        _backgroundColor = newValue
//        return self
//    }
//
//    private var _buttons: [UIGridButton]?
//    public func buttons(_ newValue: [UIGridButton]) -> Self {
//        _buttons = newValue
//        return self
//    }
//
//    private var _buttonsBuilders: [UIGridButtonBuilder]?
//    public func buttons(_ newValue: [UIGridButtonBuilder?]) -> Self {
//        _buttonsBuilders = newValue.compactMap{ $0}
//        return self
//    }
//    
//    private var _buttonsGroupColumns: Int?
//    public func buttonsGroupColumns(_ newValue: Int) -> Self {
//        _buttonsGroupColumns = newValue
//        return self
//    }
//
//    private var _buttonsGroupRows: Int?
//    public func buttonsGroupRows(_ newValue: Int) -> Self {
//        _buttonsGroupRows = newValue
//        return self
//    }
//
//    private var _inputFieldState: UIGrid.InputFieldState?
//    public func inputFieldState(_ newValue: UIGrid.InputFieldState) -> Self {
//        _inputFieldState = newValue
//        return self
//    }
//
//    public func build() throws -> UIGrid {
//        guard let _type else {
//            throw UIGridBuilderError.typeNotProvided
//        }
//        let buttons: [UIGridButton]
//        if let _buttons {
//            buttons = _buttons
//        }
//        else if let _buttonsBuilders {
//            buttons = try _buttonsBuilders.map { try $0.build() }
//        }
//        else {
//            throw UIGridBuilderError.buttonsNotProvided
//        }
//        return UIGrid(type: _type,
//                          isDefaultHeight: _isDefaultHeight,
//                          backgroundColor: _backgroundColor,
//                          buttons: buttons,
//                          buttonsGroupColumns: _buttonsGroupColumns,
//                          buttonsGroupRows: _buttonsGroupRows,
//                          inputFieldState: _inputFieldState)
//    }
//}
//
//public final class UIGridButtonBuilder {
//    public init() {}
//    
//    private var _columns: Int?
//    private var _rows: Int?
//
//    public func size(width: Int, height: Int) -> Self {
//        _columns = width
//        _rows = height
//        return self
//    }
//    
//    private var _backgroundColor: String?
//    public func backgroundColor(_ newValue: String) -> Self {
//        _backgroundColor = newValue
//        return self
//    }
//    
//    private var _backgroundMediaType: UIGridButton.BackgroundMediaType?
//    public func backgroundMediaType(_ newValue: UIGridButton.BackgroundMediaType) -> Self {
//        _backgroundMediaType = newValue
//        return self
//    }
//    
//    private var _backgroundMedia: URL?
//    public func backgroundMedia(_ newValue: URL) -> Self {
//        _backgroundMedia = newValue
//        return self
//    }
//
//    private var _backgroundScaleType: UIGridButton.MediaScaleType?
//    public func backgroundScaleType(_ newValue: UIGridButton.MediaScaleType) -> Self {
//        _backgroundScaleType = newValue
//        return self
//    }
//    
//    public func background(_ url: URL,
//                           type: UIGridButton.BackgroundMediaType = .picture,
//                           scale: UIGridButton.MediaScaleType? = nil) -> Self {
//        _backgroundMedia = url
//        _backgroundMediaType = type
//        _backgroundScaleType = scale
//        return self
//    }
//    
//    private var _isSilent: Bool?
//    
//    public func isSilent(_ newValue: Bool) -> Self {
//        _isSilent = newValue
//        return self
//    }
//    
//    public private(set) var _actionType: UIGridButton.ActionType?
//    public func action(_ type: UIGridButton.ActionType, body: String?) -> Self {
//        _actionType = type
//        _actionBody = body
//        return self
//    }
//    
//    public private(set) var _actionBody: String?
//
//    private var _image: URL?
//    public func image(_ newValue: URL) -> Self {
//        _image = newValue
//        return self
//    }
//    
//    private var _imageScaleType: UIGridButton.MediaScaleType?
//    public func imageScaleType(_ newValue: UIGridButton.MediaScaleType) -> Self {
//        _imageScaleType = newValue
//        return self
//    }
//
//    private var _text: String?
//    public func text(_ newValue: String?) -> Self {
//        _text = newValue
//        return self
//    }
//    
//    private var _textColor: String?
//    public func textColor(_ newValue: String) -> Self {
//        _textColor = newValue
//        return self
//    }
//
//    private var _textSize: UIGridButton.TextSize?
//    public func textSize(_ newValue: UIGridButton.TextSize) -> Self {
//        _textSize = newValue
//        return self
//    }
//
//    private var _textVAlign: String?
//    public func textVAlign(_ newValue: String) -> Self {
//        _textVAlign = newValue
//        return self
//    }
//
//    private var _textHAlign: String?
//    public func textHAlign(_ newValue: String) -> Self {
//        _textHAlign = newValue
//        return self
//    }
//
//    private var _openUrlType: UIGridButton.OpenUrlType?
//    public func openUrlType(_ newValue: UIGridButton.OpenUrlType) -> Self {
//        _openUrlType = newValue
//        return self
//    }
//
//    private var _openUrlMediaType: UIGridButton.OpenUrlMediaType?
//    public func openUrlMediaType(_ newValue: UIGridButton.OpenUrlMediaType) -> Self {
//        _openUrlMediaType = newValue
//        return self
//    }
//
//    private var _frame: UIGridButton.Frame?
//    public func frame(_ newValue: UIGridButton.Frame) -> Self {
//        _frame = newValue
//        return self
//    }
//
//    public func build() throws -> UIGridButton {
//        guard let _columns else {
//            throw UIGridBuilderError.columnsAreNotProvided
//        }
//        guard let _rows else {
//            throw UIGridBuilderError.rowsAreNotProvided
//        }
//        guard let _actionType else {
//            throw UIGridBuilderError.actionTypeNotProvided
//        }
//        let finalText: String?
//        if let color = _textColor {
//            finalText = _text?.htmlTextColor(color)
//        }
//        else {
//            finalText = _text
//        }
//        return UIGridButton.init(columns: _columns,
//                                      rows: _rows,
//                                      backgroundColor: _backgroundColor,
//                                      backgroundMediaType: _backgroundMediaType,
//                                      backgroundMedia: _backgroundMedia,
//                                      backgroundScaleType: _backgroundScaleType,
//                                      actionType: _actionType,
//                                      actionBody: _actionBody,
//                                      isSilent: _isSilent,
//                                      image: _image,
//                                      imageScaleType: _imageScaleType,
//                                      openUrlType: _openUrlType,
//                                      openUrlMediaType: _openUrlMediaType,
//                                      text: finalText,
//                                      textSize: _textSize,
//                                      textVAlign: _textVAlign,
//                                      textHAlign: _textHAlign,
//                                      frame: _frame)
//    }
//}
