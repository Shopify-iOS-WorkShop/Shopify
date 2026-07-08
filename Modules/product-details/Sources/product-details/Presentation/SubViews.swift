import SwiftUI
import Common



// MARK: - Image Carousel



struct ImageCarouselView: View {

let images: [String]

let currentIndex: Int

let isFavorite: Bool

let onBack: () -> Void

let onFavorite: () -> Void

let onPageChange: (Int) -> Void



var body: some View {

ZStack(alignment: .bottom) {

// Paged image scroll

TabView(selection: Binding(

get: { currentIndex },

set: { onPageChange($0) }

)) {

ForEach(Array(images.enumerated()), id: \.offset) { index, url in

AsyncImage(url: URL(string: url)) { phase in

switch phase {

case .success(let image):

image

.resizable()

.scaledToFill()

case .failure:

placeholderImage

default:

DS.fieldBG

.overlay(ProgressView())

}

}

.frame(maxWidth: .infinity)

.clipped()

.tag(index)

}

}

.tabViewStyle(.page(indexDisplayMode: .never))

.frame(height: 340)

.background(DS.fieldBG)



// Page dots

HStack(spacing: 6) {

ForEach(0..<images.count, id: \.self) { i in

Circle()

.fill(i == currentIndex ? DS.textPri : DS.textSec.opacity(0.4))

.frame(width: i == currentIndex ? 8 : 6, height: i == currentIndex ? 8 : 6)

.animation(.easeInOut(duration: 0.2), value: currentIndex)

}

}

.padding(.bottom, 16)



// Nav buttons

VStack {

HStack {

navButton(systemName: "chevron.left", action: onBack)

Spacer()

Button(action: onFavorite) {

Image(systemName: isFavorite ? "heart.fill" : "heart")

.font(.system(size: 14, weight: .semibold))

.foregroundColor(isFavorite ? DS.red : DS.red.opacity(0.55))

.frame(width: 38, height: 38)

.background(DS.cardBG)

.clipShape(RoundedRectangle(cornerRadius: 12))

.shadow(color: DS.shadow.opacity(0.10), radius: 4, y: 2)

}

}

.padding(.horizontal, 16)

.padding(.top, 56)

Spacer()

}

}

.frame(height: 340)

}



private func navButton(systemName: String, action: @escaping () -> Void) -> some View {

Button(action: action) {

Image(systemName: systemName)

.font(.system(size: 14, weight: .semibold))

.foregroundColor(DS.textPri)

.frame(width: 38, height: 38)

.background(DS.cardBG)

.clipShape(RoundedRectangle(cornerRadius: 12))

.shadow(color: DS.shadow.opacity(0.10), radius: 4, y: 2)

}

}



private var placeholderImage: some View {

Rectangle()

.fill(DS.fieldBG)

.overlay(

Image(systemName: "photo")

.foregroundColor(DS.textSec)

.font(.largeTitle)

)

}

}



// MARK: - Product Header



struct ProductHeaderView: View {

let collection: String

let title: String

let rating: Double

let reviewCount: Int

let price: Double

@Environment(CurrencyStore.self) private var currencyStore



var body: some View {

VStack(alignment: .leading, spacing: 8) {

Text(collection.uppercased())

.font(.caption)

.fontWeight(.semibold)

.foregroundColor(DS.textSec)

.tracking(1.2)



Text(title)

.font(.title3)

.fontWeight(.bold)

.foregroundColor(DS.textPri)



HStack(spacing: 6) {

StarRatingView(rating: rating)

Text("(\(reviewCount) Reviews)")

.font(.caption)

.foregroundColor(DS.textSec)

}



Text(currencyStore.convert(price))

.font(.title)

.fontWeight(.bold)

.foregroundColor(DS.red)

}

}

}



// MARK: - Star Rating



struct StarRatingView: View {

let rating: Double



var body: some View {

HStack(spacing: 2) {

ForEach(1...5, id: \.self) { star in

Image(systemName: starIcon(for: star))

.font(.caption)

.foregroundColor(.orange)

}

}

}



private func starIcon(for star: Int) -> String {

let value = Double(star)

if rating >= value { return "star.fill" }

if rating >= value - 0.5 { return "star.leadinghalf.filled" }

return "star"

}

}



// MARK: - Size Selector



struct SizeSelectorView: View {

let sizes: [String]

let selected: String?

let onSelect: (String) -> Void



var body: some View {

VStack(alignment: .leading, spacing: 12) {

HStack {

Text("Select Size")

.font(.subheadline)

.fontWeight(.semibold)

Spacer()

Button("Size Guide") {

// Present size guide sheet

}

.font(.caption)

.foregroundColor(DS.red)

}



ScrollView(.horizontal, showsIndicators: false) {

HStack(spacing: 10) {

ForEach(sizes, id: \.self) { size in

Button {

onSelect(size)

} label: {

Text(size.uppercased())

.font(.subheadline)

.fontWeight(.medium)

.frame(minWidth: 48, minHeight: 44)

.padding(.horizontal, 8)

.background(selected == size ? DS.red : DS.chipBG)

.foregroundColor(selected == size ? .white : DS.textPri)

.cornerRadius(10)

.overlay(

RoundedRectangle(cornerRadius: 10)

.stroke(selected == size ? DS.red : DS.border, lineWidth: 1.5)

)

}

.animation(.easeInOut(duration: 0.15), value: selected)

}

}

}

}

}

}



// MARK: - Description



struct DescriptionView: View {

let text: String

let isExpanded: Bool

let onToggle: () -> Void



var body: some View {

VStack(alignment: .leading, spacing: 12) {

Button(action: onToggle) {

HStack {

Text("Description")

.font(.subheadline)

.fontWeight(.semibold)

.foregroundColor(DS.textPri)

Spacer()

Image(systemName: isExpanded ? "chevron.up" : "chevron.down")

.font(.caption)

.foregroundColor(DS.textSec)

}

}



if isExpanded {

Text(text.isEmpty ? "No description available." : text)

.font(.subheadline)

.foregroundColor(DS.textSec)

.lineSpacing(5)

.transition(.opacity.combined(with: .move(edge: .top)))

}

}

.animation(.easeInOut(duration: 0.2), value: isExpanded)

}

}



// MARK: - Reviews



struct ReviewsView: View {
    let reviews: [ReviewEntity]
    let isSubmitting: Bool
    let message: String?
    let error: String?
    let onAddReview: () -> Void
    let onEditReview: (ReviewEntity) -> Void
    let onDeleteReview: (ReviewEntity) -> Void

    private var currentCustomerReview: ReviewEntity? {
        reviews.first(where: \.isOwnedByCurrentCustomer)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reviews")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(DS.textPri)

                    Text(reviews.isEmpty ? "Be the first to share feedback" : "\(reviews.count) customer \(reviews.count == 1 ? "review" : "reviews")")
                        .font(.caption)
                        .foregroundColor(DS.textSec)
                }

                Spacer()

                Button(action: onAddReview) {
                    Label(currentCustomerReview == nil ? "Add" : "Edit Mine", systemImage: currentCustomerReview == nil ? "plus" : "pencil")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(DS.red.opacity(0.12))
                        .foregroundColor(DS.red)
                        .clipShape(Capsule())
                }
                .disabled(isSubmitting)
            }

            if let message {
                ReviewStatusPill(text: message, systemImage: "checkmark.circle.fill", color: .green)
            }

            if let error {
                ReviewStatusPill(text: error, systemImage: "exclamationmark.circle.fill", color: DS.red)
            }

            if reviews.isEmpty {
                EmptyReviewView()
            } else {
                VStack(spacing: 12) {
                    ForEach(reviews, id: \.id) { review in
                        ReviewCardView(
                            review: review,
                            onEdit: { onEditReview(review) },
                            onDelete: { onDeleteReview(review) }
                        )
                    }
                }
            }
        }
    }
}

struct ReviewStatusPill: View {
    let text: String
    let systemImage: String
    let color: Color

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.caption)
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct EmptyReviewView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "quote.bubble")
                .font(.title3)
                .foregroundColor(DS.red)
                .frame(width: 42, height: 42)
                .background(DS.red.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("No reviews yet")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(DS.textPri)

                Text("Your feedback helps other shoppers choose with confidence.")
                    .font(.caption)
                    .foregroundColor(DS.textSec)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(DS.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DS.border, lineWidth: 1)
        )
    }
}

struct ReviewCardView: View {
    let review: ReviewEntity
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(review.authorInitials)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(DS.red.opacity(0.9))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(review.authorName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(DS.textPri)

                        if let createdAtText {
                            Text(createdAtText)
                                .font(.caption2)
                                .foregroundColor(DS.textSec)
                        }
                    }

                    Spacer()

                    StarRatingView(rating: review.rating)
                }

                if let title = review.title {
                    Text(title)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DS.textPri)
                }

                Text(review.body)
                    .font(.caption)
                    .foregroundColor(DS.textSec)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                if review.isOwnedByCurrentCustomer {
                    HStack(spacing: 14) {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }

                        Button(role: .destructive, action: onDelete) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .font(.caption.weight(.semibold))
                    .buttonStyle(.plain)
                    .foregroundColor(DS.red)
                    .padding(.top, 2)
                }
            }
        }
        .padding(14)
        .background(DS.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(DS.border.opacity(0.8), lineWidth: 1)
        )
    }

    private var createdAtText: String? {
        guard let date = review.createdAt else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct ReviewEditorView: View {
    let isEditing: Bool
    @Binding var rating: Int
    @Binding var title: String
    @Binding var reviewBody: String
    let isSubmitting: Bool
    let error: String?
    let onCancel: () -> Void
    let onSubmit: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {	
                    Text(LocalizedStringKey("Share the details another shopper would want to know."))
                        .font(.caption)
                        .foregroundColor(DS.textSec)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Rating")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(DS.textPri)

                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { value in
                            Button {
                                rating = value
                            } label: {
                                Image(systemName: value <= rating ? "star.fill" : "star")
                                    .font(.title3)
                                    .foregroundColor(.orange)
                                    .frame(width: 36, height: 36)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Title")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(DS.textPri)

                    TextField("What stood out?", text: $title)
                        .textInputAutocapitalization(.sentences)
                        .padding(12)
                        .background(DS.fieldBG)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Review")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(DS.textPri)

                    TextEditor(text: $reviewBody)
                        .frame(minHeight: 110)
                        .scrollContentBackground(.hidden)
                        .padding(8)
                        .background(DS.fieldBG)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                if let error {
                    ReviewStatusPill(text: error, systemImage: "exclamationmark.circle.fill", color: DS.red)
                }

                Spacer(minLength: 0)
            }
            .padding(20)
            .background(DS.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                        .disabled(isSubmitting)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSubmit()
                    } label: {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Text(LocalizedStringKey(isEditing ? "Save" : "Post"))
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isSubmitting)
                }
            }
            .navigationTitle(LocalizedStringKey(isEditing ? "Update your review" : "Add a review"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



// MARK: - Quantity Stepper



struct QuantityStepperView: View {

let quantity: Int

let onDecrement: () -> Void

let onIncrement: () -> Void



var body: some View {

HStack(spacing: 14) {

Button(action: onDecrement) {

Image(systemName: "minus")

.font(.system(size: 14, weight: .bold))

.foregroundColor(DS.textPri)

}



Text("\(quantity)")

.font(.subheadline)

.fontWeight(.semibold)
.foregroundColor(DS.textPri)

.frame(minWidth: 20)



Button(action: onIncrement) {

Image(systemName: "plus")

.font(.system(size: 14, weight: .bold))

.foregroundColor(DS.textPri)

}

}

.padding(.horizontal, 16)

.padding(.vertical, 14)

.background(DS.chipBG)

.cornerRadius(30)

}

}
