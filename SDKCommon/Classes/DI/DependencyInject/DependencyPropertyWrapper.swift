//
//  DependencyPropertyWrapper.swift
//  swiftui-clean-archtecture
//
//  Created by Felipe Augusto Silva on 10/11/23.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct Service<Service> {
    
    var service: Service
    
    public init(_ dependencyType: ServiceType = .newInstance) {
        guard let service = ServiceContainer.resolve(dependencyType: dependencyType, Service.self) else {
            fatalError("No dependency of type \(String(describing: Service.self)) registered!")
        }
        
        self.service = service
    }
    
    public var wrappedValue: Service {
        get { self.service }
        mutating set { service = newValue }
    }
}

@available(iOS 14.0, *)
@propertyWrapper
public struct ServiceObject<ServiceType: ObservableObject> {
    private var service: ServiceType
    
    public var wrappedValue: ServiceType {
        get { service }
        mutating set { service = newValue }
    }
    
    public init() {
        guard let resolvedService = ServiceContainer.resolve(dependencyType: .newInstance, ServiceType.self) else {
            fatalError("No dependency of type \(String(describing: ServiceType.self)) registered!")
        }
        self.service = resolvedService
    }
}
