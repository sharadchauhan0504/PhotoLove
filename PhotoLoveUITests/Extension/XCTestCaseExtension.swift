//
//  XCTestCaseExtension.swift
//  PhotoLoveUITests
//
//  Created by Sharad on 28/09/20.
//

import XCTest

extension XCTestCase {

    //Add waiting for asynchronous calls
    func wait(_ duration: TimeInterval) {
        let waitExpectation = expectation(description: "waiting")
        let when            = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
