//
//  DIContainerBuilder.ShortSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
	public func register<T>(short initializer: @escaping () -> T) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(initializer)
	}
	
	public func register<T>(initializer: @escaping (_ scope: DIScope) -> T) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(initializer)
	}
}
