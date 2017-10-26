//
//  KeyboardSizableContainerViewController.swift
//  Moments
//
//  Created by David Elsonbaty on 10/23/17.
//  Copyright © 2017 Elsonbaty. All rights reserved.
//

import UIKit
import SnapKit

class KeyboardSizableContainerViewController: UIViewController {
    typealias ChildViewController = UIViewController
    
    let childViewController: ChildViewController
    init(childViewController: ChildViewController) {
        self.childViewController = childViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for keyboard notifications
        registerForNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Add child view controller
        addChildViewController()
    }
    
    func addChildViewController() {
        guard childViewController.parent == nil else { return }
        
        addChildViewControllerWithView(childViewController) { [weak self] maker in
            guard let strongSelf = self else { return }
            maker.top.leading.trailing.equalTo(strongSelf.view)
            maker.bottom.equalTo(strongSelf.bottomLayoutGuide.snp.top)
        }
    }
}


extension KeyboardSizableContainerViewController {

    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillOpen(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillClose(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillOpen(notification: NSNotification) {
        handleKeyboard(open: true, with: notification)
    }

    @objc func keyboardWillClose(notification: NSNotification) {
        handleKeyboard(open: false, with: notification)
    }

    func handleKeyboard(open: Bool, with notification: NSNotification) {
        guard let userInfo = notification.userInfo, let keyboardSize: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.size else { return assertionFailure() }

        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt ?? 0

        let bottomOffset = (open ? -keyboardSize.height : 0)
        childViewController.view.snp.updateConstraints { [unowned self] maker in
            maker.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(bottomOffset)
        }

        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
