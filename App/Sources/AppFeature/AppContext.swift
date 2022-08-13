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
        return environment.storeKit.fetchCurrentEntitlements()
            .map {
                $0.contains {
                    switch $0 {
                    case .unverified:
                        return false
                    case let .verified(transaction):
                        return transaction.productType == .autoRenewable
                    }
                }
            }
            .map { AppAction.appDelegate(.initialized($0)) } // - FIXME: Create appDelegateReducer

    case let .appDelegate(.initialized(isSubscribingUser)):
        if !isSubscribingUser {
            state.entrance = .init()
        }
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
