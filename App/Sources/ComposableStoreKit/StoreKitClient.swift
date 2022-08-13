import ComposableArchitecture
import StoreKit

public struct StoreKitClient {
    public var fetchProducts: (Set<String>) -> Effect<[Product], Error>
    public var purchase: (Product) -> Effect<Void, Error> // - FIXME: Effect<Void, PurchaseError>
    public var fetchCurrentEntitlements: () -> Effect<[VerificationResult<Transaction>], Never>
}

extension StoreKitClient {
    public struct Product: Equatable, Identifiable {
        public typealias ID = String

        public var id: ID
        public var displayName: String
        public var rawValue: StoreKit.Product?
    }

    public struct Transaction: Equatable {
        public let productType: StoreKit.Product.ProductType
    }

    public enum VerificationResult<SignedType> {
        case verified(SignedType)
        case unverified
    }
}

extension StoreKitClient.VerificationResult: Equatable where SignedType: Equatable {}

extension StoreKitClient {
    public enum PurchaseError: Error {
        case userCancelled
        case pending
        case unverified
        case unknown
    }
}
