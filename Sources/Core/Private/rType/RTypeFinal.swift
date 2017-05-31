//
//  RTypeFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeFinal: RTypeBase {
  typealias MethodKey = String
  
  #if ENABLE_DI_MODULE
  init(typeInfo: DITypeInfo, inModules: [DIModuleType], outModules: [DIModuleType], initials: [MethodKey: Any], injections: [(_: DIContainer, _: Any) throws -> ()], names: Set<String>, isDefault: Bool, lifeTime: DILifeTime) {
    self.inModules = Set(inModules)
    self.outModules = Set(outModules)
    self.initials = initials
    self.injections = injections
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(typeInfo: typeInfo)
  }
  #else
  init(typeInfo: DITypeInfo, initials: [MethodKey: Any], injections: [(_: DIContainer, _: Any) throws -> ()], names: Set<String>, isDefault: Bool, lifeTime: DILifeTime) {
    self.initials = initials
    self.injections = injections
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(typeInfo: typeInfo)
  }
  #endif
  
  func new<Method, T>(_ method: (Method) throws -> T) throws -> T {
    guard let initializer = initials[MethodKey(describing: Method.self)] as? Method else {
      let diError = DIError.initialMethodNotFound(typeInfo: typeInfo, signature: Method.self)
      log(.error(diError), msg: "Initial method not found for type info: \(typeInfo)")
      throw diError
    }
    
    return try method(initializer)
  }
  
  func has(name: String) -> Bool {
    return names.contains(name)
  }
  
  #if ENABLE_DI_MODULE
  let inModules: Set<DIModuleType>
  let outModules: Set<DIModuleType>
  #endif 
  let lifeTime: DILifeTime
  let isDefault: Bool
  let injections: [(_: DIContainer, _: Any) throws -> ()]
  
  private let initials: [MethodKey: Any]
  private let names: Set<String>
}
