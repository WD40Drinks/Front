import SwiftUI

struct SuggestionView: View {
    @Environment(\.appColor) var color: Color.App
    let text: String
    @State private var isSuggestionOpen = false
    @State private var isTextShowing = false
    @Namespace private var namespace

    var body: some View {
        if isSuggestionOpen {
            suggestionOpen
        } else {
            suggestionClosed
        }
    }

    private var suggestionOpen: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.5)

            ZStack(alignment: .center) {
                buildColoredImage(imageName: "baiacu")
                    .frame(width: 520, height: 520)
                    .transition(.scale(scale: 0, anchor: .bottomLeading))

                Text(text)
                    .font(.App.paragraph)
                    .frame(maxWidth: 215)
                    .offset(y: -40)
            }
            .position(
                x: UIScreen.main.bounds.width / 2 - 10,
                y: UIScreen.main.bounds.height - 300
            )
        }
        .onTapGesture {
            isTextShowing = false
            withAnimation { isSuggestionOpen = false }
        }
        .transition(.opacity)
    }

    private var suggestionClosed: some View {
        VStack(spacing: 0) {
            Text("suggestion")
                .font(.App.footnote)
                .offset(x: 35, y: 8)
            buildColoredImage(imageName: "suggestion")
                .frame(width: 100, height: 100)
        }
        .position(x: 0, y: UIScreen.main.bounds.height - 120)
        .onTapGesture {
            withAnimation { isSuggestionOpen = true }
            withAnimation(.easeIn.delay(0.3)) { isTextShowing = true }
        }
    }

    @ViewBuilder
    private func buildColoredImage(imageName: String) -> some View {
        ZStack {
            Image("\(imageName)-color")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(color.primary)
                .matchedGeometryEffect(id: "image-color", in: namespace)
            Image("\(imageName)-foreground")
                .resizable()
                .matchedGeometryEffect(id: "image-foreground", in: namespace)
        }
        .aspectRatio(contentMode: .fit)
    }
}
