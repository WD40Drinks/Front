import SwiftUI

struct GameView: View {
    let game: Game
    let nextButtonAction: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(game.name)
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                if let text = game.text {
                    GameTextView(text: text)
                        .offset(x: -30)
                    Spacer()
                }
                ColoredImage(imageName: game.imageName)
                    .frame(width: 300, height: 200)
                Spacer()
                nextButton
            }

            RulesModalView {
                Text("Testing")
                    .font(.App.title)
            }
        }
    }

    private var nextButton: some View {
        HStack {
            Spacer()
            Button(action: nextButtonAction, label: {
                Text("next")
            })
            .padding(32)
        }
    }
}
