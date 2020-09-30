//
//  APIRouter.swift
//  PhotoLove
//
//  Created by Sharad on 27/09/20.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct APIRouter<T: Codable> {
    
    // MARK: - Local Variables
    private let mockSession: URLSessionProtocol!
    private let session: Session!
    
    // MARK: - Init
    init() {
        self.session     = Session.default
        self.mockSession = URLSession(configuration: .default)
    }
    
    //MARK:- Alamofire
    func requestData(_ router: Routable) -> Observable<T> {
        
        return Observable<T>.create { (observer) -> Disposable in
            
            let request = AF.request(router.request).responseData { (responseData) in
                switch responseData.result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                        observer.onCompleted()
                    } catch {
                        observer.onError(PhotosErrors.decodingError)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    
    // MARK: Mock API Request
    func requestMockData(_ router: Routable,
                     completion : @escaping (_ model : T?, _ statusCode: Int? , _ error : Error?) -> Void ) {
        
        let task = self.mockSession.dataTask(with: router.request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                curateResponseForUI(data, httpResponse.statusCode, error, completion: completion)
            } else {
                curateResponseForUI(data, nil, error, completion: completion)
            }
        }
        task.resume()
        
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
