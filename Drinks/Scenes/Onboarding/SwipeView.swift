import SwiftUI

struct SwipeView: View {
    @State private var isRotating = 0.0
    var viewModel: ContentViewModel<MockGameFactory>

    var animation: Animation {
        Animation.linear
        .repeatForever(autoreverses: false)
    }

    var body: some View {
        VStack {
            Spacer()
            Text("gather-circle")
                .font(.App.paragraph)
                .padding(.bottom, 40)
            VStack(spacing: 8) {
                Text("swipe-next")
                    .font(.App.title)
                Image("text-highlight")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.App.yellow.primary)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 140)
            }
            .padding(.bottom, 60)
            HStack {
                Spacer()
                VStack {
                    Image("arrow-left")
                    Image("swipe-gesture")
                        .animation(animation)
                        .padding(.trailing, 20)
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(0.7).repeatForever(autoreverses: false)) {
                                    isRotating = -45.0
                                }
                        }
                }
            }
            Spacer()
        }
    }
}
