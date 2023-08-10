//
//  Created by Pavel Trafimuk
//  Copyright © 2023 Viber Media Sarl. All rights reserved.
//

import XCTest
@testable import UIGrid

public enum UIGridTestsError: Error {
    case notExists
}

extension UIGrid {
    static func load(from filename: String) throws -> UIGrid {
        let bundle = Bundle.module
        guard
            let url = bundle.url(forResource: filename, withExtension: "json", subdirectory: "jsons")
        else {
            throw UIGridTestsError.notExists
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(UIGrid.self, from: data)
    }
}

final class UIGridTests: XCTestCase {
    
    let sourceBundle = Bundle(for: UIGridTests.self)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOneButton() throws {
        let vm = try UIGrid.load(from: "botKeyboardOneButton")
        
        XCTAssert(vm.buttons.count == 1, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight == nil, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#454545", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "www.tvp.info", "Incorrect button action body")
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<b>Viber</b> is the best company")
            XCTAssert(b.textHAlign == .center, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
    }
    
    func testLoadExampleFromSpec1() throws {
        let vm = try UIGrid.load(from: "botKeyboardJSONExample1")
        
        XCTAssert(vm.buttons.count == 2, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight == nil, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 3, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#55C3B8", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "Yes", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<b><font color=\"#ffffff\">Yes</font></b>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .left, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.size.width == 3, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#55C3B8", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .gif, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == URL(string: "https://www.dropbox.com/s/nfe3b58dyf57ak5/no.gif?dl=1"), "Incorrect button background media URL")
            XCTAssert(b.actionBody == "No", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<font color=\"#ffffff\">No</font>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .left, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
    }
    
    
    func testLoadExampleFromSpec2() throws {
        let vm = try UIGrid.load(from: "botKeyboardJSONExample2")
        
        XCTAssert(vm.buttons.count == 3, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#69C48A", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "Today", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<b><font color=\"#ffffff\">Today's Forecast</font></b>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .center, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .small, "Incorrect button text size")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#58C3B8", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "Tomorrow", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<font color=\"#ffffff\">Tomorrow's Forecast</font>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .center, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .small, "Incorrect button text size")
        }
        do {
            let b = vm.buttons[2]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#53C0D3", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "Next 5 days", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<font color=\"#ffffff\">Next 5 days Forecast</font>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .center, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .small, "Incorrect button text size")
        }
    }
    
    func testLoadExampleFromSpec3() throws {
        let vm = try UIGrid.load(from: "botKeyboardJSONExample3")
        
        XCTAssert(vm.buttons.count == 2, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 2, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#00FF00", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == URL(string: "http://www.our-energy.com/wp-content/uploads/2015/08/windmill-826150.jpg"), "Incorrect button background media URL")
            XCTAssert(b.actionBody == "http://bbc.com/green_energy.html", "Incorrect button action body")
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<font color=\"#ffffff\">Green Energy</font>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .left, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .large, "Incorrect button text size")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.size.width == 4, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#FFFFFF", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "http://bbc.com/trump.html", "Incorrect button action body")
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<i><font color=\"#bfbfbf\">CNN@Ukrain won</font> <br><font color=\"#FF0000\">Read More...</font></i>")
            XCTAssert(b.textHAlign == .left, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .small, "Incorrect button text size")
        }
    }
    
    
    func testBotKeyboardPNGBackground() throws {
        let vm = try UIGrid.load(from: "botKeyboardPNGBackground")
        
        XCTAssert(vm.buttons.count == 1, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#2db9b9", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.actionBody == "reply", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == URL(string: "http://images.clipartpanda.com/smiley-face-png-niEXeBpBT.png"), "Incorrect button image URL")
            XCTAssert(b.text == "test", "Incorrect button raw text")
            XCTAssert(b.textOpacity == 60, "Incorrect button text opacity")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
    }
    
    func testDefaultOpenURLType() throws {
        let vm = try UIGrid.load(from: "uiGridOpenURLType")
        
        XCTAssert(vm.buttons.count == 3, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[2]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.openUrlType == .external, "Incorrect button openURL type")
        }
    }
    
    func testInternalOpenURLType() throws {
        let vm = try UIGrid.load(from: "uiGridOpenURLType")
        
        XCTAssert(vm.buttons.count == 3, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.openUrlType == .internal, "Incorrect button openURL type")
        }
    }
    
    func testInvalidOpenURLType() throws {
        let vm = try UIGrid.load(from: "uiGridOpenURLType")
        
        XCTAssert(vm.buttons.count == 3, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        
        do {
            let b = vm.buttons[1]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.openUrlType == .external, "Incorrect button openURL type")
        }
    }
    
    func testTextGradients() throws {
        let vm = try UIGrid.load(from: "uiGridTextBackgroundGradient")
        XCTAssert(vm.buttons.count > 0, "Invalid count of buttons in botKeyboard")
        
        do {
            let b = vm.buttons[0]
            XCTAssert(b.textBackgroundGradientColor == nil, "Incorrect button text background gradient color")
            XCTAssert(!b.shouldDrawGradientUnderText(), "Incorrect button should DrawGradient value")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.textBackgroundGradientColor == "#3F3F3F", "Incorrect button text background gradient color")
            XCTAssert(b.shouldDrawGradientUnderText(), "Incorrect button should DrawGradient value")
        }
        do {
            let b = vm.buttons[2]
            XCTAssert(b.textBackgroundGradientColor == "invalid", "Incorrect button text background gradient color")
            XCTAssert(!b.shouldDrawGradientUnderText(), "Incorrect button should DrawGradient value")
        }
        do {
            let b = vm.buttons[3]
            XCTAssert(b.textBackgroundGradientColor == "3F3F3F", "Incorrect button text background gradient color")
            XCTAssert(b.shouldDrawGradientUnderText(), "Incorrect button should DrawGradient value")
        }
        do {
            let b = vm.buttons[4]
            XCTAssert(!b.shouldDrawGradientUnderText(), "Incorrect button should DrawGradient value")
        }
        do {
            let b = vm.buttons[5]
            XCTAssert(!b.shouldDrawGradientUnderText(), "Incorrect button should DrawGradient value")
        }
    }
    
    func testOpenURLMediaType() throws {
        let vm = try UIGrid.load(from: "uiGridOpenURLMediaType")
        
        XCTAssert(vm.buttons.count > 0, "Invalid count of buttons in botKeyboard")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.openUrlMediaType == .notMedia, "Incorrect openURLMediaType")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.openUrlMediaType == .notMedia, "Incorrect openURLMediaType")
        }
        do {
            let b = vm.buttons[2]
            XCTAssert(b.openUrlMediaType == .video, "Incorrect openURLMediaType")
        }
        do {
            let b = vm.buttons[3]
            XCTAssert(b.openUrlMediaType == .gif, "Incorrect openURLMediaType")
        }
        do {
            let b = vm.buttons[4]
            XCTAssert(b.openUrlMediaType == .picture, "Incorrect openURLMediaType")
        }
    }
    
    // TODO: add unknown types?
    
    func testInvalidJSON() throws {
        let vm = try UIGrid.load(from: "botKeyboardInvalidJSON")
    }
    
    func testCyrillicURL() throws {
        let vm = try UIGrid.load(from: "botKeyboardCyrillic")
    }
    
    func testInvalidTypes() throws {
        let vm = try UIGrid.load(from: "botKeyboardInvalidTypes")
        
        XCTAssert(vm.buttons.count == 2, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#FFFFFF", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == "ddd", "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == URL(string: "https://www.dropbox.com/s/nfe3b58dyf57ak5/no.gif?dl=1"), "Incorrect button image URL")
            XCTAssert(b.text == nil, "Incorrect button raw text")
            XCTAssert(b.textHAlign == .center, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 2, "Incorrect button height")
            XCTAssert(b.backgroundColor == "#55C3B8", "Incorrect button background color")
            XCTAssert(b.backgroundMediaType == .picture, "Incorrect button background media type")
            XCTAssert(b.isLoopInBackground == true, "Incorrect button background loops flag")
            XCTAssert(b.isSilent == nil, "Incorrect Silent Mode flag")
            XCTAssert(b.backgroundMedia == nil, "Incorrect button background media URL")
            XCTAssert(b.actionBody == nil, "Incorrect button action body")
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.image == nil, "Incorrect button image URL")
            XCTAssert(b.text == "<font color=\"#ffffff\">No</font>", "Incorrect button raw text")
            XCTAssert(b.textHAlign == .left, "Incorrect button text H align")
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textOpacity == 100, "Incorrect button text opacity")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
    }
    
    
    func testElementLayoutInGroup() throws {
        // 12 rows [{6,2},{6,2},{6,2},{6,2},{6,2},{5,1},{6,1}]
        let vm = try UIGrid.load(from: "botKeyboardButtonLayout")
        XCTAssert(vm.buttons.count == 7, "Invalid count of buttons in botKeyboard")
    }
    
    
    func testTextShouldFitDefaultValue() throws {
        // 12 rows [{6,2},{6,2},{6,2},{6,2},{6,2},{5,1},{6,1}]
        let vm = try UIGrid.load(from: "botKeyboardButtonLayout")
        XCTAssert(vm.buttons.count == 7, "Invalid count of buttons in botKeyboard")
        
        for button in vm.buttons {
            if vm.buttons.first == button {
                XCTAssert(button.isTextShouldFit == true)
            }
            else {
                XCTAssert(button.isTextShouldFit == false)
            }
        }
    }
    
    
    func testExceedButtonInLineLimits() throws {
        // 6 buttons in a line
        let vm = try UIGrid.load(from: "botKeyboardButtonInLineLimit1")
        
        XCTAssert(vm.buttons.count == 6, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight == nil, "Invalid use default keyboard height flag")
    }
    
    
    func testMissingURLsErrors() throws {
        let vm = try UIGrid.load(from: "botKeyboardJSONExample1")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.backgroundMedia == nil)
        }
    }
    
    func testNoMediaDataErrors() throws {
        let vm = try UIGrid.load(from: "botKeyboardNoMediaData")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.backgroundMedia != nil)
            XCTAssert(b.backgroundMediaType == .picture)
            XCTAssert(b.image != nil)
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.backgroundMedia != nil)
            XCTAssert(b.backgroundMediaType == .picture)
            XCTAssert(b.image != nil)
        }
    }
    
    func testTextLimit() throws {
        // we remove text limitation in the client
        let vm = try UIGrid.load(from: "botKeyboardTextLimit")
        
        XCTAssert(vm.buttons.count == 2, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        
        do {
            let b = vm.buttons[0]
            XCTAssert(b.text == "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890!12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890!123456789012312312312344412123123123!!--")
        }
    }
    
    
    func testRichMessagesJSONExample1() throws {
        let vm = try UIGrid.load(from: "richMessagesJSONExample")
        
        XCTAssert(vm.buttons.count == 5, "Invalid count of buttons in rich message")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.actionBody == "Yes", "Incorrect button action body")
            XCTAssert(b.isSilent == true, "Incorrect reply silent mode")
            XCTAssert(b.replyType == .message, "Incorrect button reply type")
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.actionType == .reply, "Incorrect button action type")
            XCTAssert(b.actionBody == "Yes", "Incorrect button action body")
            XCTAssert(b.isSilent == true, "Incorrect reply silent mode")
            XCTAssert(b.replyType == .query, "Incorrect button reply type")
        }
        do {
            let b = vm.buttons[2]
            XCTAssert(b.actionType == .openUrl, "Incorrect button action type")
            XCTAssert(b.actionBody == "No", "Incorrect button action body")
            XCTAssert(b.isSilent == false, "Incorrect reply silent mode")
            XCTAssert(b.replyType == .message, "Incorrect button reply type")
        }
        do {
            let b = vm.buttons[3]
            XCTAssert(b.actionType == .none, "Incorrect button action type")
            XCTAssert(b.actionBody == "No", "Incorrect button action body")
            XCTAssert(b.isSilent == nil, "Incorrect reply silent mode")
            XCTAssert(b.replyType == .message, "Incorrect button reply type")
        }
        do {
            let b = vm.buttons[4]
            XCTAssert(b.actionType == .openMap, "Incorrect button action type")
            XCTAssert(b.actionBody == "No", "Incorrect button action body")
            XCTAssert(b.isSilent == nil, "Incorrect reply silent mode")
            XCTAssert(b.replyType == .message, "Incorrect button reply type")
            XCTAssert(b.map?.longitude == 0.105)
            XCTAssert(b.map?.latitude == 50.005)
        }
    }
    
    func testMapModelSerializing() throws {
        let vm = try UIGrid.load(from: "richMessagesJSONExample")
        //Without map model
        do {
            let b = vm.buttons[3]
            XCTAssertNil(b.map)
        }
        
        //With map model
        do {
            let b = vm.buttons[4]
            XCTAssertNotNil(b.map)
        }
    }
    
    
    func testUIGrid_V_AsCenter_H_AsMiddle() throws {
        let vm = try UIGrid.load(from: "uiGridVCenterHMiddle")
        
        XCTAssert(vm.buttons.count == 1, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.textVAlign == .middle, "Incorrect button text V align")
            XCTAssert(b.textHAlign == .center, "Incorrect button text H align")
            XCTAssert(b.textSize == .regular, "Incorrect button text size")
        }
    }
    
    
    func testUIGridDefaultBackgroundColor() throws {
        let vm = try UIGrid.load(from: "uiGridDefaultBackgroundColor")
        
        XCTAssert(vm.buttons.count == 1, "Invalid count of buttons in botKeyboard")
        XCTAssert(vm.isDefaultHeight != true, "Invalid use default keyboard height flag")
        
        do {
            let b = vm.buttons[0]
            XCTAssert(b.backgroundColor == nil, "Incorrect button background color")
        }
    }
    
    
    func testRichMessagesDefaultGridGroupSize_0() throws {
        let vm = try UIGrid.load(from: "richMessagesJSONExample")
        XCTAssert(vm.buttons.count == 5, "Invalid count of buttons in rich message")
        XCTAssert(vm.buttonsGroupColumns == 6)
        XCTAssert(vm.buttonsGroupRows == 7)
    }
    
    
    func testRichMessagesDefaultGridGroupSize_1() throws {
        let vm = try UIGrid.load(from: "uiGridInvalidRowsColumnsOfGroup")
        
        XCTAssert(vm.buttonsGroupColumns == 6)
        XCTAssert(vm.buttonsGroupRows == 7)
    }
    
    
    func testRichMessagesDefaultButtonSize() throws {
        let vm = try UIGrid.load(from: "richMessagesJSONExample")
        
        XCTAssert(vm.buttons.count == 5, "Invalid count of buttons in rich message")
        
        do {
            let b = vm.buttons[0]
            
            XCTAssert(b.size.width == 6)
            XCTAssert(b.size.height == 7)
        }
    }
    
    
    func testRichMessagesFavoritesMetadata() throws {
        let vm = try UIGrid.load(from: "richMessagesJSONExample")
        
        XCTAssert(vm.favoritesMetadata != nil)
        XCTAssert(vm.favoritesMetadata?.minApiVersion == 4)
    }
    
    
    func testRichMessage18870() throws {
        let vm = try UIGrid.load(from: "richMessage18870")
        
        XCTAssert(vm.buttons.count == 6, "Invalid count of buttons in botKeyboard")
        do {
            let b = vm.buttons[0]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 3, "Incorrect button height")
            
        }
        do {
            let b = vm.buttons[1]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
        }
        do {
            let b = vm.buttons[2]
            XCTAssert(b.size.width == 3, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            
        }
        do {
            let b = vm.buttons[3]
            XCTAssert(b.size.width == 3, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            
        }
        do {
            let b = vm.buttons[4]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
            
        }
        do {
            let b = vm.buttons[5]
            XCTAssert(b.size.width == 6, "Incorrect button width")
            XCTAssert(b.size.height == 1, "Incorrect button height")
        }
    }
    
    
    func testMediaPlayer() throws {
        let vm = try UIGrid.load(from: "botKeyboardMediaPlayer")
        
        XCTAssertNotNil(vm.buttons[2].mediaPlayer)
        XCTAssert(vm.buttons[2].mediaPlayer?.isLoop == true)
        
        XCTAssertNotNil(vm.buttons[3].mediaPlayer)
        XCTAssertFalse(vm.buttons[3].mediaPlayer?.isLoop == true) //default value test
    }
    
    func testBorderOptionsEmpty() throws {
        let vm = try UIGrid.load(from: "botKeyboardAPI_v6")
        XCTAssertNil(vm.buttons[0].frame)
    }
    
    
    func testBorderOptions() throws {
        let vm = try UIGrid.load(from: "botKeyboardAPI_v6")
        XCTAssertNotNil(vm.buttons[1].frame)
        XCTAssert(vm.buttons[1].frame?.borderWidth == 10)
        XCTAssert(vm.buttons[1].frame?.cornerRadius == 10)
        XCTAssert(vm.buttons[1].frame?.borderColor == "invalid")
        XCTAssertNotNil(vm.buttons[2].frame)
        XCTAssert(vm.buttons[2].frame?.borderWidth == 12)
        XCTAssert(vm.buttons[2].frame?.cornerRadius == 12)
        XCTAssert(vm.buttons[2].frame?.borderColor == "#0000FF")
    }
    
    
    func testImageScaleTypeDefault() throws {
        let vm = try UIGrid.load(from: "botKeyboardMediaPlayer")
        XCTAssert(vm.buttons[0].imageScaleType == .crop)
    }
}
