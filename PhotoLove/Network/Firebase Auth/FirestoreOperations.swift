//
//  FirestoreOperations.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation
import Firebase
import RxSwift

class FirestoreOperations {
    
    class func addLikedPhotoUrl(_ fullImageUrl: String, _ thumbnailUrl: String) -> Observable<Bool> {
        return Observable.create { (observer : AnyObserver<Bool>) -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid else {return Disposables.create()}
            let userIdDocument = Firestore.firestore().collection("users").document(userId)
            userIdDocument.collection("liked_photos").addDocument(data: [
                "liked_photo_full": fullImageUrl,
                "liked_photo_thumb": thumbnailUrl
            ]) { err in
                if let err = err {
                    print("addLikedPhotoUrl: \(err)")
                    observer.onError(err)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    class func getAllLikedPhotoUrl() -> Observable<[[String: String]]> {
        return Observable.create { (observer : AnyObserver<[[String: String]]>) -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid else {return Disposables.create()}
            let userIdDocument = Firestore.firestore().collection("users").document(userId)
            userIdDocument.collection("liked_photos").getDocuments { (querySnapshot, err) in
                if let error = err {
                    observer.onError(error)
                } else {
                    if let documents = querySnapshot?.documents, let allLikedPhotos = documents.map({ $0.data() }) as? [[String: String]] {
                        observer.onNext(allLikedPhotos)
                        observer.onCompleted()
                    } else {
                        observer.onError(PhotosErrors.invalidAPIResponse)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
}
