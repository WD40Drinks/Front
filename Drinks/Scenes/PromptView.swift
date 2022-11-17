import SwiftUI

struct PromptView: View {
    @State private var isRunning = false

    var body: some View {
        GeometryReader { proxy in
            Text("prompt")
                .font(.App.prompt)
                .foregroundColor(.white)
                .padding(32)
                .frame(width: 0.8 * proxy.size.height)
                .offset(y: (isRunning ? -1 : 1) * 0.5 * proxy.size.height)
                .animation(.linear(duration: 10), value: isRunning)
                .rotationEffect(.degrees(90))
                .background(.black.opacity(0.9))
        }
        .onAppear {
            withAnimation { isRunning = true }
        }
    }
}
