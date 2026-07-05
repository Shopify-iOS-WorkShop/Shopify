import Foundation

@MainActor
internal protocol CartLocalDataSourceProtocol {
    func saveCartRecord(_ record: CartRecord) throws
    func fetchCartRecord(ownerKey: String) -> CartRecord?
    func deleteCartRecord(ownerKey: String) throws
    func updateCachedQuantity(_ quantity: Int, ownerKey: String) throws
    func updateCachedCheckoutUrl(_ url: String, ownerKey: String) throws
}
