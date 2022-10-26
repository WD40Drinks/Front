import SwiftUI

struct GameView: View {
    let game: Game
    let nextButtonAction: () -> Void

    private var screen: CGSize { UIScreen.main.bounds.size }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()

                Text(game.name)
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 200)
                    .background(.red)
                    .padding(.horizontal, 32)

                Spacer()

                if let text = game.text {
                    GameTextView(text: text)
                        .offset(x: -30)
                        .frame(minHeight: 180)
                        .background(.blue)

                    Spacer()
                }

                ColoredImage(imageName: game.imageName)
                    .frame(width: 0.355 * screen.height, height: 0.237 * screen.height)
                    .background(.orange)

                Spacer()
            }

            nextButton

            if let rules = game.rules {
                RulesModalView(name: game.name, rules: rules)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var nextButton: some View {
        Image("next-fish")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 122, height: 45)
            .padding(10)
            .onTapGesture(perform: self.nextButtonAction)
            .position(
                x: UIScreen.main.bounds.width,
                y: UIScreen.main.bounds.height - 150
            )
    }
}
