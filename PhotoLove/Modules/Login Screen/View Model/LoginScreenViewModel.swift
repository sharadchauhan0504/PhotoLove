//
//  LoginScreenViewModel.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import Foundation
import RxSwift
import RxCocoa

class LoginScreenViewModel {
    
    let validatedEmail: Driver<Bool>
    let validatedPassword: Driver<Bool>
    let signInEnabled: Driver<Bool>
    let logInEnabled: Driver<Bool>
    let isSignInSuccessful: Driver<Bool>
    let isLogInSuccessful: Driver<Bool>
    
    init(email: Driver<String>,
         password: Driver<String>,
         signInTaps: Signal<()>,
         logInTaps: Signal<()>) {
        
        validatedEmail = email
            .map { email in
                return email.isValidEmail()
            }
        
        validatedPassword = password
            .map { password in
                return password.count > 5
            }
        
        signInEnabled = Driver.combineLatest(validatedEmail, validatedPassword) { isValdEmail, isValidPassword in
            isValdEmail && isValidPassword
        }.distinctUntilChanged()
        
        logInEnabled = Driver.combineLatest(validatedEmail, validatedPassword) { isValdEmail, isValidPassword in
            isValdEmail && isValidPassword
        }.distinctUntilChanged()
        
        let emailAndPassword = Driver.combineLatest(email, password) { (email: $0, password: $1) }
        isSignInSuccessful = signInTaps.withLatestFrom(emailAndPassword)
            .flatMapLatest { pair in
                return FirebaseAuthenticationHandler.createAccount(pair.email, pair.password)
                    .asDriver(onErrorJustReturn: false)
            }
        
        isLogInSuccessful = logInTaps.withLatestFrom(emailAndPassword)
            .flatMapLatest { pair in
                return FirebaseAuthenticationHandler.performAuthentication(pair.email, pair.password)
                    .asDriver(onErrorJustReturn: false)
            }
    }
   
}
