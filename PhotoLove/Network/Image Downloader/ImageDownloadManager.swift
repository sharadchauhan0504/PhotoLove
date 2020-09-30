//
//  ImageDownloadManager.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation
import Alamofire
import RxSwift

final class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    private var imageCache = [String: UIImage]()
    
    private init() {}
        
    func downloadImageFrom(_ url: URL) -> Observable<UIImage> {
      
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let strongSelf = self else {return Disposables.create()}
            if let cachedImage = strongSelf.imageCache[url.absoluteString] {
                observer.onNext(cachedImage)
                observer.onCompleted()
            } else {
                AF.request(url).responseData { (responseData) in
                    switch responseData.result {
                    case .success(let imageData):
                        if let downloadeImage = UIImage(data: imageData) {
                            strongSelf.imageCache[url.absoluteString] = downloadeImage
                            observer.onNext(downloadeImage)
                            observer.onCompleted()
                        }
                        observer.onError(PhotosErrors.invalidAPIResponse)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
