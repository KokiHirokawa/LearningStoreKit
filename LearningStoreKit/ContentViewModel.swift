import StoreKit
import SwiftUI

final class ContentViewModel: ObservableObject {

    @Published private(set) var products: [SKProduct] = []
    @Published private(set) var products2: [Product] = []
    @Published private(set) var coinAmount: Int = 0

    private var updateListenerTask: Task<Void, Error>? = nil

    init() {
        updateListenerTask = listenForTransactions()

        Task {
            await requestProducts2()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    switch result {
                    case let .verified(transaction):
                        await transaction.finish()
                        await self?.succeedToPurchaseCoins()
                    case .unverified:
                        throw StoreError.failedVerification
                    }
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }

    func requestProducts() {}

    @MainActor
    func requestProducts2() async {
        do {
            let products = try await Product.products(for: [Const.oneHundredCoinsProductID])
            self.products2 = products
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func purchase2() async {
        guard let product = products2.first else {
            return
        }

        do {
            let result = try await product.purchase()
            switch result {
            case let .success(verification):
                switch verification {
                case let .verified(transaction):
                    await transaction.finish()
                    await succeedToPurchaseCoins()
                case .unverified:
                    print("Transaction failed verification")
                }
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            print("Failed purchase request: \(error)")
        }
    }

    @MainActor
    private func succeedToPurchaseCoins() {
        coinAmount = coinAmount + 100
    }
}

extension ContentViewModel {
    enum Const {
        fileprivate static let oneHundredCoinsProductID = "learning.coin.100"
    }
}

public enum StoreError: Error {
    case failedVerification
}
