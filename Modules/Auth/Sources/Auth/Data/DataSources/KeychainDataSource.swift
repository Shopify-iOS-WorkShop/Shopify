import Foundation
import Security

final class KeychainDataSource {
    private let service = "judge.Shopify.auth"

    func savePassword(_ password: String, for email: String) throws {
        let data = Data(password.utf8)
        let query = baseQuery(email: email)
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw AuthError.authentication("Unable to save secure credentials.")
        }
    }

    func password(for email: String) -> String? {
        var query = baseQuery(email: email)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func deletePassword(for email: String) {
        SecItemDelete(baseQuery(email: email) as CFDictionary)
    }

    private func baseQuery(email: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email.lowercased()
        ]
    }
}
