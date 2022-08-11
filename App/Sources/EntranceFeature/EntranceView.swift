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
            } else {
                ForEach(viewStore.subscriptions) { subscription in
                    Button {
                        viewStore.send(.subscribe(subscription))
                    } label: {
                        Text("Test")
                    }
                }
            }
        }
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
            storeKit: .live() // - TODO: Replace with mock
        )
    }
}

enum EntranceView_Previews: PreviewProvider {
    static var previews: some View {
        EntranceView(
            store: .init(
                initialState: .init(),
                reducer: entranceReducer,
                environment: .noop
            )
        )
    }
}
#endif
