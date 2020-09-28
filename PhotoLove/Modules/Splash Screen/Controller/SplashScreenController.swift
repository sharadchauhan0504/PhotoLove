//
//  SplashScreenController.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import UIKit

class SplashScreenController: UIViewController {

    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Testing
        view.accessibilityIdentifier = "controller--SplashScreenController"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openLoginScreen()
    }
    
    //MARK:- Private methods
    private func openLoginScreen() {
        let controller = LoginScreenController()
        navigationController?.pushViewController(controller, animated: false)
    }

}
