//
//  BeesAssembler.swift
//  BeesInject
//
//  Created by FELIPE AUGUSTO SILVA on 08/03/22.
//

import Foundation
import Swinject
import SwinjectAutoregistration

public final class AppAssembler {
    
    // MARK: - Public static
    
    private(set) static var shared = AppAssembler()
    
    // MARK: - Private constants
    
    private let assembler = Assembler()
    
    // MARK: - Private read-only
    
    private var container: Container {
        guard let container = assembler.resolver as? Container else {
            preconditionFailure("The resolver must be an instance of Container.")
        }
        
        return container
    }
    
    // MARK: - Public
    
    /// User this function to register multiple assemblies
    /// - Parameter assemblies: the assemblies list to apply to the container
    public static func apply(_ assemblies: [AppAssembly]) {
        assemblies.forEach { $0.assemble(container: shared.container) }
    }
    
    /// Use this function to register one single assembly
    /// - Parameter assembly: the assembly to apply to the container
    public static func apply(_ assembly: AppAssembly) {
        assembly.assemble(container: shared.container)
    }
    
    /// Retrieves the instance with the specified service type.
    ///
    /// - Parameter serviceType: The service type to resolve.
    /// - Returns: The resolved service type instance, or nil if no registration for the service type is found in the `Container`.
    public static func resolve<Service>(_ serviceType: Service.Type) -> Service {
        unwrap(resolveOptional(serviceType))
    }
    
    public static func resolveOptional<Service>(_ serviceType: Service.Type) -> Service? {
        shared.container.synchronize().resolve(serviceType)
    }
    
    /// Retrieves the instance with the specified service type.
    /// - Parameters:
    ///   - serviceType: The service type to resolve.
    ///   - name: Differentiate when you have multiple registered implementations for the same protocol
    /// - Returns: The resolved service type instance, or nil if no registration for the service type is found in the `Container`.
    public static func resolve<Service>(_ serviceType: Service.Type, name: String) -> Service {
        unwrap(resolveOptional(serviceType, name: name))
    }
    
    public static func resolveOptional<Service>(_ serviceType: Service.Type, name: String) -> Service? {
        shared.container.synchronize().resolve(serviceType, name: name)
    }
    
    /// Retrieves the instance with the specified service type.
    /// - Parameters:
    ///   - serviceType: The service type to resolve.
    ///   - arg1: 1 argument to pass to the factory closure.
    /// - Returns: The resolved service type instance, or nil if no registration for the service type
    ///            and 1 argument is found in the `Container`.
    public static func resolve<Service, Arg1>(_ serviceType: Service.Type, argument arg1: Arg1) -> Service {
        unwrap(resolveOptional(serviceType, argument: arg1))
    }
    
    public static func resolveOptional<Service, Arg1>(_ serviceType: Service.Type, argument arg1: Arg1) -> Service? {
        shared.container.synchronize().resolve(serviceType, argument: arg1)
    }
    
    /// Retrieves the instance with the specified service type.
    /// - Parameters:
    ///   - serviceType: The service type to resolve.
    ///   - arg1: 1 argument to pass to the factory closure.
    ///   - arg2: 2 argument to pass to the factory closure.
    /// - Returns: The resolved service type instance, or nil if no registration for the service type
    ///            and 1 argument is found in the `Container`.
    public static func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        unwrap(resolveOptional(serviceType, arguments: arg1, arg2))
    }
    
    /// Retrieves the instance with the specified service type.
    /// - Parameters:
    ///   - serviceType: The service type to resolve.
    ///   - arg1: 1 argument to pass to the factory closure.
    ///   - name: Differentiate when you have multiple registered implementations for the same protocol
    /// - Returns: The resolved service type instance, or nil if no registration for the service type
    ///            and 1 argument is found in the `Container`.
    public static func resolve<Service, Arg1>(_ serviceType: Service.Type, name: String, argument arg1: Arg1) -> Service {
        unwrap(shared.container.synchronize().resolve(serviceType, name: name, argument: arg1))
    }
    
    public static func resolveOptional<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        shared.container.synchronize().resolve(serviceType, arguments: arg1, arg2)
    }
    
    /// Be EXTREMLY careful using this function!!! All instances registered for all scopes will be `DISCARDED`!
    public static func reset() {
        shared.container.removeAll()
    }
    
    // MARK: - Private functions
    
    private static func unwrap<Service>(_ service: Service?) -> Service {
        guard let service = service else {
            preconditionFailure("Wasn't possible to resolve \(Service.self). Check the registration in your assembly!")
        }
        return service
    }
    
    // MARK: - Synchronized
    
    // swiftlint:disable type_name
    @available(*, deprecated, message: "synchronized is deprecated, please use resolve directly")
    public struct synchronized {
        // swiftlint:enable type_name
        
        /// Thread safety (synchronized) version of the `resolve`.
        public static func resolve<Service>(_ serviceType: Service.Type) -> Service {
            AppAssembler.resolve(serviceType)
        }
        
        /// Thread safety (synchronized) version of the `resolveOptional`.
        public static func resolveOptional<Service>(_ serviceType: Service.Type) -> Service? {
            AppAssembler.resolveOptional(serviceType)
        }
        
        /// Thread safety (synchronized) version of the `resolve`.
        public static func resolve<Service>(_ serviceType: Service.Type, name: String) -> Service {
            AppAssembler.resolve(serviceType, name: name)
        }
        
        /// Thread safety (synchronized) version of the `resolveOptional`.
        public static func resolveOptional<Service>(_ serviceType: Service.Type, name: String) -> Service? {
            AppAssembler.resolveOptional(serviceType, name: name)
        }
        
        /// Thread safety (synchronized) version of the `resolve`.
        public static func resolve<Service, Arg1>(_ serviceType: Service.Type, argument arg1: Arg1) -> Service {
            AppAssembler.resolve(serviceType, argument: arg1)
        }
        
        /// Thread safety (synchronized) version of the `resolveOptional`.
        public static func resolveOptional<Service, Arg1>(_ serviceType: Service.Type, argument arg1: Arg1) -> Service? {
            AppAssembler.resolveOptional(serviceType, argument: arg1)
        }
        
        /// Thread safety (synchronized) version of the `resolve`.
        public static func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
            AppAssembler.resolve(serviceType, arguments: arg1, arg2)
        }
        
        /// Thread safety (synchronized) version of the `resolveOptional`.
        public static func resolveOptional<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
            AppAssembler.resolveOptional(serviceType, arguments: arg1, arg2)
        }
    }
}
