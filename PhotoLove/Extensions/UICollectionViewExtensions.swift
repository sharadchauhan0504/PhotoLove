//
//  UICollectionViewExtensions.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import UIKit

extension UICollectionView {
    
    func registerNib(type: UICollectionViewCell.Type) {
        let identifier = String(describing: type.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
