//
//  UIGridInternalBrowserTests.swift
//  
//
//  Created by Pavel Trafimuk on 17/07/2023.
//

import XCTest
@testable import ViberUIGridView

final class UIGridInternalBrowserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCase1() throws {
        let checkModel = UIGridInternalBrowser(actionButton: .forward,
                                               actionPredefinedURL: "www.viber.com",
                                               titleType: .default,
                                               customTitle: "Custom",
                                               mode: .fullscreen,
                                               footerType: .hidden,
                                               actionReplyData: "data!")
        
        let string = """
        {
        "ActionButton": "forward",
        "ActionPredefinedURL": "www.viber.com",
        "TitleType" : "default",
        "CustomTitle": "Custom",
        "Mode": "fullscreen",
        "FooterType": "hidden",
        "ActionReplyData": "data!"
        }
"""
        guard let data = string.data(using: .utf8) else {
            XCTFail()
            return
        }
        let model = try JSONDecoder().decode(UIGridInternalBrowser.self, from: data)
        XCTAssert(model == checkModel)
    }
    
    func testCase2() throws {
        let checkModel = UIGridInternalBrowser(actionButton: UIGridInternalBrowser.ActionButton.none,
                                               actionPredefinedURL: "www.viber.com",
                                               titleType: .default,
                                               customTitle: "Custom",
                                               mode: .fullscreen,
                                               footerType: .hidden,
                                               actionReplyData: "data!")
        
        let string = """
        {
        "ActionButton": "blablabla",
        "ActionPredefinedURL": "www.viber.com",
        "TitleType" : "default",
        "CustomTitle": "Custom",
        "Mode": "fullscreen",
        "FooterType": "hidden",
        "ActionReplyData": "data!"
        }
"""
        guard let data = string.data(using: .utf8) else {
            XCTFail()
            return
        }
        let model = try JSONDecoder().decode(UIGridInternalBrowser.self, from: data)
        XCTAssert(model == checkModel)
    }
    
    func testCase3() throws {
        let checkModel = UIGridInternalBrowser(actionButton: nil,
                                               actionPredefinedURL: "www.viber.com",
                                               titleType: .default,
                                               customTitle: "Custom",
                                               mode: .fullscreen,
                                               footerType: .hidden,
                                               actionReplyData: "data!")
        
        let string = """
        {
        "ActionPredefinedURL": "www.viber.com",
        "TitleType" : "default",
        "CustomTitle": "Custom",
        "Mode": "fullscreen",
        "FooterType": "hidden",
        "ActionReplyData": "data!"
        }
"""
        guard let data = string.data(using: .utf8) else {
            XCTFail()
            return
        }
        let model = try JSONDecoder().decode(UIGridInternalBrowser.self, from: data)
        XCTAssert(model == checkModel)
    }
    
    func testCase4() throws {
        let checkModel = UIGridInternalBrowser(actionButton: UIGridInternalBrowser.ActionButton.none,
                                               actionPredefinedURL: "www.viber.com",
                                               titleType: .default,
                                               customTitle: "Custom",
                                               mode: .fullscreen,
                                               footerType: .hidden,
                                               actionReplyData: "data!")
        
        let string = """
        {
        "ActionButton": "blablabla",
        "ActionPredefinedURL": "www.viber.com",
        "TitleType" : "default",
        "CustomTitle": "Custom",
        "Mode": "un",
        "FooterType": "hidden",
        "ActionReplyData": "data!"
        }
"""
        guard let data = string.data(using: .utf8) else {
            XCTFail()
            return
        }
        let model = try JSONDecoder().decode(UIGridInternalBrowser.self, from: data)
        XCTAssert(model == checkModel)
    }
    
    func testCase5() throws {
        let checkModel = UIGridInternalBrowser(actionButton: UIGridInternalBrowser.ActionButton.none,
                                               actionPredefinedURL: "www.viber.com",
                                               titleType: .default,
                                               customTitle: "Custom",
                                               mode: .fullscreen,
                                               footerType: .hidden,
                                               actionReplyData: "data!")
        
        let string = """
        {
        "ActionButton": "blablabla",
        "ActionPredefinedURL": "www.viber.com",
        "TitleType" : "default",
        "CustomTitle": "Custom",
        "FooterType": "hidden",
        "ActionReplyData": "data!"
        }
"""
        guard let data = string.data(using: .utf8) else {
            XCTFail()
            return
        }
        let model = try JSONDecoder().decode(UIGridInternalBrowser.self, from: data)
        XCTAssert(model == checkModel)
    }
}
