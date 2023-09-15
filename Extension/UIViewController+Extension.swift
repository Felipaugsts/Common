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
}
