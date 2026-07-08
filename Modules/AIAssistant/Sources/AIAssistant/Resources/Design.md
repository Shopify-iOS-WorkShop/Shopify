# Design.md — AIAssistant Module Design Specification

## Overview

The AIAssistant module provides four AI-powered shopping features for the Shopify iOS app.
Each feature is a SwiftUI view backed by an agentic pipeline:
**Shopify Storefront GraphQL → Gemini AI → AgentValidator → UI**.

---

## Architecture Diagram

```
User Input (text / image)
        │
        ▼
┌───────────────────────────────────┐
│         AIAssistantCoordinator    │  ← Root SwiftUI view (tab bar)
└──────┬────────┬────────┬──────────┘
       │        │        │        │
  ChatView  CompareView ImageView OutfitView
       │        │        │        │
       └────────┴────────┴────────┘
                │
        Agent Layer (Swift actors)
                │
        ┌───────┴────────┐
        │                │
  ShopifyService    GeminiService
  (GraphQL fetch)  (AI generation)
        │                │
        └───────┬────────┘
                │
        AgentValidator
        (reads Agents.md, validates output)
                │
        Validated Response → UI
```

---

## Module Structure

```
AIAssistant/
├── Sources/AIAssistant/
│   ├── AIAssistantKit.swift          ← Public entry point + shared instance
│   ├── Configuration/
│   │   └── AIAssistantConfig.swift   ← API keys, URLs, feature flags
│   ├── Models/
│   │   ├── Product.swift             ← Shopify product data models
│   │   ├── AIMessage.swift           ← Chat messages, search/outfit results
│   │   └── AgentContext.swift        ← Prompt context container
│   ├── Services/
│   │   ├── ShopifyService.swift      ← Storefront GraphQL actor
│   │   ├── GeminiService.swift       ← Gemini REST actor
│   │   ├── AgentValidator.swift      ← Agents.md loader + response checker
│   │   └── AIAssistantError.swift    ← Typed errors
│   ├── Agents/
│   │   ├── BaseAgent.swift           ← Shared protocol + helpers
│   │   ├── ShoppingAssistantAgent.swift
│   │   ├── ProductComparisonAgent.swift
│   │   ├── ImageSearchAgent.swift
│   │   └── OutfitGeneratorAgent.swift
│   ├── UI/
│   │   ├── AIAssistantCoordinator.swift  ← Root view with tab bar
│   │   ├── Chat/ChatView.swift
│   │   ├── Comparison/ProductComparisonView.swift
│   │   ├── ImageSearch/ImageSearchView.swift
│   │   └── OutfitGenerator/OutfitGeneratorView.swift
│   └── Resources/
│       ├── Agents.md                 ← Agent behaviour rules (loaded at runtime)
│       ├── Design.md                 ← This file
│       └── Layers/
│           └── Agent.md             ← Layer architecture detail
└── Tests/AIAssistantTests/
    └── AIAssistantTests.swift
```

---

## Design Principles

### 1. Agentic (RAG) Pattern
Every AI response is grounded in live data:
1. Fetch products from Shopify Storefront API
2. Inject product catalog into Gemini prompt
3. Validate response against Agents.md rules
4. Return only grounded, validated output

### 2. Actor-Based Concurrency
All services (`ShopifyService`, `GeminiService`, `AgentValidator`) and agents
are Swift `actor` types — thread-safe by design, no manual locking needed.

### 3. Single Source of Truth for Rules
`Agents.md` is the **only** place where agent behaviour is defined.
`AgentValidator` loads it at runtime (with caching) and injects it into
every Gemini prompt. Updating `Agents.md` changes all four agents simultaneously.

### 4. Zero Hallucination Policy
Agents are only allowed to recommend products that exist in the live Shopify catalog.
This is enforced by:
- Injecting the full product list into every prompt
- Instructing Gemini to only use catalog products
- Post-hoc validation in `AgentValidator`

---

## UI Design System

### Colour Tokens
| Token | Value | Usage |
|---|---|---|
| Primary | `.indigo` | Buttons, active tabs, accents |
| Background | `.systemGroupedBackground` | Screen backgrounds |
| Card | `.secondarySystemGroupedBackground` | Cards, input fields |
| Tertiary | `.tertiarySystemGroupedBackground` | Nested rows |
| Danger | `.orange` | Error banners |
| Success | `.green` | Match confirmations |

### Typography
- Screen headings: `.title3 + .bold`
- Card titles: `.subheadline + .bold`
- Body copy: `.subheadline`
- Metadata / chips: `.caption` / `.caption2`

### Spacing
- Screen padding: `16pt` horizontal
- Card corner radius: `14pt`
- Chip corner radius: `Capsule()`
- Card internal padding: `12–16pt`

### Interaction Patterns
- Loading: `ProgressView` with descriptive label
- Errors: Orange banner with dismiss + retry
- Empty states: Icon + headline + example prompts
- Tab selection: Capsule pill tabs (scrollable horizontal)

---

## Integration with Existing App

### Minimum integration (one line):
```swift
// In any SwiftUI view:
NavigationLink("AI Assistant") { AIAssistantCoordinator() }
```

### With custom config:
```swift
// In App.swift:
AIAssistantKit.configure(with: AIAssistantConfig(
    geminiAPIKey: "YOUR_KEY",
    shopifyHostname: "mad46-ios-team5.myshopify.com",
    storefrontAccessToken: "8842c04427c5f8a6e967f204266cd8bf"
))
```

### Open a specific feature:
```swift
AIAssistantCoordinator(initialFeature: .outfitGenerator)
```

---

## Data Flow per Feature

### Smart Chat
```
User message → keyword extract → ShopifyService.fetchProducts(query:)
→ AgentContext(products, history) → Gemini.converse()
→ AgentValidator.validate() → AIMessage(content, attachedProducts)
```

### Product Comparison
```
User query → ShopifyService.fetchProducts() → Gemini identifies 2 products
→ Gemini structured comparison → AgentValidator → ComparisonResult
```

### Image Search
```
Image data → Gemini vision (describe image) → extract keywords
→ ShopifyService.fetchProducts(query: keyword) → Gemini ranks matches
→ AgentValidator → ImageSearchResult(matchedProducts, summary, confidence)
```

### Outfit Generator
```
Occasion → ShopifyService.fetchProductsByType(clothingTypes)
→ Gemini compose 3 outfits from catalog → AgentValidator
→ [OutfitSuggestion] with titles, products, style notes
```

---

## Extending the Module

### Add a new AI feature:
1. Create a new `Actor` in `Agents/` conforming to `AIAgent`
2. Add a new SwiftUI view in `UI/`
3. Add the feature case to `AIFeature` enum in `AIAssistantKit.swift`
4. Add rules for it in `Agents.md` under section 6
5. Add a `case` to `AIAssistantCoordinator.featureContent`

### Change AI behaviour without touching code:
- Edit `Agents.md` — changes apply on next app launch (rules are cached per session)

---

*Generated by AIAssistant module — Shopify iOS Workshop*
