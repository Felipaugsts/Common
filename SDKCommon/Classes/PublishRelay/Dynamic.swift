//
//  Dynamic.swift
//  SDKCommon
//
//  Created by FELIPE AUGUSTO SILVA on 14/09/22.
//

import Foundation

public class Dynamic<T> {
    public typealias BindType = ((T) -> Void)

    // MARK: - Properties

    private var binds: [BindType] = []

    public var value: T {
        didSet {
            execBinds()
        }
    }

    // MARK: - Initialize

    public init(_ val: T) {
        value = val
    }

    // MARK: - Public Methods

    public func bind(skip: Bool = false, _ bind: @escaping BindType) {
        binds.append(bind)
        if skip {
            return
        }
        bind(value)
    }

    // MARK: - Private Methods

    private func execBinds() {
        binds.forEach { [unowned self] bind in
            bind(self.value)
        }
    }
}
