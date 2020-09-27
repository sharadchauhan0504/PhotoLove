//
//  PhotosErrors.swift
//  PhotoLove
//
//  Created by Sharad on 27/09/20.
//

import Foundation

enum PhotosErrors: Error {
    
    case invalidAPIResponse
    case decodingError
    
    var message: String {
        switch self {
        case .invalidAPIResponse: return "The page you’re requesting appears to be stuck in traffic. Refresh to retrieve!"
        case .decodingError: return "Our servers started speaking a language we are yet to learn. Bear with us."
        }
    }
}
