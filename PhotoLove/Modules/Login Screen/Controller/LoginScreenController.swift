//
//  LoginScreenController.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth

class LoginScreenController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.roundCorners(corners: [.topLeft, .topRight], radius: 24.0)
            containerView.backgroundColor = .black
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.accessibilityIdentifier = "textfield--emailTextField"
            emailTextField.tintColor               = .warmPink
            emailTextField.textColor               = .white
            emailTextField.attributedPlaceholder   = NSAttributedString(string: "Enter your email", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            emailTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.accessibilityIdentifier = "textfield--passwordTextField"
            passwordTextField.tintColor               = .warmPink
            passwordTextField.textColor               = .white
            passwordTextField.attributedPlaceholder   = NSAttributedString(string: "Enter password", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white
                ])
        }
    }
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.accessibilityIdentifier = "button--signInButton"
            signInButton.backgroundColor         = .warmPink
            signInButton.addCornerRadius(radius: 8.0)
            signInButton.addShadow(radius: 4.0, height: 0.0, opacity: 0.35, shadowColor: .white)
        }
    }
    
    //MARK:- Private variables
    private let disposeBag = DisposeBag()
    
    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Testing
        view.accessibilityIdentifier = "controller--LoginScreenController"
        view.backgroundColor         = .warmPink
        assignValidationDrivers()
    }

    //MARK:- Private methods
    private func assignValidationDrivers() {
       
        let viewModel = LoginScreenViewModel(email: emailTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver(), signInTaps: signInButton.rx.tap.asSignal())
        
        viewModel.validatedEmail.drive(onNext: { [weak self] (isValid) in
            guard let strongSelf = self else {return}
            strongSelf.emailValidationLabel.alpha = isValid ? 0.0 : 1.0
        }).disposed(by: disposeBag)
        
        viewModel.validatedPassword.drive(onNext: { [weak self] (isValid) in
            guard let strongSelf = self else {return}
            strongSelf.passwordValidationLabel.alpha = isValid ? 0.0 : 1.0
        }).disposed(by: disposeBag)
        
        viewModel.signInEnabled.drive(onNext: { [weak self] (isValid) in
            guard let strongSelf = self else {return}
            strongSelf.signInButton.isEnabled = isValid ? true : false
            strongSelf.signInButton.alpha = isValid ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        viewModel.isSignInSuccessful.drive(onNext: { [weak self] (isSuccess) in
            guard let strongSelf = self else {return}
            print("Sign in successfully: \(Auth.auth().currentUser)")
        }).disposed(by: disposeBag)
    }
}
