//
//  UIView+Extension.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 13/10/23.
//

import Foundation


extension UIView {

    public func addTapGesture(target: Any?, action: Selector?) {
           let tapGesture = UITapGestureRecognizer(target: target, action: action)
           isUserInteractionEnabled = true
           addGestureRecognizer(tapGesture)
       }
}
