//
//  DashboardBasePageViewModel.swift
//  PhotoLove
//
//  Created by Sharad on 29/09/20.
//

import UIKit

class DashboardBasePageViewModel {
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [
            RandomPhotosController(),
            FavouritePhotosController()
        ]
    }()
    
}
