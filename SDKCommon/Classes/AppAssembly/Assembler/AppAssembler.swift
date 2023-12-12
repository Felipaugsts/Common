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
}
