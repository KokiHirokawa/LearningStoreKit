import PremiumFeature
import SwiftUI

public struct RootView: View {

    public init() {}

    public var body: some View {
        TabView {
            PremiumView()
                .tabItem {
                    Text("Premium")
                }
        }
    }
}
