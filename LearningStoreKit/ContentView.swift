import SwiftUI

struct ContentView: View {
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
                // - TODO: Purchase 100 coins
            } label: {
                Text("100 coins (StoreKit 2)")
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: 200, height: 64)
            }
            .background(Color.black)
            .cornerRadius(8)
            .foregroundColor(Color.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
