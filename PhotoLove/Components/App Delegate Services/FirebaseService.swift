//
//  FirebaseService.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import Foundation
import Firebase

final class FirebaseService: NSObject, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        guard let path = filePath, let options = FirebaseOptions(contentsOfFile: path) else { return true }
        
        //For unit tests
        if NSClassFromString("XCTest") != nil {
            return true
        } else {
            FirebaseApp.configure(options: options)
        }

        return true
    }
    
}
