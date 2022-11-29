import SwiftUI

struct ErrorView: View {
    @Environment(\.appColor) var color: Color.App
    let tryAgainButtonAction: () -> Void

    var body: some View {
        VStack {
            Text("view-not-loaded")
                .font(.App.title)
                .multilineTextAlignment(.center)
            Button(action: tryAgainButtonAction, label: {
                Text("try-again")
                    .font(.App.paragraph)
                    .foregroundColor(.black)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(color.primary, lineWidth: 5)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(color.secondary))
                    )
            })
        }
        .padding()
    }
}
