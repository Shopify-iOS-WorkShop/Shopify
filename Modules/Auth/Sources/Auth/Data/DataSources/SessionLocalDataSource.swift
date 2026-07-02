import Foundation

final class SessionLocalDataSource {
    private let userDefaults: UserDefaults
    private let sessionKey = "auth.session"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func save(_ session: Session) throws {
        let data = try JSONEncoder().encode(session)
        userDefaults.set(data, forKey: sessionKey)
    }

    func fetch() -> Session? {
        guard let data = userDefaults.data(forKey: sessionKey) else { return nil }
        return try? JSONDecoder().decode(Session.self, from: data)
    }

    func clear() {
        userDefaults.removeObject(forKey: sessionKey)
    }
}
