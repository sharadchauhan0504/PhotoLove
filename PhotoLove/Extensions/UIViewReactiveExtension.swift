//
//  UIViewReactiveExtension.swift
//  PhotoLove
//
//  Created by Sharad on 28/09/20.
//

import UIKit
import RxSwift

extension Reactive where Base == UIView {
    
    func tranformIdentity(_ duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.transform = .identity
            }, completion: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func shiftXOrigin(_ xOffset: CGFloat, _ duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.transform = CGAffineTransform(translationX: xOffset, y: 0.0)
            }, completion: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

}

extension Reactive where Base == UILabel {
 
    func fadeOut(_ duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 0.0
            }, completion: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func fadeIn(_ duration: TimeInterval) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 1.0
            }, completion: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

}
