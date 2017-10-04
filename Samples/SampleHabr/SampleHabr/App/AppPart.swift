//
//  AppPart.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class AppPart: DIPart {
  static func load(container: DIContainer) {
    container.registerStoryboard(name: "Main", bundle: nil)
      .lifetime(.single)
    
    #if swift(>=4.0)
    container.register1(YourPresenter.init)
      .lifetime(.lazySingle)
      .injection { $0.logger = $1 }
    #else
    container.register(YourPresenter.init)
      .lifetime(.lazySingle)
      .injection { $0.logger = $1 }
    #endif
    
    container.register(YourViewController.self)
      .injection { $0.presenter = $1 }
  }

}
