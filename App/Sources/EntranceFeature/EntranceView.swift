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
        Group {
            if viewStore.isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                VStack {
                    Text("Hello World!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.bottom], 48)

                    ForEach(viewStore.subscriptions) { subscription in
                        Button {
                            viewStore.send(.subscribe(subscription))
                        } label: {
                            Text(subscription.displayName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            // - TODO: Show price
                        }
                        .frame(width: 300, height: 48, alignment: .center)
                        .background(.white)
                        .cornerRadius(12)
                        .padding([.horizontal], 32)
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
                .init(id: "1", displayName: "???????????????????????????1?????????", rawValue: nil),
                .init(id: "2", displayName: "???????????????????????????1??????", rawValue: nil)
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
