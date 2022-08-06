import StoreKit
import SwiftUI

struct AvailableSubscriptionView: View {
    @EnvironmentObject var viewMode: ContentViewModel

    let subscription: Product

    var body: some View {
        HStack {
            HStack {
                Text(subscription.displayName)
                    .bold()

                Spacer()

                Button {
                    Task {
                        await subscribe()
                    }
                } label: {
                    Text(subscription.displayPrice)
                }

            }
        }
    }

    private func subscribe() async {
        await viewMode.purchase2(subscription)
    }
}
