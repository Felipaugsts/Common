//
//  DSColor.swift
//  SportimeApp
//
//  Created by Felipe Augusto Silva on 08/07/23.
//

import Foundation
import UIKit

public struct DSColor {
    
    //MARK: -Brand Colors
    public static let primary = #colorLiteral(red: 0, green: 0.714658916, blue: 1, alpha: 1)
    public static let primaryDark = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    public static let secondary = #colorLiteral(red: 0.2274509804, green: 0.2509803922, blue: 0.2901960784, alpha: 1)
    public static let secondaryDark = #colorLiteral(red: 0.2004994154, green: 0.2237328887, blue: 0.2570925355, alpha: 1)
    public static let black = #colorLiteral(red: 0.05098039216, green: 0.07450980392, blue: 0.09019607843, alpha: 1)
    public static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    //MARK: -Neutral colors
    public static let darkest = #colorLiteral(red: 0.3214232326, green: 0.3478671312, blue: 0.3985897303, alpha: 1)
    public static let dark = #colorLiteral(red: 0.5215686275, green: 0.5294117647, blue: 0.568627451, alpha: 1)
    public static let medium = #colorLiteral(red: 0.7137874961, green: 0.7169864178, blue: 0.7506411672, alpha: 1)
    public static let light = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9411764706, alpha: 1)
    public static let lightest = #colorLiteral(red: 0.9529411765, green: 0.9568627451, blue: 0.9764705882, alpha: 1)
    
    //MARK: -Feedback colors
    public static let positive = #colorLiteral(red: 0.2235294118, green: 0.737254902, blue: 0.3450980392, alpha: 1)
    public static let positiveDark = #colorLiteral(red: 0.2058257461, green: 0.6786056161, blue: 0.3184466064, alpha: 1)
    public static let warning = #colorLiteral(red: 1, green: 0.8039215686, blue: 0.09803921569, alpha: 1)
    public static let warningDark = #colorLiteral(red: 0.9462640882, green: 0.7564004064, blue: 0.08315924555, alpha: 1)
    public static let negative = #colorLiteral(red: 1, green: 0.31204772, blue: 0.2710748911, alpha: 1)
    public static let negativeDark = #colorLiteral(red: 0.9231129289, green: 0.2919047475, blue: 0.2485084534, alpha: 1)
}

extension UIFont {
    public static func circularBook(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "CircularXX-Book", size: size) {
            return font
        } else {
            // Handle the case where the font couldn't be loaded.
            // You can return a default font or handle the error as needed.
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    public static func circularBold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "CircularXX-Bold", size: size) {
            return font
        } else {
            // Handle the case where the font couldn't be loaded.
            // You can return a default font or handle the error as needed.
            return UIFont.boldSystemFont(ofSize: size)
        }
    }
}

