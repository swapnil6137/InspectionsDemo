//
//  LoginTest.swift
//  InspectionsDemoTests
//
//  Created by Swapnil Shinde on 12/06/24.
//

import XCTest
@testable import InspectionsDemo

final class LoginTest: XCTestCase {

    var viewModel: LoginViewModel!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = true
        viewModel = LoginViewModel()
        
    }
    
    func testLoginSuccess() {
    
        let expectation = expectation(description: "Loggin In")
        
        viewModel.email = "abc1@abc.com"
        viewModel.password = "test123456"

        viewModel.doLogin { (result: Result<LoginDetails, APIServiceError>) in
            switch result {
            case .success(_):
                
                expectation.fulfill()
                
            case .failure(let error):
                
                if case .successWithEmptyData = error  {
                    
                    expectation.fulfill()
                    
                }
                
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(self.viewModel.isSuccess)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testSignUpSuccess() {
    
        let expectation = expectation(description: "Register user")
        
        viewModel.email = "abc1@abc.com"
        viewModel.password = "test123456"

        viewModel.doSignUp { (result: Result<LoginDetails, APIServiceError>) in
            switch result {
            case .success(_):
                
                expectation.fulfill()
                
            case .failure(let error):
                
                if case .successWithEmptyData = error  {
                    
                    expectation.fulfill()
                    
                }
                
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(self.viewModel.isSuccess)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
