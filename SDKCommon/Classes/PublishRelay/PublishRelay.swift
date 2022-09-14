//
//  PublishRelay.swift
//  FBSnapshotTestCase
//
//  Created by FELIPE AUGUSTO SILVA on 13/09/22.
//

import Foundation

    // Starts with an initial value and replays it or the latest element to new subscribers.
public final class BehaviorRelay<T>: Observable<T> {
    // MARK: - Public properties

    // The current (read- and writeable) value of the variable.
    override public var value: Value {
        get { _value }
        set { _value = newValue }
    }

    // MARK: - Private properties

    // The storage for our computed property.
    private var _value: Value {
        didSet {
            notifyObserver(with: value, from: oldValue)
        }
    }

    // MARK: - Initializer

    /// - Note: We keep the initializer to the super class `Observable`
    /// fileprivate in order to verify always having a value.
    public init(_ value: Value) {
        _value = value

        super.init()
    }

    // MARK: - Public methods
    override public func subscribe(_ observer: @escaping Observer) -> Disposable {
        // A variable should inform the observer with the initial value.
        observer(_value, nil)

        return super.subscribe(observer)
    }
}

// Starts empty and only emits new elements to subscribers.
public final class PublishRelay<T>: Observable<T> {
    // MARK: - Public properties

    /// The current (readonly) value of the observable (if available).
    override public var value: Value? {
        _value
    }

    // MARK: - Private properties
    private var _value: Value?

    // MARK: - Initializer

    override public init() {
        super.init()
    }

    // MARK: - Public methods
    /// Updates the publish subject using the given value.
    public func update(_ value: Value) {
        let oldValue = _value
        _value = value

        /// We inform the observer here instead of using `didSet` on `_value`
        /// to prevent unwrapping an optional (`_value` is nullable, as we're starting empty).
        /// Unwrapping lead to issues / crashes on having an underlying optional type, e.g. `PublishRelay<Int?>`.
        notifyObserver(with: value, from: oldValue)
    }
}

public class Observable<T> {
        // MARK: - Types
    public typealias Value = T
    public typealias OldValue = T?
    public typealias Observer = (_ value: Value, _ oldValue: OldValue) -> Void

        // We store all observers within a dictionary, for which this is the type of the key.
    private typealias Index = UInt

        // MARK: - Public properties

        // The current (readonly) value of the observable (if available).
        // - Note: We're using a computed property here, cause we need
        // to override this property without nullability in the subclass `Variable`.
        // - Attention: It's always better to subscribe to a given observable!
        // This **shortcut** should only be used during **testing**.
    public var value: Value? {
        fatalError("⚠️ – Trying to access an abstract property! Subclasses need to overwrite and implement this computed property.")
    }

        // MARK: - Private properties
    private var lastObserverIndex: Index = 0
    private var activeObservers = [Index: Observer]()

        // MARK: - Initalizer

        // - Note: Declared `fileprivate` in order to prevent directly initializing
        // an observable, that can't emit values.
    public init() {
            // Intentionally unimplemented
    }

        // MARK: - Public methods

        // This method is to clear the dictionary and reset the index of what is being observed.
    public func clearAll() {
        lastObserverIndex = 0
        activeObservers = [:]
    }

        // Informs the given observer on changes to our underlying property `value`.
        // - Parameter observer: The closure that is notified on changes.
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let indexForNewObserver = lastObserverIndex + 1
        activeObservers[indexForNewObserver] = observer
        lastObserverIndex = indexForNewObserver

            // Return a disposable, that removes the entry for this observer on
            // it's deallocation.
        return Disposable { [weak self] in
            self?.activeObservers[indexForNewObserver] = nil
        }
    }

        // MARK: - Private methods
    public func notifyObserver(with value: Value, from oldValue: OldValue) {
        activeObservers.values.forEach { observer in
            observer(value, oldValue)
        }
    }
}

    // MARK: - Extension Equatable
    // Additional helper methods for an observable that that underlying type
    // conforms to `Equatable`.
extension Observable where T: Equatable {
        // MARK: - Types
        /// The type for the filter closure.
        ///
        /// - Parameters:
        ///   - value: The current (new) value.
        ///   - oldValue: The previous (old) value.
        ///
        /// - Returns: `true` if the filter matches, otherwise `false`.
    public typealias Filter = (_ value: Value, _ oldValue: OldValue) -> Bool

        // MARK: - Public methods
        /// Informs the given observer on changes to our `value`, only if the given filter matches.
        ///
        /// - Parameters:
        ///   - filter: The closure, that must return `true` in order for the observer to be notified.
        ///   - observer: The closure that is notified on changes if the filter succeeds.
        ///
        ///  - Note:
        ///   The `oldValue` of the observer always contains the previous value that passed the
        ///   filter! E.g. if you filter for even numbers:
        ///   ```
        ///   | Emitted values:            | 0        | 1        | 2        | 3        | 4        | 5        |
        ///   | -------------------------- | -------- | -------- | -------- | -------- | -------- | -------- |
        ///   | filter(value, oldValue):   | (0, nil) | (1, 0)   | (2, 1)   | (3, 2)   | (4, 3)   | (5, 4)   |
        ///   | result:                    | true     | false    | true     | false    | true     | false    |
        ///   | observer(value, oldValue): | (0, nil) |          | (2, 0)   |          | (4, 2)   |          |
        ///   ```
    public func subscribe(filter: @escaping Filter, observer: @escaping Observer) -> Disposable {
            // As we're only calling the observer after the given `filter` succeeds, we need to
            // save the last `newValue` that passed the filter.
            // Then we can pass this value as the correct `oldValue` on the next call to the given `observer`.
        var filteredOldValue: OldValue = nil

        return subscribe { newValue, oldValue in
                // For having a correct working filter we need to pass in the current `oldValue`.
            if filter(newValue, oldValue) {
                observer(newValue, filteredOldValue)
                filteredOldValue = newValue
            }
        }
    }

        /// Informs the given observer on **distinct** changes to our `value`.
        ///
        /// - Parameter observer: The closure that is notified on changes.
    public func subscribeDistinct(_ observer: @escaping Observer) -> Disposable {
        subscribe(filter: { $0 != $1 },
                  observer: observer)
    }
}
