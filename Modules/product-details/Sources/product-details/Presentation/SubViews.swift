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

.foregroundColor(DS.red)

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

.background(DS.red.opacity(0.9))

.clipShape(Circle())



VStack(alignment: .leading, spacing: 4) {

HStack {

Text(review.authorName)

.font(.subheadline)

.fontWeight(.semibold)
.foregroundColor(DS.textPri)

Spacer()

StarRatingView(rating: review.rating)

}

Text(review.body)

.font(.caption)

.foregroundColor(DS.textSec)

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
