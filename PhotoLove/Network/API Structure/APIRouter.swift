//
//  APIRouter.swift
//  PhotoLove
//
//  Created by Sharad on 27/09/20.
//

import Foundation
import Alamofire

enum RequestType {
    case live
    case mock

}

struct APIRouter<T: Codable> {
    
    // MARK: - Local Variables
    private let mockSession: URLSessionProtocol!
    private let session: Session!
    private let requestType: RequestType!
    
    // MARK: - Init
    init(requestType: RequestType = .live) {
        self.session     = Session.default
        self.mockSession = URLSession(configuration: .default)
        self.requestType = requestType
    }
    
    // MARK: API Request
    func requestData(router: Routable,
                     completion : @escaping (_ model : T?, _ statusCode: Int? , _ error : Error?) -> Void ) {
        
        switch requestType {
        case .live:
            session.request(router.request).response(queue: .global(qos: .background)) { (response) in
                curateResponseForUI(response.data, response.response?.statusCode, response.error, completion: completion)
            }
        case .mock:
            let task = self.mockSession.dataTask(with: router.request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    curateResponseForUI(data, httpResponse.statusCode, error, completion: completion)
                } else {
                    curateResponseForUI(data, nil, error, completion: completion)
                }
            }
            task.resume()
        case .none: break
        }
        
    }

    private func curateResponseForUI(_ data: Data?, _ statusCode: Int?, _ error: Error?, completion : @escaping (_ model : T?, _ statusCode: Int? , _ error : Error?) -> Void) {
        guard error == nil, let code = statusCode, (200..<300) ~= code else {
            completion(nil, statusCode, PhotosErrors.invalidAPIResponse)
            return
        }
        
        guard let properData = data else {
            completion(nil, statusCode, PhotosErrors.invalidAPIResponse)
            return
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: properData)
            completion(model, statusCode,  nil)
        } catch {
            print("decodingError: \(error)")
            completion(nil, statusCode, PhotosErrors.decodingError)
        }
    }
    
}
