import ComposableArchitecture
import SwiftUI

public struct PremiumView: View {

    @ObservedObject var viewStore: ViewStore<PremiumViewState, PremiumAction>

    public init(store: Store<PremiumState, PremiumAction>) {
        self.viewStore = ViewStore(store.scope(state: PremiumViewState.init))
    }

    public var body: some View {
        Text("Premium")
            .onAppear {
                viewStore.send(.onAppear)
            }
    }
}

struct PremiumViewState: Equatable {
    init(state: PremiumState) {}
}

public struct PremiumState {
    public init() {}
}

public enum PremiumAction {
    case onAppear
    case subscribe
}

public struct PremiumEnvironment {
    public init() {}
}

public let premiumReducer = Reducer<PremiumState, PremiumAction, PremiumEnvironment>
    .combine(
        .init { state, action, environment in
            switch action {
            case .onAppear:
                print("onAppear")
                return .none
            case .subscribe:
                return .none
            }
        }
    )
