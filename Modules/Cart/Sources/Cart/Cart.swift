// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection

// MARK: - Dependency Injection Assembly Export
public typealias AppCartAssembly = CartAssembly

// MARK: - Presentation Exports
@available(iOS 13.0.0, *)
public typealias AppCartView = CartView

@available(iOS 13.0.0, *)
public typealias AppCartViewModel = CartViewModel

@available(iOS 13.0.0, *)
public typealias AppCartCoordinator = CartCoordinator
