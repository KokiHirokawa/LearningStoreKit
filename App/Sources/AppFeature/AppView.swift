import ComposableArchitecture
import EntranceFeature
import SwiftUI

public struct AppView: View {

    let store: Store<AppState, AppAction>

    public init(store: Store<AppState, AppAction>) {
        self.store = store
    }

    public var body: some View {
        TabView {
            PremiumView(store: store.scope(state: \.premium, action: AppAction.premium))
                .tabItem {
                    Text("Premium")
                }
        }
    }
}

public struct AppState {
    public var premium: PremiumState

    public init(
        premium: PremiumState = .init()
    ) {
        self.premium = premium
    }
}

public enum AppAction {
    case premium(PremiumAction)
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>
    .combine(
        premiumReducer
            .pullback(
                state: \AppState.premium,
                action: /AppAction.premium,
                environment: \.premium
            )
    )
