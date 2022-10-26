import SwiftUI

struct ErrorView: View {
    let tryAgainButtonAction: () -> Void

    var body: some View {
        VStack {
            Text("view-not-loaded")
            Button(action: tryAgainButtonAction, label: {
                Text("try-again")
            })
        }
        .padding()
    }
}
