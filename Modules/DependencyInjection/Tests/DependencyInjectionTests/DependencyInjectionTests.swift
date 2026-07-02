import XCTest
@testable import DependencyInjection

final class DependencyInjectionTests: XCTestCase {
    
    func testDIContainerSingleton() {
        let container1 = DIContainer.shared
        let container2 = DIContainer.shared
        XCTAssertTrue(container1 === container2, "DIContainer should be a singleton")
    }
    
    func testServiceRegistration() {
        let container = DIContainer.shared
        
        // Register a test service
        container.register(String.self) { _ in "TestValue" }
        
        // Resolve it
        let resolved = container.resolve(String.self)
        XCTAssertEqual(resolved, "TestValue")
    }
}
