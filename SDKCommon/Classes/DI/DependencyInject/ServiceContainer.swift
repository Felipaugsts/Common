//
//  ServiceContainer.swift
//  swiftui-clean-archtecture
//
//  Created by Felipe Augusto Silva on 10/11/23.
//

import Foundation

public final class ServiceContainer {
    
    private static var cache: [String: Any] = [:]
    private static var generators: [String: () -> Any] = [:]
    
    public static func register<Service>(type: Service.Type, as serviceType: ServiceType = .automatic, _ factory: @autoclosure @escaping () -> Service) {
        generators[String(describing: type.self)] = factory
        
        if serviceType == .singleton {
            cache[String(describing: type.self)] = factory()
        }
    }
    
    public static func resolve<Service>(dependencyType: ServiceType = .automatic, _ type: Service.Type) -> Service? {
        let key = String(describing: type.self)
        switch dependencyType {
        case .singleton:
            if let cachedService = cache[key] as? Service {
                return cachedService
            } else {
                fatalError("\(String(describing: type.self)) is not registeres as singleton")
            }
            
        case .automatic:
            if let cachedService = cache[key] as? Service {
                return cachedService
            }
            fallthrough
            
        case .newInstance:
            if let service = generators[key]?() as? Service {
                cache[String(describing: type.self)] = service
                return service
            } else {
                return nil
            }
        }
    }
}
