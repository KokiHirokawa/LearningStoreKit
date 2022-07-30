import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Button {
                // - TODO: Purchase 100 coins
            } label: {
                Text("100 coins (StoreKit 1)")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: 200, height: 64)
            }
            .background(Color.black)
            .cornerRadius(8)
            .foregroundColor(Color.white)

            Button {
                Task {
                    await viewModel.purchase2()
                }
            } label: {
                Text("100 coins (StoreKit 2)")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: 200, height: 64)
            }
            .background(Color.black)
            .cornerRadius(8)
            .foregroundColor(Color.white)

            Label {
                Text("\(viewModel.coinAmount) coins")
            } icon: {
                Image(systemName: "coloncurrencysign.circle")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
