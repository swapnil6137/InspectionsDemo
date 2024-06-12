//
//  InspectionListUITest.swift
//  InspectionsDemoUITests
//
//  Created by Swapnil Shinde on 13/06/24.
//

import XCTest
@testable import InspectionsDemo

final class InspectionListUITest: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
    }
    
    func testAddInspectionsButton(){
        
        LoginUITest().testLoginButton()
        
        let button = app.navigationBars.buttons["btnAddInspection"]
        
        button.tap()
        
        let inspectionView = app.otherElements["inspectionView"]
        
        XCTAssertTrue(inspectionView.waitForExistence(timeout: 15), "Inspection view did not appear")
        
    }
    
}
