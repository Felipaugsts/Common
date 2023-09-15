//
//  String+Extension.swift
//  abseil
//
//  Created by Felipe Augusto Silva on 14/09/23.
//

import Foundation

public extension String {
    func localized(tableName: String, bundle: Bundle, arguments: [CVarArg] = []) -> String {
        String(format: NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: ""), arguments: arguments)
    }
    
    func localized(tableName: String, bundle: Bundle, arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: ""), arguments: arguments)
    }
}
