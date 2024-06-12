//
//  LoginUITest.swift
//  InspectionsDemoUITests
//
//  Created by Swapnil Shinde on 12/06/24.
//

import XCTest
@testable import InspectionsDemo

final class LoginUITest: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = true
        XCUIApplication().launch()
    }
    
    func testUserNameTextField() {
       
        let textField = app.textFields["textUserName"]
        
        let existsPredicate = NSPredicate(format: "exists == true && isHittable == true")
        expectation(for: existsPredicate, evaluatedWith: textField, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        textField.tap()

        if let existingText = textField.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: existingText.count)
            textField.typeText(deleteString)
        }

        let userName = "abc@abc.com"
        textField.typeText(userName)
        
        XCTAssertEqual(textField.value as? String, userName, "The text field's value is not as expected.")
        
    }
    
    func testSetPasswordAndVerify() {
        
        let passwordField = app.secureTextFields["txtPassword"]
        
        let existsPredicate = NSPredicate(format: "exists == true && isHittable == true")
        expectation(for: existsPredicate, evaluatedWith: passwordField, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
        
        while !passwordField.isHittable {
            app.scrollViews.element.swipeUp()
        }
        
        passwordField.tap()
        
        if let existingText = passwordField.value as? String, !existingText.isEmpty {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: existingText.count)
            passwordField.typeText(deleteString)
        }
        
        
        let newPassword = "test12345"
        passwordField.typeText(newPassword)
        
    }
    
    func testLoginButton() {
        
        let app = XCUIApplication()
        app.launch()
        
        self.testUserNameTextField()
        self.testSetPasswordAndVerify()
        
        let button = app.buttons["btnLoginRegister"]
        
        let existsPredicate = NSPredicate(format: "exists == true && isHittable == true")
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
        
        button.tap()
        
        XCTAssertTrue(app.otherElements["inspectionListView"].exists)
        
    }
    
    func testLoginButtonWithoutUserName() {
        
        let app = XCUIApplication()
        app.launch()
        
        let button = app.buttons["btnLoginRegister"]
        
        let existsPredicate = NSPredicate(format: "exists == true && isHittable == true")
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        
        
        waitForExpectations(timeout: 5, handler: nil)
        
        button.tap()
        
        let alert = app.alerts.firstMatch
            XCTAssertTrue(alert.waitForExistence(timeout: 5), "Alert controller did not appear")

            XCTAssertEqual(alert.staticTexts["Inspections Demo"].label, "Inspections Demo", "Incorrect alert title")
            XCTAssertEqual(alert.staticTexts["Please enter valid email"].label, "Please enter valid email", "Incorrect alert message")
            XCTAssertEqual(alert.buttons["OK"].label, "OK", "OK button not found")
        
            alert.buttons["OK"].tap()
       
        
    }
    
    

    override func tearDownWithError() throws {
        
    }

}

class AllLoginUITests: XCTestCase {
    
    static var allTests = [
        ("testFeatureA", LoginUITest().testLoginButtonWithoutUserName(),
         "testFeatureB", LoginUITest().testLoginButton()
        )
    ]
}
