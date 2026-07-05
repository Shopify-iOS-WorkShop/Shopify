import SwiftUI



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

Color(.systemGray5)

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

.background(Color(.systemGray6))



// Page dots

HStack(spacing: 6) {

ForEach(0..<images.count, id: \.self) { i in

Circle()

.fill(i == currentIndex ? Color.primary : Color.secondary.opacity(0.4))

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

.foregroundColor(isFavorite ? .red : .red.opacity(0.5))

.frame(width: 38, height: 38)

.background(Color(.systemBackground))

.clipShape(RoundedRectangle(cornerRadius: 12))

.shadow(color: .black.opacity(0.08), radius: 4, y: 2)

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

.foregroundColor(.primary)

.frame(width: 38, height: 38)

.background(Color(.systemBackground))

.clipShape(RoundedRectangle(cornerRadius: 12))

.shadow(color: .black.opacity(0.08), radius: 4, y: 2)

}

}



private var placeholderImage: some View {

Rectangle()

.fill(Color(.systemGray5))

.overlay(

Image(systemName: "photo")

.foregroundColor(.secondary)

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



var body: some View {

VStack(alignment: .leading, spacing: 8) {

Text(collection.uppercased())

.font(.caption)

.fontWeight(.semibold)

.foregroundColor(.secondary)

.tracking(1.2)



Text(title)

.font(.title3)

.fontWeight(.bold)

.foregroundColor(.primary)



HStack(spacing: 6) {

StarRatingView(rating: rating)

Text("(\(reviewCount) Reviews)")

.font(.caption)

.foregroundColor(.secondary)

}



Text("$\(String(format: "%.2f", price))")

.font(.title)

.fontWeight(.bold)

.foregroundColor(.pink)

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

.foregroundColor(.pink)

}



HStack(spacing: 10) {

ForEach(sizes, id: \.self) { size in

Button {

onSelect(size)

} label: {

Text(size.uppercased())

.font(.subheadline)

.fontWeight(.medium)

.frame(width: 48, height: 44)

.background(selected == size ? Color.pink : Color(.systemGray6))

.foregroundColor(selected == size ? .white : .primary)

.cornerRadius(10)

.overlay(

RoundedRectangle(cornerRadius: 10)

.stroke(selected == size ? Color.pink : Color.clear, lineWidth: 1.5)

)

}

.animation(.easeInOut(duration: 0.15), value: selected)

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

.foregroundColor(.primary)

Spacer()

Image(systemName: isExpanded ? "chevron.up" : "chevron.down")

.font(.caption)

.foregroundColor(.secondary)

}

}



if isExpanded {

Text(text.isEmpty ? "No description available." : text)

.font(.subheadline)

.foregroundColor(.secondary)

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



var body: some View {

VStack(alignment: .leading, spacing: 16) {

HStack {

Text("Reviews")

.font(.subheadline)

.fontWeight(.semibold)

Spacer()

Button("View All") {

// Navigate to all reviews

}

.font(.caption)

.foregroundColor(.pink)

}



ForEach(reviews, id: \.id) { review in

ReviewCardView(review: review)

}

}

}

}



struct ReviewCardView: View {

let review: ReviewEntity



var body: some View {

HStack(alignment: .top, spacing: 12) {

// Avatar

Text(review.authorInitials)

.font(.caption)

.fontWeight(.bold)

.foregroundColor(.white)

.frame(width: 36, height: 36)

.background(Color.pink.opacity(0.8))

.clipShape(Circle())



VStack(alignment: .leading, spacing: 4) {

HStack {

Text(review.authorName)

.font(.subheadline)

.fontWeight(.semibold)

Spacer()

StarRatingView(rating: review.rating)

}

Text(review.body)

.font(.caption)

.foregroundColor(.secondary)

.lineSpacing(4)

.lineLimit(2)

}

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

.foregroundColor(.primary)

}



Text("\(quantity)")

.font(.subheadline)

.fontWeight(.semibold)

.frame(minWidth: 20)



Button(action: onIncrement) {

Image(systemName: "plus")

.font(.system(size: 14, weight: .bold))

.foregroundColor(.primary)

}

}

.padding(.horizontal, 16)

.padding(.vertical, 14)

.background(Color(.systemGray6))

.cornerRadius(30)

}

}
