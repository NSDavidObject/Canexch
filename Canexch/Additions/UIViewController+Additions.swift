//
//  UIViewController+Additions.swift
//  Canexch
//
//  Created by David Elsonbaty on 10/25/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import UIKit
import SnapKit

public extension UIViewController {
    
    func addChildViewControllerWithView(_ childViewController: UIViewController, toBack: Bool = false, toView view: UIView? = nil, _ constraintsMaker: ((_ make: ConstraintMaker) -> Void)? = nil) {
        let view: UIView = view ?? self.view
        
        childViewController.removeFromParentIfNeeded()
        childViewController.willMove(toParentViewController: self)
        addChildViewController(childViewController)
        childViewController.didMove(toParentViewController: self)
        view.addSubview(childViewController.view)
        
        if let constraintsMaker = constraintsMaker {
            childViewController.view.snp.remakeConstraints(constraintsMaker)
            childViewController.view.setNeedsLayout()
            childViewController.view.layoutIfNeeded()
        }
    }
    
    func removeFromParentIfNeeded() {
        view.removeFromSuperview()
        if let parentViewController = parent {
            parentViewController.removeChildViewControllerWithView(self)
        }
    }
    
    func removeChildViewControllerWithView(_ childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
}
