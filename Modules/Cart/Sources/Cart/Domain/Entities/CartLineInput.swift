public struct CartLineInput: Equatable {
    public let variantId: String
    public let quantity: Int

    public init(variantId: String, quantity: Int) {
        self.variantId = variantId
        self.quantity = quantity
    }
}
