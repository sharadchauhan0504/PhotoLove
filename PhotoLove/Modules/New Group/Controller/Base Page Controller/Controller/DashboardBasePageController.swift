//
//  DashboardBasePageController.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardBasePageController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var pageControllerContainerView: UIView!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.roundCorners(corners: [.topLeft, .topRight], radius: 24.0)
            containerView.backgroundColor = .black
        }
    }
    @IBOutlet weak var tabContainerView: UIView! {
        didSet {
            tabContainerView.backgroundColor = .white
            tabContainerView.addCornerRadius(radius: 12.0)
        }
    }
    @IBOutlet weak var tabBackgroundAnimateableView: UIView! {
        didSet {
            tabBackgroundAnimateableView.backgroundColor = .warmPink
            tabBackgroundAnimateableView.addCornerRadius(radius: 8.0)
        }
    }
    @IBOutlet weak var exploreLabel: UILabel! {
        didSet {
            exploreLabel.textColor                = .white
            exploreLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var favouritesLabel: UILabel! {
        didSet {
            favouritesLabel.textColor                = .warmPink
            favouritesLabel.isUserInteractionEnabled = true
        }
    }
    
    //MARK:- Private variables
    private let disposeBag             = DisposeBag()
    private var basePageController: UIPageViewController!
    private var currentControllerIndex = 0
    private let viewModel              = DashboardBasePageViewModel()
    
    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI testing
        view.accessibilityIdentifier = "controller--DashboardBasePageController"
        view.backgroundColor         = .warmPink
        
        assignTapGestures()
        initializePageControllers()
    }

    //MARK:- Private methods
    private func assignTapGestures() {
                
        let tapExploreLabelGesture = UITapGestureRecognizer()
        tapExploreLabelGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.setExploreTabSelected()
                    .subscribe()
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
        exploreLabel.addGestureRecognizer(tapExploreLabelGesture)
        
        let tapFavouritesLabelGesture = UITapGestureRecognizer()
        tapFavouritesLabelGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {return}
                strongSelf.setFavouritTabSelected()
                    .subscribe()
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
        favouritesLabel.addGestureRecognizer(tapFavouritesLabelGesture)
       
    }
    
    private func setExploreTabSelected() -> Observable<Void> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let strongSelf = self else {return Disposables.create()}
            strongSelf.setPageController(index: 0)
            strongSelf.exploreLabel.font         = UIFont(name: "Avenir-Heavy", size: 16.0)
            strongSelf.favouritesLabel.font      = UIFont(name: "Avenir-Light", size: 16.0)
            strongSelf.favouritesLabel.textColor = .warmPink
            strongSelf.exploreLabel.textColor    = .white
            strongSelf.tabBackgroundAnimateableView.rx.tranformIdentity(0.5)
            .subscribe()
            .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    private func setFavouritTabSelected() -> Observable<Void> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let strongSelf = self else {return Disposables.create()}
            strongSelf.setPageController(index: 1)
            let minX                          = strongSelf.favouritesLabel.frame.minX
            strongSelf.favouritesLabel.font      = UIFont(name: "Avenir-Heavy", size: 16.0)
            strongSelf.exploreLabel.font         = UIFont(name: "Avenir-Light", size: 16.0)
            strongSelf.exploreLabel.textColor    = .warmPink
            strongSelf.favouritesLabel.textColor = .white
            strongSelf.tabBackgroundAnimateableView.rx.shiftXOrigin(minX, 0.5)
            .subscribe()
            .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    private func initializePageControllers() {
        basePageController            = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        basePageController.view.frame = pageControllerContainerView.bounds
        pageControllerContainerView.addSubview(basePageController.view)

        basePageController.dataSource = self
        basePageController.delegate   = self

        
        if let firstViewController = viewModel.orderedViewControllers.first as? RandomPhotosController {
            basePageController.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        
    }
    
    private func setPageController(index: Int) {
        basePageController.setViewControllers([viewModel.orderedViewControllers[index]],
                                              direction: index > currentControllerIndex ? .forward : .reverse,
                                              animated: true,
                                              completion: nil)
        currentControllerIndex = index
        
    }
    
}

//MARK:- Extension
extension DashboardBasePageController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first, let viewControllerIndex = viewModel.orderedViewControllers.firstIndex(of: viewController) else {
            return
        }
        currentControllerIndex = viewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if currentControllerIndex == 0 {
                setExploreTabSelected()
                    .subscribe()
                    .disposed(by: disposeBag)
            } else {
                setFavouritTabSelected()
                    .subscribe()
                    .disposed(by: disposeBag)
            }
        } else {
            guard let viewController = previousViewControllers.first, let viewControllerIndex = viewModel.orderedViewControllers.firstIndex(of: viewController) else {
                return
            }
            currentControllerIndex = viewControllerIndex
        }
    }
}

extension DashboardBasePageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewModel.orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard viewModel.orderedViewControllers.count > previousIndex else {
            return nil
        }
        return viewModel.orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewModel.orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex                   = viewControllerIndex + 1
        let orderedViewControllersCount = viewModel.orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return viewModel.orderedViewControllers[nextIndex]
    }
}
