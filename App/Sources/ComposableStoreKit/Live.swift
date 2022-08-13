import ComposableArchitecture
import StoreKit

extension StoreKitClient {
    public static func live() -> Self {
        Self(
            fetchProducts: { productIDs in
                Effect.task {
                    let products = try await StoreKit.Product.products(for: productIDs)
                    return products
                        .map {
                            Product(
                                id: $0.id,
                                displayName: $0.displayName,
                                rawValue: $0
                            )
                        }
                }
            },
            purchase: { product in
                Effect
                    .task {
                        guard let product = product.rawValue else {
                            fatalError("Development error")
                        }

                        let result = try await product.purchase()
                        switch result {
                        case let .success(verificationResult):
                            switch verificationResult {
                            case let .verified(transaction):
                                await transaction.finish()
                                return

                            case .unverified:
                                throw PurchaseError.unverified
                            }

                        case .pending:
                            throw PurchaseError.pending

                        case .userCancelled:
                            throw PurchaseError.userCancelled

                        @unknown default:
                            throw PurchaseError.unknown
                        }
                    }
            },
            fetchCurrentEntitlements: {
                Effect.task {
                    var currentEntitlements: [StoreKitClient.VerificationResult<StoreKitClient.Transaction>] = []

                    for await result in StoreKit.Transaction.currentEntitlements {
                        switch result {
                        case let .verified(transaction):
                            let _transaction = StoreKitClient.Transaction(
                                productType: transaction.productType
                            )
                            currentEntitlements.append(.verified(_transaction))
                        case .unverified:
                            currentEntitlements.append(.unverified)
                        }
                    }

                    return currentEntitlements
                }
            }
        )
    }
}
