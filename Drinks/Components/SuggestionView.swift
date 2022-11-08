import SwiftUI

struct SuggestionView: View {
    let text: String
    @State private var isSuggestionOpen = false
    @State private var isTextShowing = false

    var body: some View {
        ZStack(alignment: .center) {
            if isSuggestionOpen {
                Color.black.opacity(0.5)
            }

            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    if !isSuggestionOpen {
                        Text("suggestion")
                            .font(.App.footnote)
                            .offset(x: 35)
                    }

                    ColoredImage(imageName: "baiacu")
                }

                if isTextShowing {
                    Text(text)
                        .font(.App.paragraph)
                        .frame(maxWidth: 300)
                        .offset(y: -40)
                }
            }
            .frame(
                width: isSuggestionOpen ? 520 : 100,
                height: isSuggestionOpen ? 520 : 100
            )
            .position(framePosition)
        }
        .onTapGesture {
            if isSuggestionOpen {
                isTextShowing = false
                withAnimation { isSuggestionOpen = false }
            } else {
                withAnimation { isSuggestionOpen = true }
                withAnimation(.easeIn.delay(0.3)) { isTextShowing = true }
            }
        }
    }

    private var framePosition: CGPoint {
        if isSuggestionOpen {
            return CGPoint(
                x: UIScreen.main.bounds.width / 2 - 10,
                y: UIScreen.main.bounds.height - 300
            )
        } else {
            return CGPoint(
                x: 0,
                y: UIScreen.main.bounds.height - 120
            )
        }
    }
}
