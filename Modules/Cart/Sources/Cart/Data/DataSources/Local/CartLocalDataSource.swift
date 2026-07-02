import Foundation
import SwiftData
import DataPersistence

internal final class CartLocalDataSource: CartLocalDataSourceProtocol {
    private let dbClient: LocalDatabaseClientProtocol
    
    init(dbClient: LocalDatabaseClientProtocol) {
        self.dbClient = dbClient
    }
    
    func saveCartRecord(_ record: CartRecord) throws {
        let ownerKey = record.ownerKey
        let descriptor = FetchDescriptor<CartRecord>(predicate: #Predicate { $0.ownerKey == ownerKey })
        if let existing = try? dbClient.fetch(descriptor).first {
            existing.cartId = record.cartId
            existing.cartIdCreatedAt = record.cartIdCreatedAt
            existing.updatedAt = record.updatedAt
        } else {
            dbClient.insert(record)
        }
        try dbClient.save()
    }
    
    func fetchCartRecord(ownerKey: String) -> CartRecord? {
        let descriptor = FetchDescriptor<CartRecord>(predicate: #Predicate { $0.ownerKey == ownerKey })
        return try? dbClient.fetch(descriptor).first
    }
    
    func deleteCartRecord(ownerKey: String) throws {
        guard let existing = fetchCartRecord(ownerKey: ownerKey) else { return }
        dbClient.delete(existing)
        try dbClient.save()
    }
    
    func updateCachedQuantity(_ quantity: Int, ownerKey: String) throws {
        guard let existing = fetchCartRecord(ownerKey: ownerKey) else { return }
        existing.totalQuantity = quantity
        existing.updatedAt = Date()
        try dbClient.save()
    }
    
    func updateCachedCheckoutUrl(_ url: String, ownerKey: String) throws {
        guard let existing = fetchCartRecord(ownerKey: ownerKey) else { return }
        existing.lastKnownCheckoutUrl = url
        try dbClient.save()
    }
}
