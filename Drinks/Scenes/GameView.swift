import SwiftUI

struct GameView: View {
    @State private var isRulesOpen = false
    @State private var isShowingSuggestion = false
    @State private var isShowingInteractiveGame = false
    let game: Game

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

            suggestion
            rulesModal
            interactiveGame
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation { isShowingSuggestion = true }
        }
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
            .onTapGesture {
                withAnimation { isShowingInteractiveGame.toggle() }
            }
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

    @ViewBuilder
    private var suggestion: some View {
        if
            isShowingSuggestion,
            let suggestion = game.suggestions?.randomElement()
        {
            SuggestionView(text: suggestion)
                .zIndex(5) // fix open/close animation bug
        }
    }

    @ViewBuilder
    private var rulesModal: some View {
        if let rules = game.rules {
            RulesModalView(isOpen: $isRulesOpen, name: game.name, rules: rules)
                .zIndex(6) // over the suggestions
        }
    }

    @ViewBuilder
    private var interactiveGame: some View {
        if
            let token = game.minigameToken,
            isShowingInteractiveGame
        {
            switch token {
            case .prompt:
                PromptView(isShowing: $isShowingInteractiveGame)
                    .background(.black.opacity(0.9))
                    .onTapGesture {
                        withAnimation { isShowingInteractiveGame = false }
                    }
                    .gesture(DragGesture()) // avoid changing game while interactive is open
            }
        }
    }
}
