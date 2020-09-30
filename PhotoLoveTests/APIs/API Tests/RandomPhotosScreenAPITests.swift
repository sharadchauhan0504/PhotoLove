//
//  RandomPhotosScreenAPITests.swift
//  PhotoLoveTests
//
//  Created by Sharad on 29/09/20.
//

import XCTest
@testable import PhotoLove

class RandomPhotosScreenAPITests: XCTestCase {

    var session: MockURLSession!
    
    override func setUpWithError() throws {
        session = MockURLSession()
    }

    override func tearDownWithError() throws {
        session = nil
    }

    /// Unit test case for getting random photos
    ///
    /// - Parameter param: page number
    /// - Returns: Returns random photos array
    /// - Throws:
    func testGETRandomPhotosAPI() {
        let asyncExpectation     = expectation(description: "Async block executed")
        session.testDataJSONFile = "RandomPhotosScreenAPITests"
        let api                  = RandomPhotosAPIService.getRandomePhotos(1)
        let router               = APIRouter<RandomPhotosAPIOutput>()
        router.requestMockData(api) { [weak self] (output, statusCode, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(output)
            XCTAssert(statusCode == 200, "HTTP Error code")
            XCTAssert(self?.session.testMethod == "GET", "Method should be GET")
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
