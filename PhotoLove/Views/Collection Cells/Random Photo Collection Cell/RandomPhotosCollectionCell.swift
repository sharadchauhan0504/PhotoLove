//
//  RandomPhotosCollectionCell.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import UIKit
import RxSwift

class RandomPhotosCollectionCell: UICollectionViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var backgroundShadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var randomPhotoImageView: UIImageView!
    
    //MARK:- Public variables
    var randomPhotoElement: RandomPhotosAPIOutputElement? = nil {
        didSet {
            setRandomPhotosData()
        }
    }
    
    var likedPhoto: [String: String]? = nil {
        didSet {
            setLikePhotos()
        }
    }
    
    //MARK:- Private variables
    private var disposeBag = DisposeBag()
    
    //MARK:- Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        randomPhotoImageView.image = nil
        disposeBag                 = DisposeBag()
    }

    //MARK:- Private methods
    private func setRandomPhotosData() {
        guard let data = randomPhotoElement else {return}
        backgroundShadowView.addShadow(radius: 8.0, height: 0.0, opacity: 0.40, shadowColor: .white)
        containerView.addCornerRadius(radius: 16.0)
        
        let thumbUrlString = data.urls.thumb
        if let url = URL(string: thumbUrlString) {
            downloadImage(url)
        }
        
        let fullUrlString = data.urls.regular
        if let url = URL(string: fullUrlString) {
            downloadImage(url)
        }
    }
    
    private func setLikePhotos() {
        guard let data = likedPhoto else {return}
        backgroundShadowView.addShadow(radius: 4.0, height: 0.0, opacity: 0.40, shadowColor: .white)
        containerView.addCornerRadius(radius: 8.0)
       
        if let thumbUrlString = data["liked_photo_thumb"], let url = URL(string: thumbUrlString) {
            downloadImage(url)
        }
        
        if let fullUrlString = data["liked_photo_full"], let url = URL(string: fullUrlString) {
            downloadImage(url)
        }
    }
    
    private func downloadImage(_ url: URL) {
        
        ImageDownloadManager.shared.downloadImageFrom(url)
            .asDriver(onErrorJustReturn: UIImage())
            .drive( onNext: { [weak self] (image) in
                guard let strongSelf = self else {return}
                strongSelf.randomPhotoImageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
}
