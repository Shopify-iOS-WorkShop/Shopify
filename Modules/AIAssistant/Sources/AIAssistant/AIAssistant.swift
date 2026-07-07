import Foundation
import SwiftUI

@MainActor
public final class AIAssistantKit: ObservableObject {

    public static let shared = AIAssistantKit()

    private(set) var config: AIAssistantConfig = .shopWorkshop

    public static func configure(with config: AIAssistantConfig) {
        shared.config = config
    }

    public lazy var shoppingAssistant = ShoppingAssistantAgent(config: config)
    public lazy var productComparison  = ProductComparisonAgent(config: config)
    public lazy var imageSearch        = ImageSearchAgent(config: config)
    public lazy var outfitGenerator    = OutfitGeneratorAgent(config: config)

    public var featuresEnabled: Set<AIFeature> = Set(AIFeature.allCases)

    private init() {}
}

public enum AIFeature: String, CaseIterable, Sendable {
    case shoppingAssistant = "AI Shopping Assistant"
    case productComparison = "AI Product Comparison"
    case imageSearch       = "AI Image Search"
    case outfitGenerator   = "AI Outfit Generator"

    public var icon: String {
        switch self {
        case .shoppingAssistant: return "bubble.left.and.bubble.right.fill"
        case .productComparison: return "arrow.left.arrow.right.circle.fill"
        case .imageSearch:       return "camera.viewfinder"
        case .outfitGenerator:   return "tshirt.fill"
        }
    }
}
