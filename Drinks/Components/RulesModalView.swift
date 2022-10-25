import SwiftUI

struct RulesModalView<Content: View>: View {

    static var snapRatio: CGFloat { 0.25 }
    static var maxHeightRatio: CGFloat { 0.90 }

    // MARK: - Properties

    @State var isOpen: Bool = true
    @GestureState private var translation: CGFloat = 0
    @Environment(\.appColor) var color
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    private var maxHeight: CGFloat {
        Self.maxHeightRatio * UIScreen.main.bounds.height
    }

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight
    }

    var body: some View {
        VStack(spacing: 20) {
            if !isOpen {
                VStack(spacing: 10) {
                    Image("modal-arrow")
                        .resizable()
                        .frame(width: 56, height: 15)
                    Text("rules")
                        .font(.App.paragraph)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 60)
                .onTapGesture { withAnimation { isOpen.toggle() } }
            }

            VStack(spacing: 40) {
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

                content
            }
            .frame(width: UIScreen.main.bounds.width, height: self.maxHeight, alignment: .top)
            .background(color.primary)
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
}
