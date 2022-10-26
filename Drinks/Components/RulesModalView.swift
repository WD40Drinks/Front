import SwiftUI

struct RulesModalView: View {

    static let snapRatio: CGFloat = 0.25

    // MARK: - Properties

    @Binding var isOpen: Bool
    @GestureState private var translation: CGFloat = 0
    @Environment(\.appColor) var color
    let name: String
    let rules: String

    private var maxHeight: CGFloat { 0.90 * UIScreen.main.bounds.height }
    private var offset: CGFloat { isOpen ? 0 : maxHeight }

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 40) {
                closeRulesIndicator
                content
            }
            .frame(width: UIScreen.main.bounds.width, height: self.maxHeight, alignment: .top)
            .background(color.secondary)
            .cornerRadius(20)
        }
        .frame(height: UIScreen.main.bounds.height, alignment: .bottom)
        .offset(y: max(self.offset + self.translation, 0))
        .animation(.interactiveSpring(), value: self.translation)
        .gesture(
            DragGesture().updating(self.$translation) { value, state, _ in
                state = value.translation.height
            }.onEnded { value in
                let snapDistance = self.maxHeight * Self.snapRatio
                guard abs(value.translation.height) > snapDistance else {
                    return
                }
                self.isOpen = value.translation.height < 0
            }
        )
    }

    private var content: some View {
        VStack(spacing: 30) {
            Text(name)
                .font(.App.title)
                .multilineTextAlignment(.center)
            Text(rules)
                .font(.App.paragraph)
        }
        .padding(.horizontal, 40)
    }

    

    private var closeRulesIndicator: some View {
        VStack(spacing: 10) {
            Text("close")
                .font(.App.paragraph)
            Image("modal-arrow")
                .resizable()
                .frame(width: 56, height: 15)
                .rotationEffect(.degrees(180))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 60)
        .onTapGesture { withAnimation { isOpen.toggle() } }
    }
}
