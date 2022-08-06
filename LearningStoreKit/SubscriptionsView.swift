import StoreKit
import SwiftUI

struct SubscriptionsView: View {
    @EnvironmentObject var store: ContentViewModel

    var body: some View {
        Group {
            if let currentSubscription = store.currentSubscription {
                Section("My Subscription") {
                    Text(currentSubscription.displayName)
                        .foregroundColor(.orange)
                }
            }

            Section("Auto-Renewable Subscription") {
                ForEach(store.subscriptions) { subscription in
                    Text(subscription.displayName)
                }
            }
        }
    }
}
