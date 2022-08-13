import ComposableArchitecture
import StoreKit

public struct StoreKitClient {
    public var fetchProducts: (Set<String>) -> Effect<[Product], Error>
    public var fetchPurchasedProductIDs: () -> Effect<[Product.ID], Never>
    public var purchase: (Product) -> Effect<Void, Error> // - FIXME: Effect<Void, PurchaseError>
}

extension StoreKitClient {
    public struct Product: Equatable, Identifiable {
        public typealias ID = String

        public var id: ID
        public var displayName: String
        public var rawValue: StoreKit.Product?
    }
}

extension StoreKitClient {
    public enum PurchaseError: Error {
        case userCancelled
        case pending
        case unverified
        case unknown
    }
}
