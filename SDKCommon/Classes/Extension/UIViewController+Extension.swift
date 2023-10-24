//
//  UIViewController+Extension.swift
//  abseil
//
//  Created by Felipe Augusto Silva on 14/09/23.
//

import UIKit

extension UIViewController {
    public func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        
        // Check if the tap location is inside any of the text fields or buttons
        let tappedView = view.hitTest(tapLocation, with: nil)
        if !(tappedView is UITextField) && !(tappedView is UIButton) {
            view.endEditing(true)
        }
    }
    
    public func dismissOrPop(animated: Bool = true) {
        if let presentingVC = presentingViewController {
            presentingVC.dismiss(animated: animated, completion: nil)
        } else if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            // If neither presenting nor in a navigation stack, just dismiss self
            dismiss(animated: animated, completion: nil)
        }
    }
}

extension UIApplication {
    public static func setRootViewControllerWithNavigation(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            }, completion: nil)
        }
    }
}

