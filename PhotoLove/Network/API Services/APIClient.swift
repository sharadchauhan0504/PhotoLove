//
//  APIClient.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation

enum APIClient {
    
    case unsplash
    
    var baseUrlString: String {
        switch self {
        case .unsplash: return "https://api.unsplash.com"
        }
    }
}
