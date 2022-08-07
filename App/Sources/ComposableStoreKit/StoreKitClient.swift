import ComposableArchitecture
import StoreKit

public struct StoreKitClient {
    public var fetchProducts: (Set<String>) -> Effect<[Product], Error>
}

extension StoreKitClient {
    public struct Product: Equatable, Identifiable {
        public var id: String
        public var displayName: String
        public var rawValue: StoreKit.Product?
    }
}
