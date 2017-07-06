//
//  DIContainerBuilder.Register.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  public func register<T>(type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line)
  }
  
  public func `import`<IMPORT: DIModule, TO: DIModule>(_ module: IMPORT.Type, to: TO.Type) {
    bundleContainer.dependency(bundle: Bundle(for: to), import: Bundle(for: module))
  }
}

/// Internal
extension DIContainerBuilder {
  internal func registrationBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self, typeInfo: DITypeInfo(type: T.self, file: file, line: line))
  }
}
