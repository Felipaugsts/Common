//
//  NotificationService.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 03/10/23.
//

import Foundation

public protocol PanNotificationsService {
    func addObserver(_ observer: Any, selector: Selector, name key: Notification.Name, object: Any?)
    func removeObserver(_ observer: Any, name key: Notification.Name, object: Any?)
    func post(name key: Notification.Name, object: Any?, userInfo: [AnyHashable : Any]?)
    func removeAllObservers()
}

final public class PanNotifications: PanNotificationsService {
    
    // MARK: - Singleton
    
    public static var shared: PanNotificationsService = PanNotifications()
    
    // MARK: - Notification Singleton
    
    let notificationCenter: NotificationCenter
    
    // MARK: - Properties
    
    private var notificationList: [Notification.Name: Any] = [:]
    
    // MARK: - Lifecycle
    
    init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Service
    
    public func addObserver(_ observer: Any, selector: Selector, name key: Notification.Name, object: Any?) {
        removeObserver(observer, name: key, object: object)
        notificationList[key] = observer
        notificationCenter.addObserver(observer, selector: selector, name: key, object: object)
    }
    
    public func removeObserver(_ observer: Any, name key: Notification.Name, object: Any?) {
        let existantObserver = notificationList.removeValue(forKey: key)
        let observerToBeRemoved = existantObserver ?? observer
        notificationCenter.removeObserver(observerToBeRemoved, name: key, object: object)
    }
    
    public func post(name key: Notification.Name, object: Any?, userInfo: [AnyHashable : Any]?) {
        notificationCenter.post(name: key, object: object, userInfo: userInfo)
    }
    
    public func removeAllObservers() {
        for (key, observer) in notificationList {
            notificationCenter.removeObserver(observer, name: key, object: nil)
        }
        notificationList.removeAll()
    }
}

