import SwiftUI

struct GameView: View {
    @State private var isRulesOpen = false
    let game: Game
    let nextButtonAction: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()

                Text(game.name)
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 200)
                    .padding(.horizontal, 32)

                Spacer()

                if let text = game.text {
                    GameTextView(text: text)
                        .offset(x: -30)
                        .frame(minHeight: 180)

                    Spacer()
                }

                ColoredImage(imageName: game.imageName)
                    .frame(
                        width: 0.355 * UIScreen.main.bounds.height,
                        height: 0.237 * UIScreen.main.bounds.height
                    )

                Spacer()
                Spacer()

                if game.rules != nil {
                    openRulesIndicator
                }
            }

            nextButton

            if let rules = game.rules {
                RulesModalView(isOpen: $isRulesOpen, name: game.name, rules: rules)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var openRulesIndicator: some View {
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
}
