import SwiftUI


public struct AIAssistantCoordinator: View {

    @StateObject private var kit = AIAssistantKit.shared
    @State private var selectedFeature: AIFeature = .shoppingAssistant
    @State private var showingFeaturePicker = false

    private let initialFeature: AIFeature?
    private let onProductSelected: ((ShopifyProduct) -> Void)?

    public init(initialFeature: AIFeature? = nil, onProductSelected: ((ShopifyProduct) -> Void)? = nil) {
        self.initialFeature = initialFeature
        self.onProductSelected = onProductSelected
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Feature selector tab bar
                featureTabBar

                // Active feature content
                featureContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(LocalizedStringKey(selectedFeature.rawValue))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFeaturePicker.toggle()
                    } label: {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(DS.red)
                    }
                }
            }
            .sheet(isPresented: $showingFeaturePicker) {
                FeaturePickerSheet(selected: $selectedFeature)
            }
        }
        .tint(DS.red)
        .onAppear {
            if let initial = initialFeature {
                selectedFeature = initial
            }
        }
    }


    @ViewBuilder
    private var featureTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AIFeature.allCases, id: \.self) { feature in
                    if kit.featuresEnabled.contains(feature) {
                        FeatureTab(feature: feature, isSelected: selectedFeature == feature) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedFeature = feature
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(DS.background)
        Divider()
    }

    @ViewBuilder
    private var featureContent: some View {
        switch selectedFeature {
        case .shoppingAssistant:
            ChatView(agent: kit.shoppingAssistant, onProductSelected: onProductSelected)
        case .productComparison:
            ProductComparisonView(agent: kit.productComparison, onProductSelected: onProductSelected)
        case .imageSearch:
            ImageSearchView(agent: kit.imageSearch, onProductSelected: onProductSelected)
        case .outfitGenerator:
            OutfitGeneratorView(agent: kit.outfitGenerator, onProductSelected: onProductSelected)
        }
    }
}


private struct FeatureTab: View {
    let feature: AIFeature
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: feature.icon)
                    .font(.caption)
                Text(LocalizedStringKey(feature.rawValue.components(separatedBy: " ").dropFirst().joined(separator: " ")))
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? DS.red : DS.cardBG)
            .foregroundColor(isSelected ? .white : DS.textSec)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}


private struct FeaturePickerSheet: View {
    @Binding var selected: AIFeature
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(AIFeature.allCases, id: \.self) { feature in
                Button {
                    selected = feature
                    dismiss()
                } label: {
                    Label(LocalizedStringKey(feature.rawValue), systemImage: feature.icon)
                        .foregroundColor(DS.textPri)
                }
            }
            .navigationTitle("AI Features")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(DS.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
