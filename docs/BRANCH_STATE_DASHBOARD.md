# Shopify iOS Branch State Dashboard

Generated: 2026-06-29

## Project Context

Repository: `https://github.com/Shopify-iOS-WorkShop/Shopify`

Storefront: `mad46-ios-team5.myshopify.com`

Design: `https://www.figma.com/design/z1qmoKAndo85Z5XxnQJ9Ty/Untitled?node-id=0-1&t=5ZawGFMkH665Hhne-1`

Architecture direction:

- The app is modular. Each major feature should live as a Swift Package under `Modules/`.
- Feature packages should follow Clean Architecture boundaries: `Data`, `Domain`, and `Presentation`.
- Presentation should follow MVVM: SwiftUI view + observable view model + injected use cases.
- The Shopify app target should compose packages, configure app-level services, and own navigation.

Important security note:

- Do not commit Shopify Admin API tokens, API secrets, Storefront tokens, Firebase secrets, or Postman environment files containing credentials.
- The REST Postman collection currently contains live credential values. Rotate exposed credentials from Shopify Admin and replace committed/shared values with placeholders or secure environment variables.

## Requirement Sources Reviewed

- `Shopify Project Specs.pdf`
- `Shopify_JETS_Required_Endpoints.json`
- `MAD46_Shopify_Storefront_GraphQL.postman_collection.json`
- Current local repository and refreshed `origin/*` branches

Core feature scope from the specs:

- Auth and identity: registration, email/password auth, social auth, verification email, guest browsing, access control for cart/wishlist.
- Product catalog: products, vendors/brands, categories, product details, images, sizes/variants, price, reviews/ratings.
- Search/filter/sort: global search, main categories, sub-categories, brands, price, best seller.
- Wishlist/cart: authenticated-only wishlist and cart, stock validation, quantity changes, dynamic totals.
- Account/localization: profile, orders, wishlist preview, addresses, countries, exchange rates.
- Checkout/payment: coupon validation, COD with upper limit, online payment, order confirmation.
- Destructive actions must show explicit confirmation before execution.

## Team Ownership

| Member | Area | Branches / Scope |
| --- | --- | --- |
| Mazen | Home module | `feature/home`, `feature/home-ui`, `feature/home-logic` |
| Mina | Product details module | `feature/productDetails` |
| Mahmoud | Login + Common module | `task/common-onboarding`, `task/common-auth_ui`, login work expected under auth/common |
| Ahmed / current user | Registration + Guest mode | `task/auth-registration`, `feature/auth` integration |

## Remote Branch Inventory

| Remote branch | Latest commit | State |
| --- | --- | --- |
| `origin/master` | `f0377aa` Changed Network Module to ShopifyNetwork | Main integration branch. Same commit as `origin/network` and `origin/feature/home`. |
| `origin/network` | `f0377aa` Changed Network Module to ShopifyNetwork | Network module branch already aligned with `master`. |
| `origin/feature/auth` | `c3be707` Merge PR #6 from `task/auth-registration` | Auth integration branch. Ahead of `master` by 24 commits. |
| `origin/task/auth-domain` | `c432abe` add usersession entity and continueasguestusecase | Already merged into `feature/auth`; no longer ahead of `feature/auth`. |
| `origin/task/auth-data` | `285583a` finish auth data task | Already merged into `feature/auth`; no longer ahead of `feature/auth`. |
| `origin/task/auth-registration` | `dbd4334` feat: Add Registration ViewModel and View | Already merged into `feature/auth`; `feature/auth` has 1 merge commit beyond it. Local branch has additional uncommitted fixes. |
| `origin/feature/common` | `9ea4fc3` Merge PR #5 from `task/common-auth_ui` | Common integration branch. Ahead of `master` by 11 commits. |
| `origin/task/common-onboarding` | `c2bc2f5` Add paged onboarding flow | Already merged into `feature/common`; no longer ahead of `feature/common`. |
| `origin/task/common-auth_ui` | `3192012` added SocialLoginRow & SocialButton | Already merged into `feature/common`; `feature/common` has 1 merge commit beyond it. |
| `origin/feature/home` | `f0377aa` Changed Network Module to ShopifyNetwork | Currently identical to `master`; likely integration placeholder. |
| `origin/feature/home-ui` | `ecc8d83` Created Module | Ahead of `master` by 4 commits, but behind `feature/home-logic` by 4 commits. |
| `origin/feature/home-logic` | `42c8c66` ignored shopify config and system files | Ahead of `master` by 8 commits. Appears to include home UI + domain/data/logic work. |
| `origin/feature/productDetails` | `5c014bb` Initial Commit | Behind `master` by 2 commits and not ahead. Needs rebase/merge from `master` before real feature work continues. |

## Branch Relationship Summary

| Comparison | Result |
| --- | --- |
| `origin/master...origin/feature/auth` | `feature/auth` is 24 commits ahead, 0 behind. |
| `origin/feature/auth...origin/task/auth-registration` | registration task is merged; task is 0 ahead, `feature/auth` has 1 merge commit beyond it. |
| `origin/feature/auth...origin/task/auth-data` | auth-data task is merged; task is 0 ahead. |
| `origin/feature/auth...origin/task/auth-domain` | auth-domain task is merged; task is 0 ahead. |
| `origin/master...origin/feature/common` | `feature/common` is 11 commits ahead, 0 behind. |
| `origin/feature/common...origin/task/common-auth_ui` | common auth UI task is merged; task is 0 ahead. |
| `origin/feature/common...origin/task/common-onboarding` | onboarding task is merged; task is 0 ahead. |
| `origin/master...origin/feature/home-logic` | `feature/home-logic` is 8 commits ahead, 0 behind. |
| `origin/feature/home-logic...origin/feature/home-ui` | home UI is contained in home logic; home UI is 0 ahead and 4 commits behind. |
| `origin/master...origin/feature/productDetails` | product details is 0 ahead and 2 commits behind. |

## Current Local Working State

Current branch: `task/auth-registration`

Tracking: `origin/task/auth-registration`

Local state: dirty working tree with uncommitted auth/common/app integration changes.

Changed areas:

- `Modules/Auth/Package.swift`
- `Modules/Auth/Sources/Auth/Auth.swift`
- `Modules/Auth/Sources/Auth/Data/Repositories/AuthRepository.swift`
- `Modules/Auth/Sources/Auth/Data/DataSources/GoogleSignInDataSource.swift`
- `Modules/Auth/Sources/Auth/Presentation/Registration/RegistrationView.swift`
- `Modules/Auth/Sources/Auth/Presentation/Registration/RegistrationViewModel.swift`
- `Modules/Common/Package.swift`
- `Modules/Common/Sources/Common/presentaion/Auth/*`
- `Shopify/ShopifyApp.swift`
- `Shopify.xcodeproj/project.pbxproj`
- Generated local SwiftPM/Xcode files are also present and should be reviewed before commit.

## Auth Module State

Current structure:

```text
Modules/Auth/Sources/Auth
├── Data
│   ├── DataSources
│   │   ├── FirebaseAuthDataSource.swift
│   │   └── GoogleSignInDataSource.swift
│   └── Repositories
│       └── AuthRepository.swift
├── Domain
│   ├── Entities
│   │   ├── AuthUser.swift
│   │   └── UserSession.swift
│   ├── Interfaces
│   │   └── AuthRepositoryInterface.swift
│   └── UseCases
│       ├── ContinueAsGuestUseCase.swift
│       ├── GoogleSignInUseCase.swift
│       ├── LoginUseCase.swift
│       └── RegisterUseCase.swift
└── Presentation
    └── Registration
        ├── RegistrationView.swift
        └── RegistrationViewModel.swift
```

Completed / now aligned:

- Registration VM validates first name, last name, email, password length, and password confirmation.
- Registration calls `RegisterUseCase`, which creates Firebase user and sends verification email.
- Google sign-in path exists through `GoogleSignInUseCase`.
- Guest mode returns a `UserSession.guest` and exposes the active session to the app.
- `Auth` package now declares a local dependency on `Common` because registration UI uses Common auth components.
- Common auth UI components are public so feature packages can use them.
- Firebase app configuration is owned by `ShopifyApp`, not by the Auth package.
- Unit tests now cover registration form validation, password mismatch behavior, and guest session activation.

Remaining auth integration tasks:

- Add real navigation callbacks for successful registration, login, and guest entry in the Shopify app target.
- Add login presentation branch/work and wire it into the same auth package.
- Decide where authenticated/guest session state is stored globally: app coordinator, session store, or dependency container.
- Enforce access control: guest users can browse products/categories but must be blocked or prompted before wishlist/cart.
- Add tests for `RegistrationViewModel` validation and guest mode session behavior.

## API Integration Direction

REST collection:

- Uses Shopify Admin REST API endpoints.
- Covers customer creation/search, products, variants, collections, wishlist via metafields, cart via draft orders, account, addresses, countries, discounts, checkout/order completion.
- Contains live credentials and should be sanitized before sharing or committing.

GraphQL collection:

- Uses Storefront GraphQL API endpoint `/api/{version}/graphql.json`.
- Better fit for app-facing catalog, product details, search, collections, customer account, cart, discounts, and orders.
- Requires a Storefront access token.
- Recommended direction: use Storefront GraphQL for customer-facing app data whenever possible, and reserve Admin REST for mentor-required endpoints or operations not exposed by Storefront.

## Recommended Mentor Dashboard Plan

1. Stabilize `master` with shared packages: `shopify-network`, `Common`, app target package wiring, Firebase config.
2. Merge `feature/common` into the integration baseline before feature modules depend on Common UI.
3. Merge `feature/auth` after registration, guest mode, and login are verified together.
4. Ask Mazen to reconcile `feature/home`, `feature/home-ui`, and `feature/home-logic`; `feature/home-logic` appears to be the real latest home branch.
5. Ask Mina to rebase or merge `master` into `feature/productDetails` before continuing product detail work.
6. Create task branches from the correct feature branch:
   - `task/auth-login`
   - `task/auth-registration`
   - `task/auth-guest-mode`
   - `task/home-data`
   - `task/home-domain`
   - `task/home-presentation`
   - `task/product-details-data`
   - `task/product-details-domain`
   - `task/product-details-presentation`
7. Require each task PR to include: scope, screenshots if UI, tests or verification notes, and linked Jira issue.

## Definition Of Done For Current Assignment

Registration:

- User can enter first name, last name, email, password, and confirmation.
- Invalid input blocks submission with user-visible messages.
- Firebase account is created.
- Verification email is sent.
- Shopify customer creation/search strategy is agreed with the team because the spec expects Shopify customer identity linkage.
- On success, app navigates to login or authenticated flow according to mentor decision.

Guest mode:

- User can continue without sign-in.
- App stores a guest session.
- Guest can browse home, categories, search, and product details.
- Guest cannot use wishlist/cart/checkout; app shows sign-in prompt before those actions.

Verification status:

- `git fetch --all --prune` succeeded and remote branch data is current.
- Plain `swift build` is not a valid final verification path for this package because it targets macOS by default while the package is iOS/Firebase/GoogleSignIn based.
- `swift test` hits the same macOS-target limitation before running assertions.
- `xcodebuild` could not run because the active developer directory is Command Line Tools, not full Xcode.
- Final build verification should be run in Xcode or after `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`.
