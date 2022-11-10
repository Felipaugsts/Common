//
//  BeesResolver.swift
//  BeesInject
//
//  Created by FELIPE AUGUSTO SILVA on 08/03/22.
//

import Foundation
import Swinject

extension Resolver { 

	/// Retrieves the instances with the specified service type and registration names.
	/// - Parameters:
	///   - serviceType: The service type to resolve.
	///   - names: The registration names.
	/// - Returns: The resolved service type instances, or nil if no registration for the service type and names are found in the `Container`.
	func resolveMany<Service>(_ serviceType: Service.Type, names: [String]) -> [Service]? {

		guard !names.isEmpty else {
			return nil
		}

		var resolvedServices = [Service]()

		for name in names {
			guard let resolvedService = resolve(serviceType, name: name) else {
				NSLog("No registration found with name \(name) for the service type \(serviceType). Aborting.")
				return nil
			}
			resolvedServices.append(resolvedService)
		}

		return resolvedServices
	}

}
