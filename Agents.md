# AI Assistant Module Instructions (Agents.md)

This file serves as a reference and instruction guide for AI agents working on the `AIAssistant` module within the Shopify iOS project. When prompted to modify or extend the AI features, refer to this document for architectural and implementation details.

## Overview
The `AIAssistant` is a Swift Package Manager (SPM) module implementing Clean Architecture (Data, Domain, Presentation layers). It integrates Google's Gemini SDK (`GoogleGenerativeAI`) to provide AI-driven features using real Storefront GraphQL data.

## Features
1. **AI Shopping Assistant (Smart Chat)**
2. **AI Product Comparison**
3. **AI Image Search**
4. **AI Outfit Generator**

## Architecture Details
### 1. Data Layer (`AIAgent.swift`)
- Responsible for initializing the Gemini model using the provided API key.
- Implements Gemini **Function Calling (Tools)** to query the database (Shopify Storefront API).
- Instead of returning generic answers, the AI invokes GraphQL queries like `SearchProductsQuery` via `GraphQLClient.shared.fetch()`.

### 2. Domain Layer (`AIFeatures.swift`)
- Defines UseCases for the four AI features.
- Constructs the specific prompt templates and handles the bridging between the Presentation layer and the `AIAgent`.

### 3. Presentation Layer (`AIAssistantView` & `AIAssistantViewModel`)
- SwiftUI views that display chat interfaces, image pickers, and product comparison layouts.
- ViewModels handle state management and call the Domain UseCases.

## Extending the AI (Agentic Workflow)
When adding new capabilities:
1. Define a new `FunctionDeclaration` in the `AIAgent` tools list.
2. Implement the corresponding `GraphQLClient` call to fetch real Shopify data.
3. Map the data back into a `JSONObject` and return it to the model.
4. Ensure all new logic follows the Clean Architecture pattern established in this module.

## Git Workflow Standard
- Main development occurs in `feature/ai-integration`.
- Work is broken into smaller `task/` branches (e.g., `task/ai-data-layer`).
- Pull Requests are opened from `task/` to `feature/` on GitHub, then merged by the user.
- After a merge, pull `origin feature/ai-integration` before branching out for the next task.
