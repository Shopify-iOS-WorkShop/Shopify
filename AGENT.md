# Shopify Cart Tech Lead Plan

This file is the local working agreement for the Shopify repo. It is a developer guide, not a product artifact.

## 1. Role And Scope

- Act like a tech lead for the Cart module.
- Keep the implementation modular, predictable, and easy to extend for future project-spec features.
- Work in small sprints with one commit per layer or concern whenever practical.
- Do not mix unrelated refactors into a sprint commit.
- Keep the current branch-based workflow unless the user explicitly asks for a new branch strategy.

## 2. Branch Strategy

Requested flow:

1. `master` is fetched and kept up to date.
2. Create `feature/cart` from the latest `master`.
3. Push `feature/cart` to origin.
4. Create Cart task branches from the Cart feature baseline, such as:
   - `task/cart-domain`
   - `task/cart-data`
   - `task/cart-presentation`
   - `task/cart-router`
   - `task/cart-tests`
5. Keep working on the existing branch when the user asks for in-place work.

Branch rules:

- Do not create extra branches without approval.
- Do not rename branches without request.
- If a Cart branch already exists and the user wants to continue on it, stay on that branch.
- If the branch is behind `master`, fetch and fast-forward before starting a new Cart sprint.

## 3. Architecture Rules

Follow Clean Architecture:

- Domain owns entities, value objects, repository interfaces, and use cases.
- Data owns API/SDK integrations, DTOs, remote data sources, and repository implementations.
- Presentation owns MVVM state, view rendering, and lightweight routing glue.
- App composition owns dependency creation, feature entry wiring, and cross-feature navigation.

Follow SOLID:

- Single Responsibility: each file should do one thing.
- Open/Closed: extend Cart behavior through new types, not by bloating existing ones.
- Liskov: repository implementations must satisfy domain contracts cleanly.
- Interface Segregation: keep repository contracts focused and small.
- Dependency Inversion: domain should depend on abstractions, not Firebase, Shopify SDKs, or UI types.

Use design patterns intentionally:

- Repository for data access.
- Factory or composition root for dependency creation.
- Router or coordinator layer for navigation concerns.
- Mapper for DTO to domain conversion.

## 4. Presentation Rule

Use MVVM in presentation, with a router-inspired layer from VIPER when navigation is non-trivial.

Rules:

- View renders state and forwards user actions.
- ViewModel owns validation, loading state, and business interaction.
- Router handles route decisions and navigation triggers.
- Do not let the ViewModel directly own UIKit navigation.
- Do not let the View decide business rules.

## 5. Cart Module Rules

Cart lives under `Modules/Cart`.

Cart behavior must support:

- add item
- remove item
- update quantity
- calculate totals dynamically
- validate stock before incrementing
- confirm destructive actions before delete/clear
- authenticated-only access if required by the spec

Cart implementation should be split by layer:

- Domain
- Data
- Presentation
- Router
- Tests

## 6. Network Rules

This is important and must stay stable:

- Keep the existing `Network` module name where that name already exists in the project history or Xcode setup.
- Put actual networking functionality in `shopify-network`.
- Do not rename `Network` to `shopify-network` unless the team explicitly asks for a rename.
- Do not duplicate request/response logic inside feature modules.
- If Cart needs new networking behavior, add it to `shopify-network` first, then consume it from Cart.
- Feature modules should treat `shopify-network` as the reusable networking implementation.

## 7. Cart Sprint Commit Plan

Use one commit per sprint whenever possible.

Recommended Cart sprint order:

1. Scaffold Cart package.
2. Add Cart domain entities.
3. Add Cart repository interfaces.
4. Add Cart use cases.
5. Add Cart data sources and DTOs.
6. Add Cart repository implementation.
7. Add Cart presentation view models.
8. Add Cart router or coordinator layer.
9. Wire Cart into app composition.
10. Add Cart tests.

Example commit messages:

- `Scaffold Cart package`
- `Add Cart domain entities`
- `Add Cart repository interfaces`
- `Add Cart use cases`
- `Add Cart data layer`
- `Add Cart presentation router`
- `Wire Cart into app composition`
- `Add Cart tests`

## 8. API Direction

Use the provided Shopify collections and project spec as the source of truth.

Preferred direction for Cart:

- If the team wants the most app-friendly route, implement Cart on Storefront GraphQL.
- If the mentor requires Admin REST parity, keep REST behind the same repository interface.
- Use the same interface so the presentation layer does not care which backend is active.

Cart data should support these concepts:

- cart creation
- fetch current cart
- add line
- update line quantity
- remove line
- update discount codes if needed later
- totals and stock validation

## 9. App Composition Rules

The Shopify app target owns:

- Firebase configuration
- URL callback handling
- navigation between login and registration
- navigation into Cart and other app screens
- dependency injection wiring

Keep app-level concerns out of feature packages.

## 10. File And Commit Hygiene

Keep out of commits unless explicitly required:

- `.DS_Store`
- `xcuserdata`
- `*.xcuserstate`
- SwiftPM build output
- local secrets and generated files

If a change touches networking, update `shopify-network` first.
If a change touches navigation or app lifecycle, update the app target first.

## 11. Working Checklist

Before each Cart sprint:

1. Fetch latest origin.
2. Check the current branch.
3. Inspect existing Cart files.
4. Implement one layer only.
5. Run the smallest useful verification.
6. Commit that sprint.

## 12. Current Intent

The current goal is to build Cart so future spec features can plug in without reworking the module structure.

That means:

- stable domain contracts
- predictable data abstraction
- clean MVVM presentation
- router layer for navigation
- no random architecture drift
- no network-module rename

