import SwiftUI
import PhotosUI


public struct ImageSearchView: View {

    let agent: ImageSearchAgent

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedImage: Image?
    @State private var textQuery = ""
    @State private var result: ImageSearchResult?
    @State private var isLoading = false
    @State private var error: String?
    @State private var showCamera = false

    public init(agent: ImageSearchAgent) {
        self.agent = agent
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard

                if let selectedImage {
                    selectedImageCard(selectedImage)
                }

                // Text search fallback
                if selectedImageData == nil {
                    textSearchCard
                }

                // Search button
                if selectedImageData != nil {
                    Button(action: searchWithImage) {
                        Label("Find Similar Products", systemImage: "camera.viewfinder")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isLoading ? Color.gray : Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isLoading)
                }

                // Loading
                if isLoading {
                    ProgressView("Analysing image and searching catalog…")
                        .padding(30)
                }

                // Error
                if let error {
                    ErrorCard(message: error) { self.error = nil }
                }

                // Results
                if let result {
                    searchResultView(result)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .photosPicker(isPresented: .constant(false), selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { item in
            loadImage(from: item)
        }
    }


    private var headerCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 36))
                .foregroundColor(.indigo)
            Text("AI Image Search")
                .font(.title3).bold()
            Text("Upload a photo of any product — our AI will find similar items in our store.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Photo Library", systemImage: "photo.on.rectangle")
                        .font(.subheadline)
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }


    private func selectedImageCard(_ image: Image) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your Image")
                    .font(.caption).foregroundColor(.secondary)
                Spacer()
                Button("Remove") {
                    selectedImage = nil
                    selectedImageData = nil
                    selectedItem = nil
                    result = nil
                }
                .font(.caption)
                .foregroundColor(.red)
            }
            image
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }


    private var textSearchCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Or describe what you're looking for")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                TextField("e.g. \"blue floral summer dress\"", text: $textQuery)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { searchWithText() }
                Button(action: searchWithText) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
                .disabled(textQuery.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }


    @ViewBuilder
    private func searchResultView(_ result: ImageSearchResult) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Matches Found", systemImage: "checkmark.circle.fill")
                    .font(.subheadline).bold()
                    .foregroundColor(.green)
                Spacer()
                Text("\(Int(result.confidence * 100))% confidence")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(result.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)

            ForEach(result.matchedProducts) { product in
                MatchedProductRow(product: product)
            }

            Button("Search Again") {
                withAnimation { self.result = nil }
            }
            .font(.subheadline)
            .foregroundColor(.indigo)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }


    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    selectedImageData = data
                    if let uiImage = decodeImage(data) {
                        selectedImage = Image(uiImage: uiImage)
                    }
                    result = nil
                }
            }
        }
    }

    private func decodeImage(_ data: Data) -> UIImage? {
        UIImage(data: data)
    }

    private func searchWithImage() {
        guard let data = selectedImageData else { return }
        error = nil
        isLoading = true
        result = nil

        Task {
            do {
                let r = try await agent.search(imageData: data, additionalQuery: textQuery.isEmpty ? nil : textQuery)
                await MainActor.run { result = r; isLoading = false }
            } catch {
                await MainActor.run { self.error = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func searchWithText() {
        let q = textQuery.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        error = nil
        isLoading = true
        result = nil

        Task {
            do {
                let r = try await agent.search(description: q)
                await MainActor.run { result = r; isLoading = false }
            } catch {
                await MainActor.run { self.error = error.localizedDescription; isLoading = false }
            }
        }
    }
}


private struct MatchedProductRow: View {
    let product: ShopifyProduct

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.indigo.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(Image(systemName: "bag.fill").foregroundColor(.indigo.opacity(0.5)))

            VStack(alignment: .leading, spacing: 3) {
                Text(product.title)
                    .font(.subheadline).bold()
                    .lineLimit(2)
                Text(product.minPrice)
                    .font(.caption)
                    .foregroundColor(.indigo)
                if !product.productType.isEmpty {
                    Text(product.productType)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


private struct ErrorCard: View {
    let message: String
    let dismiss: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
            Text(message).font(.caption)
            Spacer()
            Button(action: dismiss) { Image(systemName: "xmark") }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
