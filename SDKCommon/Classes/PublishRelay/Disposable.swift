//
//  Disposable.swift
//  FBSnapshotTestCase
//
//  Created by FELIPE AUGUSTO SILVA on 13/09/22.
//

import Foundation

public typealias DisposeBag = [Disposable]

public final class Disposable {
        // MARK: - Types
        /// Type for closure to be executed on deallocation.
    public typealias Dispose = () -> Void

        // MARK: - Private properties
        /// Closure to be executed on deallocation.
    private let dispose: Dispose

        // MARK: - Initializer
        /// Creates a new instance.
        ///
        /// - Parameter dispose: The closure that is executed on deallocation.
    public init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

        /// Executes our closure.
    deinit {
        dispose()
    }

        // MARK: - Public methods
        /// Adds the current instance to the given array of disposables.
    public func disposed(by bag: inout DisposeBag) {
        bag.append(self)
    }
}

