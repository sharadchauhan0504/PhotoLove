//
//  FirebaseAuthenticationHandler.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import Foundation
import FirebaseAuth
import RxSwift

class FirebaseAuthenticationHandler {
    
    class func performAuthentication(_ email: String, _ password: String) -> Observable<Bool> {
        return Observable.create { (observer : AnyObserver<Bool>) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    print("User: \(result?.user)")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
}
