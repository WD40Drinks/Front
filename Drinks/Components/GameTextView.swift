import SwiftUI

struct GameTextView: View {
    @Environment(\.appColor) var color: Color.App
    let text: String

    private let imageName: String = {
        Bool.random() ? "text-highlight" : "text-highlight2"
    }()

    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.App.paragraph)
                .frame(maxWidth: 250)
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color.primary)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 140)
        }
        .rotationEffect(.degrees(-4))
    }
}
