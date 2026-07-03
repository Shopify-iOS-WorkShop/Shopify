//
//  SessionStore.swift
//  Common
//
//  Concrete implementation of SessionProviding
//  Manages current session state across the app
//

import Foundation
import Combine

public final class SessionStore: SessionProviding, ObservableObject {
    
    @Published public private(set) var current: Session?
    
    private let sessionSubject = PassthroughSubject<Session?, Never>()
    
    public init() {
        self.current = nil
    }
    
    // MARK: - Public Methods
    
    public func updateSession(_ session: Session?) {
        self.current = session
        sessionSubject.send(session)
    }
    
    public func clearSession() {
        self.current = nil
        sessionSubject.send(nil)
    }
    
    public func observeSession() -> AnyPublisher<Session?, Never> {
        sessionSubject.eraseToAnyPublisher()
    }
}
