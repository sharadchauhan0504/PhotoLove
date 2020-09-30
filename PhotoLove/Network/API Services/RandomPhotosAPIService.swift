//
//  RandomPhotosAPIService.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation

enum RandomPhotosAPIService: Routable {
    
    case getRandomePhotos(_ page: Int)
    
    var url: URL {
        return URL(string: APIClient.unsplash.baseUrlString + endPoint)!
    }
    
    var method: HTTPMethod {
        return HTTPMethod.GET
    }
    
    var endPoint: String {
        switch self {
        case .getRandomePhotos(let page): return "/photos?page=\(page)&per_page=10"
        }
    }
    
    var headers: [String : String] {
        return [
            "Accept-Version": "v1",
            "Authorization" : "Client-ID \(UnsplashConstants.accessKey)",
            "Content-Type": "application/json"
        ]
    }
    
    var body: Data? {
        return nil
    }
    
    var request: URLRequest {
        var request                 = URLRequest(url: self.url)
        request.httpMethod          = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody            = self.body
        request.cachePolicy         = .reloadRevalidatingCacheData
        return request
    }
    
}

