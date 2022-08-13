import ComposableArchitecture

#if DEBUG
extension StoreKitClient {
    public static let noop = Self(
        fetchProducts: { _ in .none },
        purchase: { _ in .none },
        fetchCurrentEntitlements: { .none }
    )

    public static let failing = Self(
        fetchProducts: { _ in .unimplemented("\(Self.self).fetchProducts is unimplemented") },
        purchase: { _ in .unimplemented("\(Self.self).purchase is unimplemented") },
        fetchCurrentEntitlements: { .unimplemented("\(Self.self).fetchCurrentEntitlements is unimplemented") }
    )
}
#endif
