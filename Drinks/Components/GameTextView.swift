import SwiftUI

struct GameTextView: View {
    @Environment(\.appColor) var color: Color.App
    let text: String

    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.App.paragraph)
                .rotationEffect(.degrees(-4))
                .frame(maxWidth: 250)
            Image("text-highlight")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color.primary)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 140)
        }
    }
}
