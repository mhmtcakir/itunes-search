//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by Mehmet Çakır on 14.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class iTunesSearchTests: XCTestCase {
    var mainVC:MainViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainVC = storyboard.instantiateViewController(withIdentifier: "SearchController") as? MainViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchBarPlaceholder() {
        //XCTAssertNotNil(mainVC?.searchBar.placeholder)
        //XCTAssertEqual("Search", mainVC?.searchBar.placeholder!)
    }
    
    func testSearchTypeMenuItems() {
        XCTAssertNotNil(Constant.Menus.kSearchTypeMenuItems)
        XCTAssertTrue(Constant.Menus.kSearchTypeMenuItems.count == 4)
    }
    
    func testITunesAPIBaseURL() {
        XCTAssertTrue(Constant.URLs.kBaseURL == "https://itunes.apple.com/")
        XCTAssertEqual(Constant.URLs.kResultLimit, 100)
    }
    
    func testLocalizeMessage() {
        XCTAssertNotEqual("GenericSearchErrorMessage".localized(), "GenericSearchErrorMessage")
        XCTAssertEqual("AlertViewDeleteButtonTitle".localized(), "Delete")
        XCTAssertEqual("AlertViewCancelButtonTitle".localized(), "Cancel")
        XCTAssertEqual("AlertViewCloseButtonTitle".localized(), "Close")
    }
    
    func testInitialNavBarRightButton() {
        let _ = mainVC?.view
        XCTAssertNotNil(mainVC?.navBarRightButtonItem.title)
    }
    
    func testSearchResult() {
        XCTAssertNotNil(mainVC?.searchResult)
    }
    
    func testRemoveItemFromList() {
        
        mainVC?.removeItemFromList(atIndex: -1)
        mainVC?.removeItemFromList(atIndex: 10)
        mainVC?.removeItemFromList(atIndex: 100)
        XCTAssertTrue(true);
        
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
