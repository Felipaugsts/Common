//
//  String+Extension.swift
//  abseil
//
//  Created by Felipe Augusto Silva on 14/09/23.
//

import Foundation

public extension String {
    public func localized(tableName: String, bundle: Bundle, arguments: [CVarArg] = []) -> String {
        String(format: NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: ""), arguments: arguments)
    }
    
    public func localized(tableName: String, bundle: Bundle, arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: ""), arguments: arguments)
    }
    
    public func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "R$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
