//
//  DashboardFlowUITests.swift
//  PhotoLoveUITests
//
//  Created by Sharad on 29/09/20.
//

import XCTest

class DashboardFlowUITests: XCTestCase {

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

    func testDashboardFlowWithLogin() throws {
        app.launch()
        
        //LoginScreenController
        let loginScreenControllerView = app.otherElements["controller--LoginScreenController"]
        XCTAssertTrue(loginScreenControllerView.exists)
        
        let emailTextField = loginScreenControllerView.textFields["textfield--emailTextField"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("sharad2@test.com")
                
        let passwordTextField = loginScreenControllerView.textFields["textfield--passwordTextField"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("testing")
                
        let signInButton = loginScreenControllerView.buttons["button--signInButton"]
        XCTAssertTrue(signInButton.exists)
        
        let loginButton = loginScreenControllerView.buttons["button--loginButton"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        wait(2.0)
        
        //DashboardBasePageController
        let dashboardBasePageControllerView = app.otherElements["controller--DashboardBasePageController"]
        XCTAssertTrue(dashboardBasePageControllerView.exists)
                
        print(dashboardBasePageControllerView.debugDescription)
        let exploreLabel = dashboardBasePageControllerView.buttons["Explore"]
        XCTAssert(exploreLabel.exists, "exploreLabel with text Explore does not exist")
        
        let favouritesLabel = dashboardBasePageControllerView.buttons["Favourites"]
        XCTAssert(favouritesLabel.exists, "favouritesLabel with text Favourites does not exist")
        
        wait(2.0)
        
        //RandomPhotosController
        let randomPhotosControllerView = dashboardBasePageControllerView.otherElements["controller--RandomPhotosController"]
        XCTAssertTrue(randomPhotosControllerView.exists)
        
        let randomPhotosCollectionView = randomPhotosControllerView.collectionViews["collectionview--randomPhotosCollectionView"]
        XCTAssertTrue(randomPhotosCollectionView.exists)
        randomPhotosCollectionView.cells.element(boundBy: 0).tap()
        
        wait(1.0)
        
        let skipPhotoButton = randomPhotosControllerView.buttons["button--skipPhotoButton"]
        XCTAssertTrue(skipPhotoButton.exists)
        skipPhotoButton.tap()
        
        wait(1.0)
        
        let likePhotoButton = randomPhotosControllerView.buttons["button--likePhotoButton"]
        XCTAssertTrue(likePhotoButton.exists)
        likePhotoButton.tap()
        
        wait(1.0)
        
        favouritesLabel.tap()
        
        wait(2.0)
        
        //FavouritePhotosController
        let favouritePhotosControllerView = dashboardBasePageControllerView.otherElements["controller--FavouritePhotosController"]
        XCTAssertTrue(favouritePhotosControllerView.exists)
        
        let likedPhotosCollectionView = favouritePhotosControllerView.collectionViews["collectionview--likedPhotosCollectionView"]
        XCTAssertTrue(likedPhotosCollectionView.exists)
        likedPhotosCollectionView.cells.element(boundBy: 0).tap()
        
        wait(1.0)
        
        exploreLabel.tap()
        
        wait(2.0)
        
        app.terminate()
    }

}
