import StoreKit
import SwiftUI

final class ContentViewModel: NSObject, ObservableObject {

    @Published private(set) var products: [SKProduct] = []
    @Published private(set) var products2: [Product] = []
    @Published private(set) var coinAmount: Int = 0

    private var updateListenerTask: Task<Void, Error>? = nil

    private let inAppPurchaseObserver = InAppPurchaseObserver.shared

    override init() {
        super.init()

        inAppPurchaseObserver.delegate = self
        updateListenerTask = listenForTransactions()

        requestProducts()

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

    func requestProducts() {
        let request = SKProductsRequest(productIdentifiers: [Const.oneHundredCoinsProductID])
        request.delegate = self
        request.start()
    }

    @MainActor
    func requestProducts2() async {
        do {
            let products = try await Product.products(for: [Const.oneHundredCoinsProductID])
            self.products2 = products
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func purchase() {
        guard let product = products.first else {
            return
        }

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
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

extension ContentViewModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        guard !products.isEmpty else {
            return
        }
        DispatchQueue.main.async {
            self.products = products
        }
    }
}

extension ContentViewModel: UpdatedTransactionObserver {
    func updatedTransaction(_ transaction: SKPaymentTransaction) {
        let paymentQueue = SKPaymentQueue.default()

        switch transaction.transactionState {
        case .purchasing:
            break
        case .purchased:
            paymentQueue.finishTransaction(transaction)
            Task {
                await succeedToPurchaseCoins()
            }
        case .restored:
            paymentQueue.finishTransaction(transaction)
        case .deferred:
            break
        case .failed:
            paymentQueue.finishTransaction(transaction)
        @unknown default:
            break
        }
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