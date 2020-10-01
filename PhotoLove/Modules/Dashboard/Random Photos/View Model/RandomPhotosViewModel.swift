//
//  RandomPhotosViewModel.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import Foundation
import RxSwift
import RxCocoa

class RandomPhotosViewModel {
    
    let randomPhotos: Driver<[RandomPhotosAPIOutputElement]>
    
    init(_ page: Int) {
        let api = RandomPhotosAPIService.getRandomePhotos(page)
        let request = APIRouter<RandomPhotosAPIOutput>().requestData(api)
        randomPhotos = request.asDriver(onErrorJustReturn: [RandomPhotosAPIOutputElement]())
    }
}
