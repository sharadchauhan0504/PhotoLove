//
//  FavouritePhotosViewModel.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation
import RxCocoa

class FavouritePhotosViewModel {
    
    let allLikedPhotos: Driver<[[String: String]]>
    
    init() {
        allLikedPhotos = FirestoreOperations.getAllLikedPhotoUrl()
            .asDriver(onErrorJustReturn: [[String: String]]())
    }
}
