import ComposableArchitecture
import EntranceFeature
import SwiftUI

struct AppViewState: Equatable {
    let isEntrancePresented: Bool

    init(state: AppState) {
        self.isEntrancePresented = state.entrance != nil
    }
}

public struct AppView: View {

    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppViewState, AppAction>

    public init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: AppViewState.init(state:)))
    }

    public var body: some View {
        Group {
            if viewStore.isEntrancePresented {
                IfLetStore(
                    store.scope(state: \.entrance, action: AppAction.entrance),
                    then: EntranceView.init(store:)
                )
            } else {
                Text("Hello World")
            }
        }
    }
}
