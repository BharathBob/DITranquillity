//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// as...
public enum DIAsSelf { case `self` }

extension DIRegistrationBuilder {
  @discardableResult
  public func `as`(_: DIAsSelf) -> Self {
    DIRegistrationAlternativeType<Impl, Impl>(builder: self).unsafe()
    return self
  }
  
  public func `as`<Parent>(_ parentType: Parent.Type) -> DIRegistrationAlternativeType<Impl, Parent> {
    return DIRegistrationAlternativeType<Impl, Parent>(builder: self)
  }
  
  ///short
  @discardableResult
  public func `as`<Parent>(_ pType: Parent.Type, check: (Impl)->Parent) -> Self {
    DIRegistrationAlternativeType<Impl, Parent>(builder: self).check(check)
    return self
  }
}

public enum DISetDefault { case `default` }

// set...
extension DIRegistrationBuilder {
  @discardableResult
  public func set(name: String) -> Self {
    rType.names.insert(name)
    return self
  }
  
  @discardableResult
  public func set(_: DISetDefault) -> Self {
    rType.isDefault = true
    return self
  }
  
  @discardableResult
  public func set<T>(tag: T) -> Self {
    rType.names.insert(toString(tag: tag))
    return self
  }
}

// Initializer
extension DIRegistrationBuilder {
  @discardableResult
  public func initial(_ closure: @escaping () -> Impl) -> Self {
    rType.append(initial: { (_: DIContainer) -> Any in closure() })
    return self
  }
  
  @discardableResult
  public func initial(_ closure: @escaping (DIContainer) -> Impl) -> Self {
    rType.append(initial: { c -> Any in closure(c) })
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ method: @escaping (Impl) -> ()) -> Self {
    rType.append(injection: { _, obj in method(obj) })
    return self
  }

  @discardableResult
  public func injection<Inject>(_ method: @escaping (Impl, Inject) -> ()) -> Self {
    rType.append(injection: { c, o in method(o, *c) })
    return self
  }

  
  @discardableResult
  public func postInit(_ method: @escaping (DIContainer, Impl) -> ()) -> Self {
    rType.postInit = { method($0, $1 as! Impl) }
    return self
  }
}

// Auto Property Injection, Only for NSObject hierarchy classes and @objc properties
extension DIRegistrationBuilder where Impl: NSObject {
  @discardableResult
  public func useAutoPropertyInjection() -> Self {
    if !isAutoInjection {
      rType.appendAutoInjection(by: Impl.self)
      isAutoInjection = true
    }
    return self
  }
}

// LifeTime
extension DIRegistrationBuilder {
  @discardableResult
  public func lifetime(_ lifetime: DILifeTime) -> Self {
    rType.lifeTime = lifetime
    return self
  }
  
  @discardableResult
  public func initialNotNecessary() -> Self {
    rType.initialNotNecessary = true
    return self
  }
}

public final class DIRegistrationBuilder<Impl> {
  init(container: DIContainerBuilder, typeInfo: DITypeInfo) {
    self.rType = RType(typeInfo: typeInfo, modules: container.moduleStack)
    self.container = container.rTypeContainer
  }
  
  deinit {
    if !isTypeSet {
      self.as(.self)
    }
    
    // for optimization
    #if ENABLE_DI_LOGGER
      if rType.isProtocol {
        log(.registration, msg: "Registration protocol: \(rType.typeInfo)")
      } else {
        var msg = rType.isDefault ? "Default r" : "R"
        
        msg += "registration: \(rType.typeInfo).\n"
        msg += "  With lifetime: \(rType.lifeTime).\n"
        if !rType.names.isEmpty {
          msg += "  Has names: \(rType.names).\n"
        }
        if rType.hasInitial {
          msg += "  Has one or more initials.\n"
        }
        if rType.initialNotNecessary {
          msg += "  Also initial not necessary.\n"
        }
        
        let injectionCount = rType.injectionsCount - (isAutoInjection ? 1:0)
        if 0 < injectionCount {
          msg += "  Has \(injectionCount) injections.\n"
        }
        if isAutoInjection {
          msg += "  Has auto injection."
        }
        
        log(.registration, msg: msg)
      }
    #endif
  }
  
  var isTypeSet: Bool = false
  var isAutoInjection: Bool = false
  let rType: RType
  var container: RTypeContainer!
}
