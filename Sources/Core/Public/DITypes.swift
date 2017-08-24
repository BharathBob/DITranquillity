//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


/// Namespace
/// Special hack for Swift. 
/// If class with generic whthin another structure, then it can be partially specialized
//public struct DI {
  /// Special class for resolve object by type with tag
public final class DIByTag<Tag, T>: InternalByTag<Tag, T> {
    /// Method for installing tag
    ///
    /// - Parameter tag: a Tag
    public subscript(_ tag: Tag.Type) -> DIByTag<Tag, T> { return self }
    
    /// Resolved object
    public var object: T { return _object }
  
    /// Resolved object, short syntax
    public var o: T { return _object }
  }
  
  /// Special class for resolve many object
  public final class DIMany<T>: InternalByMany<T> {
    /// Resolved objects
    public var objects: [T] { return _objects }
    
    /// Resolved objects, short syntax
    public var o: [T] { return _objects }
  }
//}

/// Any type that can be in the application
public typealias DIAType = Any.Type

/// Tag is needed to specify alternative component names
public typealias DITag = Any.Type

/// Type of function for logging
public typealias DILogFunc = (DILogLevel, String)->()

/// Short information about component. Needed for good log
public struct DIComponentInfo: Equatable, CustomStringConvertible {
  /// Any type announced at registration the component
  public let type: DIAType
  /// File where the component is registration
  public let file: String
  /// Line where the component is registration
  public let line: Int

  public static func ==(lhs: DIComponentInfo, rhs: DIComponentInfo) -> Bool {
    return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
  }
  
  
  public var description: String {
    return "Component with type: \(type) in file: \((file as NSString).lastPathComponent) on line: \(line)"
  }
}
  
/// Log levels. Needed for a better understanding of logs, and clipping
///
/// - error: After an error, a application can not be executable
/// - warning: Warning should pe paid attention and analyzed
/// - info: Information is needed to understand what is happening
/// - none: disable all logs
public enum DILogLevel: Equatable {
  case error
  case warning
  case info
  case none
}
  

/// A object life time
///
/// - single: The object is only one in the application. Initialization during executed `DIContainerBuilder.build()`
/// - lazySingle: The object is only one in the application. Initialization when first accessed
/// - weakSingle: The object is only one in the application. Initialization when first accessed, and the library doesn't hold it
/// - objectGraph: The object is created every time, but during the creation will be created once
/// - prototype: The object is created every time
public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case weakSingle
  case objectGraph
  case prototype
  
  /// Default life time. Is taken from the settings. see: `DISetting.Defaults.lifeTime`
  static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }
}


/// Error that can occur at build time - during executed `DIContainerBuilder.build()`
public struct DIBuildError: Error {
  let message: String = "Can't build. Use DISetting.Log.fun for more information"
}
