//
//  Container+Externsion.swift
//  BeesInject
//
//  Created by FELIPE AUGUSTO SILVA on 08/03/22.
//

import Foundation
import Swinject

public typealias AppsContainer = Container

extension Container {

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: nitializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (()) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A, B>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A, B) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A, B, C>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A, B, C) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A, B, C, D>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A, B, C, D) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A, B, C, D, E>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A, B, C, D, E) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A, B, C, D, E, F>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A, B, C, D, E, F) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Registers a factory that resolves the Service based on dependencies inferred from the Service initializer.
	/// - Parameters:
	///   - service: Registered service type.
	///   - implementation: The concrrete implementation class. Usually required for scenarios when a single `Protocol` will have multiple concrete implementations.
	///   - initializer: initializer of the registered service.
	/// - Returns: The registered service entry.
	@discardableResult
	public func autoregister<Service, Implementation, A, B, C, D, E, F, G>(_ service: Service.Type, implementation: Implementation.Type, initializer: @escaping (A, B, C, D, E, F, G) -> Service) -> ServiceEntry<Service> {
		let registrationName = String(describing: implementation)
		return autoregister(service, name: registrationName, initializer: initializer)
	}

	/// Retrieves the instance with the specified service type and registration name.
	///
	/// - Parameters:
	///   - serviceType: The service type to resolve.
	///   - implementation: The registration type.
	///
	/// - Returns: The resolved service type instance, or nil if no registration for the service type and name
	///            is found in the `Container`.
	public func resolve<Service, Implementation>(_ service: Service.Type, implementation: Implementation.Type) -> Service {
		let name = String(describing: implementation)
		let optionalService: Service? = resolve(service, name: name)
		guard let service = optionalService else {
			preconditionFailure("Wasn't possible to resolve \(Service.self). Check the registration in your assembly!")
		}
		return service
	}
}
