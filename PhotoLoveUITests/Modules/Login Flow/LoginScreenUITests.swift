//
//  LoginScreenUITests.swift
//  PhotoLoveUITests
//
//  Created by Sharad on 28/09/20.
//

import XCTest

class LoginScreenUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLoginScreen() {
        
        app.launch()
        
        //LoginScreenController
        let loginScreenControllerView = app.otherElements["controller--LoginScreenController"]
        XCTAssertTrue(loginScreenControllerView.exists)
        
        let emailTextField = loginScreenControllerView.textFields["textfield--emailTextField"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("sharad2@test.com")
        
        wait(1.0)
        
        let passwordTextField = loginScreenControllerView.textFields["textfield--passwordTextField"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("testing")
        
        let signInButton = loginScreenControllerView.buttons["button--signInButton"]
        XCTAssertTrue(signInButton.exists)
        signInButton.tap()
        
        wait(2.0)
        app.terminate()
    }

}
