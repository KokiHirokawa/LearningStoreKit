import StoreKit

protocol UpdatedTransactionObserver: AnyObject {
    func updatedTransaction(_ transaction: SKPaymentTransaction)
}

class InAppPurchaseObserver: NSObject, SKPaymentTransactionObserver {
    static let shared = InAppPurchaseObserver()

    weak var delegate: UpdatedTransactionObserver?

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            delegate?.updatedTransaction(transaction)
        }
    }
}
