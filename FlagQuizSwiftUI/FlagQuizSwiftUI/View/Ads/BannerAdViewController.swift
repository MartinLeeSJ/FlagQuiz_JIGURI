//
//  BannerViewController.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import UIKit

protocol BannerAdViewControllerWidthDelegate: AnyObject {
    func bannerAdViewController(_ bannerAdViewController: BannerAdViewController, didUpdate width: CGFloat)
}

class BannerAdViewController: UIViewController {
    weak var delegate: BannerAdViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate?.bannerAdViewController(
            self,
            didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width
        )
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // Nothing to do
        } completion: { _ in
            // Notify the delegate of ad width changes
            self.delegate?.bannerAdViewController(
                self,
                didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width
            )
        }
    }
}
