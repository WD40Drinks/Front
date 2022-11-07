import SwiftUI

struct SuggestionView: View {
    @State private var isOpen = false

    var body: some View {
        ZStack {
            Image("baiacu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: isOpen ? 520 : 100,
                    height: isOpen ? 520 : 100
                )
                .position(
                    x: isOpen ? UIScreen.main.bounds.width / 2 - 30 : 0,
                    y: UIScreen.main.bounds.height - (isOpen ? 300 : 120)
                )
                .animation(.linear, value: isOpen)
                .onTapGesture {
                    withAnimation { isOpen.toggle() }
                }

            if isOpen {
                Text("eu nunca fui expulso da sala de aula...")
                    .font(.App.paragraph)
            }
        }
    }
}
