import SwiftUI


public struct ChatView: View {

    let agent: ShoppingAssistantAgent
    let onProductSelected: ((ShopifyProduct) -> Void)?
    private static let typingIndicatorID = "typing"

    @State private var messages: [AIMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    @State private var error: String?
    @FocusState private var inputFocused: Bool

    public init(agent: ShoppingAssistantAgent, onProductSelected: ((ShopifyProduct) -> Void)? = nil) {
        self.agent = agent
        self.onProductSelected = onProductSelected
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        if messages.isEmpty {
                            emptyState
                        }
                        ForEach(messages) { message in
                            MessageBubble(message: message, onProductSelected: onProductSelected)
                                .id(message.id)
                        }
                        if isLoading {
                            TypingIndicator()
                                .id(Self.typingIndicatorID)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        if let lastMessageID = messages.last?.id {
                            proxy.scrollTo(lastMessageID, anchor: .bottom)
                        } else {
                            proxy.scrollTo(Self.typingIndicatorID, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isLoading) { loading in
                    if loading {
                        withAnimation { proxy.scrollTo(Self.typingIndicatorID, anchor: .bottom) }
                    }
                }
            }

            if let error {
                ErrorBanner(message: error) { self.error = nil }
            }

            Divider()

            inputBar
        }
        .background(DS.background)
    }


    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 44))
                .foregroundColor(DS.red.opacity(0.5))
            Text("AI Shopping Assistant")
                .font(.title3).bold()
            Text("Ask me anything about our products.\nTry: \"What jackets do you have under $80?\"")
                .font(.subheadline)
                .foregroundColor(DS.textSec)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(["Show me your best sellers", "I need a gift for a teenager", "What's new in stock?"], id: \.self) { prompt in
                    Button {
                        inputText = prompt
                        send()
                    } label: {
                        Text(prompt)
                            .font(.caption)
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .background(DS.red.opacity(0.1))
                            .foregroundColor(DS.red)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask about products...", text: $inputText, axis: .vertical)
                .lineLimit(1...4)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(DS.cardBG)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused($inputFocused)
                .onSubmit { send() }

            Button(action: send) {
                Image(systemName: isLoading ? "stop.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty && !isLoading ? DS.textSec : DS.red)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty && !isLoading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(DS.cardBG)
    }


    private func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        error = nil

        let userMsg = AIMessage(role: .user, content: text)
        messages.append(userMsg)
        isLoading = true

        Task {
            do {
                let reply = try await agent.respond(to: text, history: messages)
                await MainActor.run {
                    messages.append(reply)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}


private struct MessageBubble: View {
    let message: AIMessage
    let onProductSelected: ((ShopifyProduct) -> Void)?

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 60) }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isUser ? DS.red : DS.cardBG)
                    .foregroundColor(isUser ? .white : DS.textPri)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                // Attached products chips
                if !message.attachedProducts.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(message.attachedProducts) { product in
                                ProductChip(product: product, onProductSelected: onProductSelected)
                            }
                        }
                    }
                }
            }

            if !isUser { Spacer(minLength: 60) }
        }
    }
}


private struct ProductChip: View {
    let product: ShopifyProduct
    let onProductSelected: ((ShopifyProduct) -> Void)?

    var body: some View {
        Button {
            onProductSelected?(product)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                if let imageURL = product.firstImageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .empty:
                            ProgressView()
                        case .failure:
                            DS.fieldBG
                        @unknown default:
                            DS.fieldBG
                        }
                    }
                    .frame(width: 132, height: 112)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(product.title)
                        .font(.caption).bold()
                        .foregroundColor(DS.textPri)
                        .lineLimit(2)
                    Text(product.minPrice)
                        .font(.caption2)
                        .foregroundColor(DS.red)
                }
                .frame(width: 132, alignment: .leading)
            }
            .padding(8)
            .background(DS.fieldBG)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(DS.red.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .disabled(onProductSelected == nil)
    }
}


private struct TypingIndicator: View {
    @State private var phase: Int = 0
    let timer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(DS.textSec)
                    .scaleEffect(phase == i ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: phase)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(DS.cardBG)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onReceive(timer) { _ in
            phase = (phase + 1) % 3
        }
    }
}


private struct ErrorBanner: View {
    let message: String
    let dismiss: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
            Text(message).font(.caption).foregroundColor(DS.textPri)
            Spacer()
            Button(action: dismiss) { Image(systemName: "xmark").foregroundColor(DS.textSec) }
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(Color.orange.opacity(0.1))
    }
}
