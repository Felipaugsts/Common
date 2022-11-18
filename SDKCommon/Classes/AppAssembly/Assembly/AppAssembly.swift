//
//  AppAssembly.swift
//  BeesInject
//
//  Created by FELIPE AUGUSTO SILVA on 08/03/22.
//

import Foundation
import Swinject

public typealias AppsContainer = Container

public protocol AppAssembly {
	/// Provide hook for `Assembler` to load Services into the provided container
	///
	/// - parameter container: the container provided by the `Assembler`
	///
	func assemble(container: AppsContainer)
}
