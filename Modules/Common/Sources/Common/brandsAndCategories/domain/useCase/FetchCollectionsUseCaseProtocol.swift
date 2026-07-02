//
//  FetchCollectionsUseCaseProtocol.swift
//  Common
//
//  Created by Mina on 02/07/2026.
//

public protocol FetchCollectionsUseCaseProtocol {
    func execute() async throws -> (brands: [GridItemEntity], categories: [GridItemEntity])
}
