# Layers/Agent.md — Agent Layer Architecture

## What Is the Agent Layer?

The Agent Layer is the intelligence core of the AIAssistant module.
It sits between the data services (Shopify, Gemini) and the UI layer,
orchestrating how each AI feature fetches data, builds prompts, calls AI,
and validates responses.

---

## Layer Stack

```
┌──────────────────────────────────────────────────────┐
│                     UI Layer                         │
│   ChatView · ComparisonView · ImageSearchView        │
│   OutfitGeneratorView · AIAssistantCoordinator       │
└──────────────────────┬───────────────────────────────┘
                       │  Swift async/await calls
┌──────────────────────▼───────────────────────────────┐
│                   Agent Layer                        │  ← YOU ARE HERE
│                                                      │
│   ShoppingAssistantAgent                             │
│   ProductComparisonAgent                             │
│   ImageSearchAgent                                   │
│   OutfitGeneratorAgent                               │
│                                                      │
│   Every agent:                                       │
│   1. Reads Agents.md (via AgentValidator)            │
│   2. Fetches live data (via ShopifyService)          │
│   3. Builds a grounded prompt                        │
│   4. Calls Gemini (via GeminiService)                │
│   5. Validates response (via AgentValidator)         │
│   6. Returns typed result to the UI                  │
└──────────────────────┬───────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────┐
│                  Service Layer                       │
│                                                      │
│   ShopifyService  ← Shopify Storefront GraphQL API   │
│   GeminiService   ← Google Gemini REST API           │
│   AgentValidator  ← Agents.md rules enforcement      │
└──────────────────────────────────────────────────────┘
```

---

## Agent Protocol

All agents conform to the `AIAgent` protocol:

```swift
public protocol AIAgent: Sendable {
    var agentType: AgentType { get }
    var config: AIAssistantConfig { get }
}
```

Extension methods on `AIAgent` provide shared helpers:

| Helper | Purpose |
|---|---|
| `buildPrompt(context:instruction:)` | Assembles full Gemini prompt with rules + catalog + history |
| `validated(_:validator:)` | Runs AgentValidator, returns cleaned response |

---

## Agent Lifecycle (per request)

```
1. UI calls agent method (e.g. respond(to:history:))
      │
2. Agent requests Agents.md from AgentValidator
   AgentValidator.loadAgentRules() → String (cached after first load)
      │
3. Agent calls ShopifyService to fetch live product data
   ShopifyService.fetchProducts(query:) → [ShopifyProduct]
      │
4. Agent assembles AgentContext
   AgentContext(products:history:userQuery:agentRules:imageData:)
      │
5. Agent calls buildPrompt(context:instruction:)
   → Full prompt string: system rules + catalog + conversation + instruction
      │
6. Agent calls GeminiService
   GeminiService.generate(prompt:) or .converse(history:newMessage:systemPrompt:)
   → Raw String response from Gemini
      │
7. Agent calls AgentValidator.validate(response:agentType:)
   → ValidationResult(isValid:cleanedResponse:violations:)
      │
8. Agent constructs typed return value (AIMessage, ComparisonResult, etc.)
   Attaches matched Shopify products where applicable
      │
9. Returns to UI → @State update → SwiftUI re-renders
```

---

## Agentic (RAG) Pattern

The module uses **Retrieval-Augmented Generation (RAG)**:

```
[User query]
    │
    ▼
[Keyword extraction]
    │
    ▼
[Shopify Storefront API — live product fetch]
    │
    ▼
[Product catalog injected into Gemini prompt]
    │
    ▼
[Gemini generates response grounded in real products]
    │
    ▼
[AgentValidator checks for hallucination / rule violations]
    │
    ▼
[Grounded, validated response returned to user]
```

This means:
- Responses are always based on **what's actually in the store right now**
- No hallucinated products, prices, or availability
- Catalog changes in Shopify are reflected immediately without redeploying the app

---

## Agent Responsibilities

### ShoppingAssistantAgent
- **Input:** Natural-language question + conversation history
- **Shopify fetch:** Products matching extracted keywords
- **Gemini call:** Multi-turn conversation (`.converse`)
- **Output:** `AIMessage` with content + `attachedProducts`

### ProductComparisonAgent
- **Input:** Natural-language comparison query OR two product IDs
- **Shopify fetch:** Full product catalog (to let Gemini identify best match)
- **Gemini calls:** 2 — one to identify products, one to compare them
- **Output:** `ComparisonResult` with summary, dimension scores, recommendation

### ImageSearchAgent
- **Input:** Image `Data` (JPEG/PNG) + optional text hint
- **Shopify fetch:** Products matching keywords extracted from image description
- **Gemini calls:** 2 — vision call (describe image), text call (rank matches)
- **Output:** `ImageSearchResult` with matched products, summary, confidence

### OutfitGeneratorAgent
- **Input:** Occasion string + optional preference text
- **Shopify fetch:** Products by clothing type (T-Shirt, Jacket, Pants, etc.)
- **Gemini call:** Single call requesting 3 complete outfit suggestions
- **Output:** `[OutfitSuggestion]` — each with title, products, description, style notes

---

## AgentValidator — Rules Enforcement

```swift
actor AgentValidator {
    func loadAgentRules() -> String          // Load Agents.md (cached)
    func validate(response:agentType:)       // Check response against rules
    func systemPromptBlock(for:)             // Build system prompt from Agents.md
}
```

**What it checks (from Agents.md):**
- Response is not empty
- No forbidden phrases (system prompt leakage)
- Fashion context present in outfit responses
- Response is sanitised (no accidental code fence wrapping)

**What it logs:**
- Number of rules checked
- Any rule violations (surfaced in `ValidationResult.violations`)

---

## Adding a New Agent

1. Create `Sources/AIAssistant/Agents/MyNewAgent.swift`
2. Declare as `public actor MyNewAgent: AIAgent`
3. Add `agentType: AgentType = .myNewFeature`
4. Add the new case to `AgentType` enum in `AgentValidator.swift`
5. Add rules for the new agent in `Agents.md` → Section 6
6. Wire up in `AIAssistantKit.swift` and `AIAssistantCoordinator.swift`
7. Create the UI view in `Sources/AIAssistant/UI/MyNewFeature/`

---

## Thread Safety

All agents and services are Swift `actor` types.
They can be called concurrently from SwiftUI `Task {}` blocks without data races.
The `@MainActor` annotation on `AIAssistantKit` ensures the shared instance
and lazy properties are only accessed from the main thread.

---

## Error Handling

All public agent methods throw `AIAssistantError`:

| Error | When thrown |
|---|---|
| `.shopifyError(String)` | Shopify GraphQL HTTP error or parsing failure |
| `.geminiError(String)` | Gemini API HTTP error or response parsing failure |
| `.validationFailed([String])` | AgentValidator detects critical violations |
| `.noProductsFound` | Shopify returns 0 products for the query |
| `.imageTooLarge` | Image data exceeds 4 MB (Gemini inline limit) |
| `.networkUnavailable` | URLSession connection error |

UI layers should always catch these and display an `ErrorBanner`
rather than crashing or showing empty state silently.

---

*This file documents the Agent Layer architecture.
Keep it updated when adding agents or changing the pipeline.*
