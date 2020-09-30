//
//  RandomPhotosController.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import UIKit
import RxCocoa
import RxSwift

class RandomPhotosController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var randomPhotosCollectionView: UICollectionView! {
        didSet {
            randomPhotosCollectionView.accessibilityIdentifier = "collectionview--randomPhotosCollectionView"
            randomPhotosCollectionView.registerNib(type: RandomPhotosCollectionCell.self)
        }
    }
    @IBOutlet weak var skipPhotoButton: UIButton! {
        didSet {
            skipPhotoButton.accessibilityIdentifier = "button--skipPhotoButton"
            skipPhotoButton.backgroundColor         = .warmPink
            skipPhotoButton.addCornerRadius(radius: skipPhotoButton.bounds.height * 0.5)
            skipPhotoButton.addShadow(radius: 4.0, height: 0.0, opacity: 0.40, shadowColor: .white)
        }
    }
    @IBOutlet weak var likePhotoButton: UIButton! {
        didSet {
            likePhotoButton.accessibilityIdentifier = "button--likePhotoButton"
            likePhotoButton.backgroundColor         = .warmPink
            likePhotoButton.addCornerRadius(radius: likePhotoButton.bounds.height * 0.5)
            likePhotoButton.addShadow(radius: 4.0, height: 0.0, opacity: 0.40, shadowColor: .white)
        }
    }
    
    //MARK:- Private variables
    private let disposeBag   = DisposeBag()
    private var randomPhotos = [RandomPhotosAPIOutputElement]()
    private var currentPage  = 1

    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI testing
        view.accessibilityIdentifier = "controller--RandomPhotosController"
        view.backgroundColor         = .black
        
        getRandomPhotos()
        assignCollectionDelegates()
        assignButtonTaps()
    }

    //MARK:- Private methods
    private func getRandomPhotos() {
        let viewModel = RandomPhotosViewModel(currentPage)
        
        viewModel.randomPhotos
            .drive(onNext: { [weak self] (randomPhotos) in
                guard let strongSelf = self else {return}
                strongSelf.currentPage += 1
                strongSelf.randomPhotos += randomPhotos
                strongSelf.randomPhotosCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func assignCollectionDelegates() {
        randomPhotosCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let strongSelf = self, let cell = strongSelf.randomPhotosCollectionView.cellForItem(at: indexPath) else {return}
                cell.bounceEffect()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func assignButtonTaps() {
        skipPhotoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.scrollToNextPhoto()
                strongSelf.skipPhotoButton.bounceEffect()
            })
            .disposed(by: disposeBag)
        
        likePhotoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.scrollToNextPhoto()
                strongSelf.likePhotoButton.bounceEffect()
                guard let visibleIndexPath = strongSelf.randomPhotosCollectionView.indexPathsForVisibleItems.first else {return}
                FirestoreOperations.addLikedPhotoUrl(strongSelf.randomPhotos[visibleIndexPath.item].urls.regular, strongSelf.randomPhotos[visibleIndexPath.item].urls.thumb)
                    .subscribe()
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    private func scrollToNextPhoto() {
        guard let visibleIndexPath = randomPhotosCollectionView.indexPathsForVisibleItems.first, (visibleIndexPath.item + 1) < randomPhotos.count - 1 else {return}
        let indexPath = IndexPath(item: visibleIndexPath.item + 1, section: 0)
        randomPhotosCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
    private func fadeInOutCell(_ cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.25) {
            cell.alpha = 0.0
        } completion: { (isSuccess) in
            UIView.animate(withDuration: 0.25) {
                cell.alpha = 1.0
            }
        }
    }
    
    
}
//MARK:- Extensions
extension RandomPhotosController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomPhotosCollectionCell", for: indexPath) as! RandomPhotosCollectionCell
        cell.randomPhotoElement = randomPhotos[indexPath.item]
        
        if indexPath.item == randomPhotos.count - 2 {
            getRandomPhotos()
        }
        
        return cell
    }
}

extension RandomPhotosController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
