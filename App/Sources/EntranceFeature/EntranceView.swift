import Combine
import ComposableArchitecture
import ComposableStoreKit
import SwiftUI

struct EntranceViewState: Equatable {
    public var isLoading: Bool
    public var isSubscribeButtonEnabled: Bool
    public var subscriptions: [StoreKitClient.Product]

    init(state: EntranceState) {
        self.isLoading = state.isLoading
        self.isSubscribeButtonEnabled = state.isSubscribeButtonEnabled
        self.subscriptions = state.subscriptions
    }
}

public struct EntranceView: View {

    @ObservedObject var viewStore: ViewStore<EntranceViewState, EntranceAction>

    public init(store: Store<EntranceState, EntranceAction>) {
        self.viewStore = ViewStore(store.scope(state: EntranceViewState.init))
    }

    public var body: some View {
        VStack {
            if viewStore.isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                ForEach(viewStore.subscriptions) { subscription in
                    Button {
                        viewStore.send(.subscribe(subscription))
                    } label: {
                        Text(subscription.displayName)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(
            colors: [
                Color(red: 8 / 255, green: 25 / 255, blue: 45 / 255),
                Color.black
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

#if DEBUG
extension EntranceEnvironment {
    static var noop: Self {
        .init(
            mainQueue: .immediate,
            storeKit: .noop
        )
    }
}

enum EntranceView_Previews: PreviewProvider {
    static var previews: some View {
        var environment = EntranceEnvironment.noop
        environment.storeKit.fetchProducts = { _ in
            .init(value: [
                .init(id: "1", displayName: "プレミアムプラン（1ヶ月）", rawValue: nil),
                .init(id: "2", displayName: "プレミアムプラン（1年）", rawValue: nil)
            ])
        }
        return EntranceView(
            store: .init(
                initialState: .init(),
                reducer: entranceReducer,
                environment: environment
            )
        )
    }
}
#endif
