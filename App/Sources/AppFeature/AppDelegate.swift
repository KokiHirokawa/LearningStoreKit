import ComposableArchitecture
import ComposableStoreKit

public enum AppDelegateAction: Equatable {
    public typealias IsSubscribingUser = Bool

    case didFinishLaunching
    case initialized(IsSubscribingUser)
}

