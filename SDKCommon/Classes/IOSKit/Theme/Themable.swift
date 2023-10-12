//
//  Themable.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 12/10/23.
//

import Foundation

public enum PanTheme {
    case primary
    case black
    case negative
    case green
    case white
    case secondary
}

public protocol Themeable {
    var theme: PanTheme { get set }
    func setTheme(_ isPressed: Bool)
}

//public extension Themeable where Self: PanIconButton {
//    public func setTheme(_ isPressed: Bool = false) {
//        guard self.isEnabled else {
//            self.tintColor = DSColor.light
//            return
//        }
//        
//        var backgroundColor: UIColor?
//            switch theme {
//            case .primary:
//                backgroundColor = isPressed ? DSColor.primaryDark : (isBackgroundClear ? .clear : DSColor.primary)
//            case .black, .secondary:
//                backgroundColor = isPressed ? DSColor.secondaryDark : (isBackgroundClear ? .clear : DSColor.secondary)
//            case .negative:
//                backgroundColor = isPressed ?  DSColor.negativeDark :  (isBackgroundClear ? .clear : DSColor.negative)
//            case .green:
//                backgroundColor = isPressed ? DSColor.positiveDark : (isBackgroundClear ? .clear : DSColor.positive)
//            case .white:
//                backgroundColor = isPressed ? DSColor.lightest : (isBackgroundClear ? .clear : DSColor.white)
//            }
//        
//        self.backgroundColor = backgroundColor
//    }
//}
