import SwiftUI

struct GameView: View {
    @State private var isRulesOpen = false
    let game: Game
    let nextButtonAction: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()
                gameName
                Spacer()
                gameText
                gameImage
                Spacer()
                Spacer()
                openRulesIndicator
            }

            nextButton
            suggestion
            rulesModal
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var gameName: some View {
        Text(game.name)
            .font(.App.title)
            .multilineTextAlignment(.center)
            .frame(minHeight: 200)
            .padding(.horizontal, 32)
    }

    @ViewBuilder
    private var gameText: some View {
        if let text = game.text {
            GameTextView(text: text)
                .offset(x: -30)
                .frame(minHeight: 180)

            Spacer()
        }
    }

    private var gameImage: some View {
        ColoredImage(imageName: game.imageName)
            .frame(
                width: 0.355 * UIScreen.main.bounds.height,
                height: 0.237 * UIScreen.main.bounds.height
            )
    }

    @ViewBuilder
    private var openRulesIndicator: some View {
        if game.rules != nil {
            VStack(spacing: 10) {
                Image("modal-arrow")
                    .resizable()
                    .frame(width: 56, height: 15)
                Text("rules")
                    .font(.App.paragraph)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 60)
            .onTapGesture { withAnimation { isRulesOpen.toggle() } }
            .gesture(
                DragGesture(minimumDistance: 50).onChanged { value in
                    let didDragVertically = abs(value.translation.height) > abs(value.translation.width)
                    let didDragUp = value.translation.height < 0
                    if didDragVertically && didDragUp {
                        withAnimation { isRulesOpen = true }
                    }
                }
            )
        }
    }

    private var nextButton: some View {
        VStack(spacing: 5) {
            Text("next")
                .font(.App.footnote)
                .offset(x: -35)
            Image("next-fish")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 122, height: 45)
        }
        .padding(10)
        .onTapGesture(perform: self.nextButtonAction)
        .position(
            x: UIScreen.main.bounds.width,
            y: UIScreen.main.bounds.height - 120
        )
    }

    @ViewBuilder
    private var suggestion: some View {
        if let suggestion = game.suggestions?.randomElement() {
            SuggestionView(text: suggestion)
                .zIndex(5) // fix open/close animation bug
        }
    }

    @ViewBuilder
    private var rulesModal: some View {
        if let rules = game.rules {
            RulesModalView(isOpen: $isRulesOpen, name: game.name, rules: rules)
        }
    }
}
