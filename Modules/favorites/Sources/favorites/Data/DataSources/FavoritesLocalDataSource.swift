import Foundation
import SwiftData
import DataPersistence

public final class FavoritesLocalDataSource {
    private let client: LocalDatabaseClientProtocol

    public init(client: LocalDatabaseClientProtocol) {
        self.client = client
    }

  
    public func insert(_ item: FavoriteItem) throws {
        client.insert(item)
        try client.save()
    }

   
    public func fetchAll() throws -> [FavoriteItem] {
        var descriptor = FetchDescriptor<FavoriteItem>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        descriptor.includePendingChanges = true
        return try client.fetch(descriptor)
    }

    
    public func find(productId: String) throws -> FavoriteItem? {
        var descriptor = FetchDescriptor<FavoriteItem>(
            predicate: #Predicate { $0.productId == productId }
        )
        descriptor.fetchLimit = 1
        return try client.fetch(descriptor).first
    }

    
    public func delete(productId: String) throws {
        guard let item = try find(productId: productId) else {
            throw FavoritesLocalDataSourceError.notFound
        }
        client.delete(item)
        try client.save()
    }
}

// MARK: - Internal error type

enum FavoritesLocalDataSourceError: Error {
    case notFound
}
