import StoreKit
import SwiftUI

struct SubscriptionsView: View {
    @EnvironmentObject var store: ContentViewModel

    var body: some View {
        Group {
            Section("Auto-Renewable Subscription") {
                ForEach(store.subscriptions) { subscription in
                    Text(subscription.displayName)
                }
            }
        }
    }
}
