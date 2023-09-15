//
//  Localizable.swift
//  abseil
//
//  Created by Felipe Augusto Silva on 14/09/23.
//

import Foundation

public protocol Localizable {
    var tableName: String { get }
    var bundle: Bundle? { get }

    func string(_ arguments: [CVarArg]) -> String
    func string(_ arguments: CVarArg...) -> String
}

public extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    func string(_ arguments: [CVarArg] = []) -> String {
        rawValue.localized(tableName: tableName, bundle: bundle ?? .main, arguments: arguments)
    }

    func string(_ arguments: CVarArg...) -> String {
        rawValue.localized(tableName: tableName, bundle: bundle ?? .main, arguments: arguments)
    }
}
