//
//  InspectionTests.swift
//  InspectionsDemoTests
//
//  Created by Swapnil Shinde on 12/06/24.
//

import XCTest
@testable import InspectionsDemo

final class InspectionTests: XCTestCase {
    
    var viewModel: InspectionViewModel!

    override func setUpWithError() throws {
        continueAfterFailure = false
        self.viewModel = InspectionViewModel()
    }
    
    
    /// Test starting new inspection
    func testStartNewInspection() {
    
        let expectation = expectation(description: "Get inspection data")
        
        viewModel.startNewInspection()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertNotNil(self.viewModel.inspectionInfo)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /// Test saving inspection to draft
    func testSaveInspection() {
        
        self.viewModel =  InspectionViewModel.init(inpectionInfo: readJSONFile(fileName: "Inspections"))
        
        let expectation = expectation(description: "Save inspection data")
        
        self.viewModel.insertNewInspectionData()
        
        self.viewModel.saveInspectionToDraft()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(self.viewModel.inspectionInfo?.inspection?.status == INSPECTION_STATUS.DRAFT.rawValue)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /// Test submitting inspection to server 
    func testSubmitInspection() {
        
        self.viewModel =  InspectionViewModel.init(inpectionInfo: readJSONFile(fileName: "Inspections"))
        
        let expectation = expectation(description: "Save inspection data")
        
        self.viewModel.insertNewInspectionData()
        
        self.viewModel.submitInspectionToServer()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(self.viewModel.inspectionInfo?.inspection?.status == INSPECTION_STATUS.COMPLETED.rawValue)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
    }



}



