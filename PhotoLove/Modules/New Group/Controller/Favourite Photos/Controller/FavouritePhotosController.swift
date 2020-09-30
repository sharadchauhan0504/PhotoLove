//
//  FavouritePhotosController.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class FavouritePhotosController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var likedPhotosCollectionView: UICollectionView! {
        didSet {
            likedPhotosCollectionView.accessibilityIdentifier = "collectionview--likedPhotosCollectionView"
            likedPhotosCollectionView.registerNib(type: RandomPhotosCollectionCell.self)
        }
    }
    
    //MARK:- Private variables
    private let disposeBag = DisposeBag()
    private var likedPhotos = [[String: String]]()
    
    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI testing
        view.accessibilityIdentifier = "controller--FavouritePhotosController"
        view.backgroundColor         = .black
        
        assignCollectionDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLikedPhotos()
    }
    
    //MARK:- Private methods
    private func getLikedPhotos() {
        let viewModel = FavouritePhotosViewModel()
        
        viewModel.allLikedPhotos
            .drive(onNext: { [weak self] (likedPhotos) in
                guard let strongSelf = self else {return}
                strongSelf.likedPhotos = likedPhotos
                strongSelf.likedPhotosCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func assignCollectionDelegates() {
        likedPhotosCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let strongSelf = self, let cell = strongSelf.likedPhotosCollectionView.cellForItem(at: indexPath) else {return}
                cell.bounceEffect()
            })
            .disposed(by: disposeBag)
        
    }
}

//MARK:- Extensions
extension FavouritePhotosController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomPhotosCollectionCell", for: indexPath) as! RandomPhotosCollectionCell
        cell.likedPhoto = likedPhotos[indexPath.item]
        
        return cell
    }
}

extension FavouritePhotosController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2 - 10, height: 240)
    }
}

