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
            }
        )
    }
}
