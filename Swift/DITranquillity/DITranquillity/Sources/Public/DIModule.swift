//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIModule: class {
  func load(_ builder: DIContainerBuilder)
}

extension DIContainerBuilder {
  public func registerModule(_ module: DIModule) -> Self {
    if !ignore(uniqueKey: String(describing: type(of: module))) {
      module.load(self)
    }
    return self
  }
}
