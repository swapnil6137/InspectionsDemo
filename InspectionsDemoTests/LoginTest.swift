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
        
        continueAfterFailure = false
        viewModel = LoginViewModel()
        viewModel.userName = "abc1@abc.com"
        viewModel.password = "test12345"
        
        
    }
    
    func testLoginSuccess() {
    
        let expectation = expectation(description: "Loggin In")

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
