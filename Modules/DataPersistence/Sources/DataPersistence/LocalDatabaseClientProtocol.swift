import Foundation
import SwiftData

/// Generic abstraction over SwiftData operations for feature modules.
public protocol LocalDatabaseClientProtocol {
    func insert<T: PersistentModel>(_ model: T)
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T]
    func delete<T: PersistentModel>(_ model: T)
    func save() throws
}
