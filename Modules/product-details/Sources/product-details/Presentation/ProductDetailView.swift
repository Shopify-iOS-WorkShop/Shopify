import SwiftUI
import Common



public struct ProductDetailView: View {



    @StateObject private var viewModel: ProductDetailViewModel

    @Environment(\.dismiss) private var dismiss



    public init(viewModel: ProductDetailViewModel) {

        _viewModel = StateObject(wrappedValue: viewModel)

    }



    public var body: some View {

        ZStack(alignment: .bottom) {
            Color(DS.background).ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(spacing: 0) {

                    switch viewModel.state {

                    case .idle, .loading:

                        loadingView

                    case .success(let product):

                        productContent(product)

                    case .failure(let message):

                        errorView(message)

                    }

                }
                .animation(.spring(), value: String(describing: viewModel.state))

            }

            .ignoresSafeArea(edges: .top)



            // Sticky bottom bar — only shown on success

            if case .success(let product) = viewModel.state {

                bottomBar(product)

            }

        }
        .background(DS.background.ignoresSafeArea())

        .navigationBarHidden(true)

        .onAppear { viewModel.onAppear() }

    }



    // MARK: - States



    private var loadingView: some View {

        VStack {

            Spacer(minLength: 300)

            ProgressView()

                .scaleEffect(1.4)

            Spacer()

        }

    }



    private func errorView(_ message: String) -> some View {

        VStack(spacing: 16) {

            Spacer(minLength: 200)

            Image(systemName: "exclamationmark.triangle")

                .font(.system(size: 48))
                .foregroundColor(DS.red.opacity(0.7))

            Text(message)

                .multilineTextAlignment(.center)

                .foregroundColor(DS.textSec)

                .padding(.horizontal, 32)

            Spacer()

        }

    }



    // MARK: - Product Content



    private func productContent(_ product: ProductDetailEntity) -> some View {

        VStack(alignment: .leading, spacing: 0) {

            // Image carousel

            ImageCarouselView(

                images: product.images,

                currentIndex: viewModel.currentImageIndex,

                isFavorite: viewModel.isFavorite,

                onBack: { dismiss() },

                onFavorite: { viewModel.toggleFavorite() },

                onPageChange: { viewModel.setImageIndex($0) }

            )



            VStack(alignment: .leading, spacing: 20) {

                // Header

                ProductHeaderView(

                    collection: product.collection,

                    title: product.title,

                    rating: product.rating,

                    reviewCount: product.reviewCount,

                    price: product.price

                )



                Divider().padding(.horizontal, -20)



                // Size selector

                SizeSelectorView(

                    sizes: product.sizes,

                    selected: viewModel.selectedSize,

                    onSelect: { viewModel.selectSize($0) }

                )



                Divider().padding(.horizontal, -20)



                // Description

                DescriptionView(

                    text: product.description,

                    isExpanded: viewModel.isDescriptionExpanded,

                    onToggle: { viewModel.toggleDescription() }

                )



                Divider().padding(.horizontal, -20)



                // Reviews

                ReviewsView(reviews: product.reviews)



                // Bottom padding for sticky bar

                Spacer(minLength: 100)

            }

            .padding(.horizontal, 20)

            .padding(.top, 24)
            .padding(.bottom, 16)

        }
        .background(DS.background)

    }



    // MARK: - Bottom Bar



    private func bottomBar(_ product: ProductDetailEntity) -> some View {

        VStack(spacing: 0) {

            Divider()

            HStack(spacing: 16) {

                // Quantity stepper

                QuantityStepperView(

                    quantity: viewModel.quantity,

                    onDecrement: { viewModel.decrementQuantity() },

                    onIncrement: { viewModel.incrementQuantity() }

                )



                // Add to Cart

                Button {

                    viewModel.addToCart()

                } label: {

                    Group {
                        if viewModel.isAddingToCart {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Add to Cart")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.selectedSize != nil ? DS.red : DS.lightGray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                }

                .disabled(viewModel.selectedSize == nil || viewModel.isAddingToCart)

            }
            if let message = viewModel.addToCartMessage {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
            } else if let error = viewModel.addToCartError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
            }

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(DS.cardBG)
        .shadow(color: DS.shadow.opacity(0.08), radius: 10, y: -4)

    }

}
