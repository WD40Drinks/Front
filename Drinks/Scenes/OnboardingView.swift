import SwiftUI

struct OnboardingView: View {
    enum OnboardingStates {
        case terms
        case swipe
    }

    var viewModel: ContentViewModel<MockGameFactory>
    @State private var state: OnboardingStates = .terms

    var body: some View {
        switch state {
        case .terms: TermsView(continueButtonAction: changeOnboardingStateToSwipe)
        case .swipe: SwipeView(viewModel: viewModel)
        }
    }

    func changeOnboardingStateToSwipe() {
        state = .swipe
    }
}

struct TermsView: View {
    @State private var showingTermsSheet = false
    let continueButtonAction: () -> Void


    var body: some View {
        VStack {
            VStack {
                Image("caneco")
                    .frame(
                        width: 0.355 * UIScreen.main.bounds.height,
                        height: 0.237 * UIScreen.main.bounds.height
                    )
                Text("Caneco")
                    .font(.App.title)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 200)
            }
            Text("continue-conditions")
                .font(.App.paragraph)
                .multilineTextAlignment(.center)
            VStack(spacing: 22) {
                ZStack {
                    Image("button-fill")
                    Text("continue-button")
                        .font(.App.paragraph)
                }
                .onTapGesture {
                    continueButtonAction()
                }
                ZStack {
                    Image("button")
                    Text("read-terms-button")
                        .font(.App.paragraph)
                }
                .onTapGesture {
                    showingTermsSheet.toggle()
                }
                .sheet(isPresented: $showingTermsSheet) {
                    NavigationView {
                        TermsSheetView()
                    }
                }
            }
        }
    }
}

struct TermsSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("terms-title-one")
                Text("terms-text-one")
                Text("terms-subtext-one")
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("terms-title-two")
                Text("terms-text-two")
                Text("terms-subtext-two")
            }
            VStack(alignment: .leading) {
                Text("terms-title-three")
            }
            HStack {
                Spacer()
                Image("fishes-circle")
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Termos e condições")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Ok") {
                    dismiss()
                }
            }
        }
    }
}

struct SwipeView: View {
    @State private var isRotating = 0.0
    var viewModel: ContentViewModel<MockGameFactory>

    var animation: Animation {
        Animation.linear
        .repeatForever(autoreverses: false)
    }

    var body: some View {
        VStack {
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

        }
        .gesture(startGameGesture)
    }

    private var startGameGesture: some Gesture {
        DragGesture().onEnded { value in
            guard !viewModel.isTransitioning else { return }
            let didSwipeHorizontally = abs(value.translation.width) > abs(value.translation.height)
            let didSwipeLeft = value.predictedEndTranslation.width < -60
            if didSwipeHorizontally && didSwipeLeft {
                viewModel.initiateGame()
            }
        }
    }
}
