import SwiftData

public final class SwiftDataClient: LocalDatabaseClientProtocol {
    private let context: ModelContext
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    public func insert<T: PersistentModel>(_ model: T) {
        context.insert(model)
    }
    
    public func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        return try context.fetch(descriptor)
    }
    
    public func delete<T: PersistentModel>(_ model: T) {
        context.delete(model)
    }
    
    public func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
