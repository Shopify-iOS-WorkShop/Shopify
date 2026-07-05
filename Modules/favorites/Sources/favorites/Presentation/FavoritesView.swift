import SwiftUI

public struct FavoritesView: View {
    @ObservedObject private var viewModel: FavoritesViewModel
    @Environment(FavoritesCoordinator.self) private var coordinator

    @State private var pendingDeleteId: String? = nil
    @State private var showDeleteAlert = false

    public init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                loadingView

            case .empty:
                emptyView

            case .loaded(let products):
                productList(products)

            case .failure(let message):
                errorView(message)
            }
        }
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { viewModel.onAppear() }
        .alert("Remove from Wishlist?", isPresented: $showDeleteAlert) {
            Button("Remove", role: .destructive) {
                if let id = pendingDeleteId {
                    viewModel.remove(productId: id)
                }
                pendingDeleteId = nil
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteId = nil
            }
        } message: {
            Text("This product will be removed from your wishlist.")
        }
    }

    // MARK: - States

    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.4)
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60, weight: .ultraLight))
                .foregroundColor(Color(.systemGray3))

            Text("No favorites yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Tap the heart on any product to save it here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red.opacity(0.7))

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)

            Button("Try Again") {
                viewModel.loadFavorites()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.pink)
        }
    }

    private func productList(_ products: [FavoriteProduct]) -> some View {
        List {
            ForEach(products) { product in
                FavoriteProductCardView(
                    product: product,
                    onRemove: { id in
                        pendingDeleteId = id
                        showDeleteAlert = true
                    },
                    onTap: { id in
                        guard let intId = Int(id) else { return }
                        coordinator.push(.productDetail(productId: intId))
                    }
                )
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowBackground(Color(.systemGroupedBackground))
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        // Swipe to delete — confirm before deleting
                        pendingDeleteId = product.id
                        showDeleteAlert = true
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
    }
}
