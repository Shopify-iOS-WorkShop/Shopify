public struct CartDiscount: Equatable {
    public let code: String
    public let applicable: Bool

    public init(code: String, applicable: Bool) {
        self.code = code
        self.applicable = applicable
    }
}
