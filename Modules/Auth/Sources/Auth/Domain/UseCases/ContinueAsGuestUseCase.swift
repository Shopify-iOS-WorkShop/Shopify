//
//  File.swift
//  
//
//  Created by Ahmed Elkady on 27/06/2026.
//
public protocol ContinueAsGuestUseCaseProtocol {
    func execute() -> UserSession
}

public final class ContinueAsGuestUseCase: ContinueAsGuestUseCaseProtocol {

    public init() {}

    public func execute() -> UserSession {
        .guest
    }
}
