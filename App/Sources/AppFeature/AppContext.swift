import ComposableArchitecture
import EntranceFeature

public struct AppState {
    public var entrance: EntranceState?

    public init(
        entrance: EntranceState? = nil
    ) {
        self.entrance = entrance
    }
}

public enum AppAction {
    case appDelegate(AppDelegateAction)
    case entrance(EntranceAction)
}

private let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .appDelegate(.didFinishLaunching):
        // - FIXME: Check current subscription
        state.entrance = .init()
        return .none

    case .entrance(.succeededSubscribe):
        state.entrance = nil
        return .none

    default:
        return .none
    }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>
    .combine(
        entranceReducer
            .optional()
            .pullback(
                state: \.entrance,
                action: /AppAction.entrance,
                environment: \.entrance
            ),

        appReducerCore
    )
